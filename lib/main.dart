import 'package:flutter/material.dart';
import 'package:my_best_ramadhan_app/screens/splash_screen.dart';

/// MAIN.DART
/// Ini adalah file pertama yang dijalankan saat aplikasi dibuka
/// runApp() akan menjalankan MyApp widget
void main() {
  runApp(const MyApp());
}

/// MyApp adalah root widget dari aplikasi
/// Di sini kita setup theme, routing, dan home screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nama aplikasi
      title: 'My Best Ramadhan',
      
      // Hilangkan banner "DEBUG" di pojok kanan atas
      debugShowCheckedModeBanner: false,
      
      // Theme aplikasi (warna, font, dll)
      theme: ThemeData(
        // Color scheme utama aplikasi
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF32D74B), // primary_green
          primary: const Color(0xFF32D74B),
          secondary: const Color(0xFF63E677), // light_green
        ),
        
        // Gunakan Material 3 (design system terbaru dari Google)
        useMaterial3: true,
        
        // Font family (nanti bisa diganti dengan font custom)
        fontFamily: 'Poppins', // TODO: Tambahkan font Poppins ke pubspec.yaml
        
        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF32D74B),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        
        // Floating action button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF32D74B),
          foregroundColor: Colors.white,
        ),
        
        // Input decoration theme (untuk TextField)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF32D74B),
              width: 2,
            ),
          ),
        ),
      ),
      
      // Home screen adalah SplashScreen
      home: const SplashScreen(),
    );
  }
}