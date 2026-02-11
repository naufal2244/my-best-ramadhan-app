import 'package:flutter/material.dart';

/// APP COLORS
/// File ini menyimpan semua warna yang digunakan di aplikasi
/// Dengan begini, kita bisa ubah warna di satu tempat dan akan berubah di seluruh aplikasi
class AppColors {
  // Private constructor agar class ini tidak bisa di-instantiate
  AppColors._();

  /// Primary Colors - Warna utama aplikasi
  static const Color primaryGreen = Color(0xFF32D74B);
  static const Color lightGreen = Color(0xFF63E677);
  static const Color softGreenBg = Color(0xFFE8F9EC);
  
  /// Neutral Colors - Warna netral untuk text, background, dll
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  
  /// Semantic Colors - Warna untuk status tertentu
  static const Color success = Color(0xFF32D74B);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color info = Color(0xFF007AFF);
  
  /// Gradient - Untuk background atau elemen dekoratif
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient verticalGradient = LinearGradient(
    colors: [primaryGreen, lightGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}