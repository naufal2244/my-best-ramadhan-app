import 'package:firebase_auth/firebase_auth.dart';

class SecurityUtils {
  /// Validasi email menggunakan Regular Expression yang standar
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi password: Min 8 karakter, 1 Huruf Besar, 1 Angka
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Harus mengandung minimal 1 huruf besar';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Harus mengandung minimal 1 angka';
    }
    return null;
  }

  /// Mengubah Firebase Error Code menjadi pesan yang ramah user (dan aman)
  static String sanitizeErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email atau kata sandi salah.';
        case 'email-already-in-use':
          return 'Email sudah digunakan oleh akun lain.';
        case 'weak-password':
          return 'Kata sandi terlalu lemah.';
        case 'requires-recent-login':
          return 'Sesi berakhir. Silakan login ulang untuk melakukan aksi ini.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan gagal. Silakan coba lagi nanti.';
        case 'network-request-failed':
          return 'Koneksi internet bermasalah.';
        default:
          return 'Terjadi kesalahan pada sistem. Silakan coba lagi.';
      }
    }
    return 'Terjadi kesalahan sistem.';
  }
}
