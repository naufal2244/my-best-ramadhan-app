/// APP CONSTANTS
/// File ini menyimpan semua konstanta yang digunakan di aplikasi
/// seperti spacing, border radius, font size, dll
class AppConstants {
  AppConstants._();

  /// App Info
  static const String appName = 'My Best Ramadhan';
  static const String appTagline = 'Jadikan Ramadhan Tahun ini\nRamadhan terbaik mu!';
  
  /// Spacing - Jarak antar element
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  /// Border Radius - Kelengkungan sudut
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusCircle = 999.0;
  
  /// Font Sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 24.0;
  static const double fontSizeXXL = 32.0;
  
  /// Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  
  /// Button Heights
  static const double buttonHeightS = 44.0;
  static const double buttonHeightM = 54.0;
  static const double buttonHeightL = 64.0;
  
  /// Logo Sizes
  static const double logoSizeS = 80.0;
  static const double logoSizeM = 120.0;
  static const double logoSizeL = 140.0;
  
  /// Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  /// API (nanti akan digunakan saat connect ke backend)
  static const String baseUrl = 'https://api.mybestramadhan.com'; // TODO: Ganti dengan URL backend yang sebenarnya
  static const Duration apiTimeout = Duration(seconds: 30);
}