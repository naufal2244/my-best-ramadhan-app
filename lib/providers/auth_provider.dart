import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userData;
  bool _isLoading = false;
  DateTime _ramadhanStartDate = DateTime(2026, 2, 19); // Default
  int _totalRamadhanDays = 30;

  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  DateTime get ramadhanStartDate => _ramadhanStartDate;
  int get totalRamadhanDays => _totalRamadhanDays;
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  AuthProvider() {
    // Pantau status login secara otomatis saat provider dibuat
    _authService.userStream.listen((User? user) async {
      if (user != null) {
        await fetchUserData(user.uid);
      } else {
        _userData = null;
        notifyListeners();
      }
    });
    fetchRamadhanConfig();
  }

  /// Ambil metadata Ramadhan dari Firestore
  Future<void> fetchRamadhanConfig() async {
    try {
      debugPrint("Fetching ramadhan config from Firestore...");
      final doc =
          await _firestore.collection('metadata').doc('ramadhan_config').get();
      if (doc.exists) {
        final data = doc.data()!;
        debugPrint("Ramadhan config data: $data");
        if (data['startDate'] != null) {
          _ramadhanStartDate = (data['startDate'] as Timestamp).toDate();
          debugPrint("Parsed startDate: $_ramadhanStartDate");
        }
        if (data['totalDays'] != null) {
          _totalRamadhanDays = data['totalDays'];
          debugPrint("Parsed totalDays: $_totalRamadhanDays");
        }
        notifyListeners();
      } else {
        debugPrint("Ramadhan config document does not exist in Firestore!");
      }
    } catch (e) {
      debugPrint("Error fetching ramadhan config: $e");
    }
  }

  /// Ambil data detail user dari Firestore
  Future<void> fetchUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userData = await _authService.getUserData(uid);
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.loginWithEmail(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register
  Future<void> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.registerWithEmail(email, password, name);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.signOut();
    _userData = null;
    notifyListeners();
  }

  /// Update Nama Profil
  Future<void> updateProfileName(String newName) async {
    if (_userData == null) return;

    try {
      await _firestore.collection('users').doc(_userData!.uid).update({
        'displayName': newName,
      });
      _userData = _userData!.copyWith(displayName: newName);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update Target Khatam
  Future<void> updateTargetKhatam(int newTarget, double dailyJuzTarget) async {
    if (_userData == null) return;
    try {
      await _firestore.collection('users').doc(_userData!.uid).update({
        'targetKhatam': newTarget,
        'dailyJuzTarget': dailyJuzTarget,
      });
      _userData = _userData!.copyWith(
        targetKhatam: newTarget,
        dailyJuzTarget: dailyJuzTarget,
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update Total Juz yang Selesai
  Future<void> updateCompletedJuz(double delta) async {
    if (_userData == null) return;

    try {
      double newCompleted = (_userData!.completedJuz + delta).clamp(0.0, 600.0);
      await _firestore.collection('users').doc(_userData!.uid).update({
        'completedJuz': newCompleted,
      });
      _userData = _userData!.copyWith(completedJuz: newCompleted);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update Status Tutorial
  Future<void> setHasSeenTutorial(bool seen) async {
    if (_userData == null) return;

    try {
      await _firestore.collection('users').doc(_userData!.uid).update({
        'hasSeenTutorial': seen,
      });
      _userData = _userData!.copyWith(hasSeenTutorial: seen);
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating tutorial status: $e");
    }
  }

  /// Update Status Tutorial Awal (Masuk Home Pertama Kali)
  Future<void> setHasSeenInitialTutorial(bool seen) async {
    if (_userData == null) return;

    try {
      await _firestore.collection('users').doc(_userData!.uid).update({
        'hasSeenInitialTutorial': seen,
      });
      _userData = _userData!.copyWith(hasSeenInitialTutorial: seen);
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating initial tutorial status: $e");
    }
  }

  /// Ganti Password
  Future<void> updatePassword(String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }

  /// Reset Password - Kirim email reset password
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
