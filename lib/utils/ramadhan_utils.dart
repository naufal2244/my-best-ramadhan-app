import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class RamadhanUtils {
  /// Mendapatkan hari ke-berapa Ramadhan berdasarkan tanggal mulai
  static int getCurrentRamadhanDay(DateTime startDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);

    // Jika sekarang sebelum ramadhan, return 0
    if (today.isBefore(start)) return 0;

    // +1 karena hari pertama adalah index 1
    return today.difference(start).inDays + 1;
  }

  /// Menghitung sisa hari Ramadhan
  static int getRemainingDays(DateTime startDate, int totalDays) {
    int currentDay = getCurrentRamadhanDay(startDate);
    if (currentDay == 0) return totalDays;

    int remaining = totalDays - (currentDay - 1);
    return remaining > 0 ? remaining : 0;
  }

  /// Menghitung target harian yang dinamis
  static double calculateDailyTarget({
    required int totalTargetKhatam,
    required double completedJuz,
    required DateTime startDate,
    required int totalRamadhanDays,
  }) {
    int totalTargetJuz = totalTargetKhatam * 30;
    double remainingJuz = totalTargetJuz - completedJuz;
    int remainingDays = getRemainingDays(startDate, totalRamadhanDays);

    if (remainingDays <= 0) return 0;

    int currentDay = getCurrentRamadhanDay(startDate);

    double dailyTarget = remainingJuz / remainingDays;

    // Bersihkan floating point error (misal 2.000000000004 -> 2.0)
    dailyTarget = double.parse(dailyTarget.toStringAsFixed(8));

    if (kDebugMode) debugPrint("=== calculateDailyTarget ===");
    if (kDebugMode) debugPrint("startDate: $startDate");
    if (kDebugMode) debugPrint("totalRamadhanDays: $totalRamadhanDays");
    if (kDebugMode) debugPrint("currentDay: $currentDay");
    if (kDebugMode) debugPrint("totalTargetKhatam: $totalTargetKhatam");
    if (kDebugMode) debugPrint("totalTargetJuz: $totalTargetJuz");
    if (kDebugMode) debugPrint("completedJuz: $completedJuz");
    if (kDebugMode) debugPrint("remainingJuz: $remainingJuz");
    if (kDebugMode) debugPrint("remainingDays: $remainingDays");
    if (kDebugMode) debugPrint("dailyTarget: $dailyTarget");
    if (kDebugMode) debugPrint("===========================");
    return dailyTarget;
  }

  /// Memformat double juz menjadi "X Juz Y Halaman"
  static String formatJuzTarget(double juz) {
    if (juz <= 0) return "0 Juz";

    int wholeJuz = juz.floor();
    // Menggunakan 20.13333333 (604/30) sebagai standar halaman per juz
    double pagesPerJuz = 604 / 30;
    double exactRemainingHalaman = (juz - wholeJuz) * pagesPerJuz;

    // Bersihkan floating point error sebelum ceil
    // Ini krusial agar 0.000000000001 tidak jadi 1 halaman
    double cleanRemainingHalaman =
        double.parse(exactRemainingHalaman.toStringAsFixed(6));
    int roundedHalaman = cleanRemainingHalaman.ceil();

    if (wholeJuz > 0 && roundedHalaman > 0) {
      return "$wholeJuz Juz $roundedHalaman Halaman";
    } else if (wholeJuz > 0) {
      return "$wholeJuz Juz";
    } else {
      return "$roundedHalaman Halaman";
    }
  }

  /// Menghitung sisa halaman per shalat dalam format "X halaman Y baris"
  static String formatPagePerPrayer(double juz) {
    // 1 Juz = ~20.133 halaman. 1 Halaman = 15 baris.
    double totalPages = juz * (604 / 30);
    double pagesPerPrayer = totalPages / 5;

    int wholePages = pagesPerPrayer.floor();
    double fractionalPage = pagesPerPrayer - wholePages;

    // Hitung sisa baris (15 baris per halaman)
    int lines = (fractionalPage * 15).ceil();

    if (wholePages > 0 && lines > 0) {
      return "$wholePages halaman $lines baris";
    } else if (wholePages > 0) {
      return "$wholePages halaman";
    } else {
      return "$lines baris";
    }
  }
}
