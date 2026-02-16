import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  List<QuoteModel> _quotes = [];
  List<QuoteModel> get quotes => _quotes;

  Future<void> initialize() async {
    await _notificationService.initialize();
  }

  Future<void> fetchAndScheduleNotifications() async {
    try {
      // Pastikan inisialisasi (termasuk timezone) selesai dulu
      await initialize();

      // 1. Fetch all data from Firestore
      if (kDebugMode) debugPrint("🔔 Memulai fetch quotes dari Firestore...");
      final snapshot = await _firestore.collection('quotes').get();

      if (snapshot.docs.isNotEmpty) {
        _quotes = snapshot.docs
            .map((doc) => QuoteModel.fromMap(doc.id, doc.data()))
            .toList();

        if (kDebugMode)
          debugPrint("🔔 Berhasil fetch ${_quotes.length} quotes.");

        // 2. Hapus semua jadwal lama agar tidak bentrok
        await _notificationService.cancelAllNotifications();

        // 3. Jadwalkan dalam batch untuk 3 hari ke depan (solusi offline)
        await _notificationService.scheduleBatchNotifications(quotes: _quotes);
      } else {
        if (kDebugMode) debugPrint("⚠️ Koleksi 'quotes' kosong di Firestore!");
      }
    } catch (e) {
      if (kDebugMode) debugPrint("Error fetching quotes: $e");
    }
  }
}
