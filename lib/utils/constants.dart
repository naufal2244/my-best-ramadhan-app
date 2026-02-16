/// APP CONSTANTS
/// File ini menyimpan semua konstanta yang digunakan di aplikasi
/// seperti spacing, border radius, font size, dll
class AppConstants {
  AppConstants._();

  /// App Info
  static const String appName = 'My Best Ramadhan';
  static const String appTagline =
      'Jadikan Ramadhan Tahun ini\nRamadhan terbaik mu!';

  /// Spacing - Jarak antar element
  static const double spacingXS = 4.0;
  static const double spacingS = 6.0; // Reduced from 8
  static const double spacingM = 10.0; // Reduced from 12
  static const double spacingL = 14.0; // Reduced from 16
  static const double spacingXL = 20.0; // Reduced from 24
  static const double spacingXXL = 28.0; // Reduced from 32

  /// Border Radius - Kelengkungan sudut
  static const double radiusS = 6.0; // Reduced from 8
  static const double radiusM = 10.0; // Reduced from 12
  static const double radiusL = 14.0; // Reduced from 16
  static const double radiusXL = 20.0; // Reduced from 24
  static const double radiusCircle = 999.0;

  /// Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 11.0; // Reduced from 12
  static const double fontSizeM = 13.0; // Reduced from 14
  static const double fontSizeL = 15.0; // Reduced from 16
  static const double fontSizeXL = 18.0; // Reduced from 20
  static const double fontSizeXXL = 22.0; // Reduced from 24

  /// Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  /// Button Heights
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  /// Logo Sizes
  static const double logoSizeS = 80.0;
  static const double logoSizeM = 120.0;
  static const double logoSizeL = 140.0;

  /// Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// API (nanti akan digunakan saat connect ke backend)
  static const String baseUrl =
      'https://api.mybestramadhan.com'; // TODO: Ganti dengan URL backend yang sebenarnya
  static const Duration apiTimeout = Duration(seconds: 30);
}
