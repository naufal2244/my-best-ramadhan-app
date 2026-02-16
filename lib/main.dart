import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/habit_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/onboarding_flow.dart';
import 'screens/main/main_screen.dart';
import 'screens/main/edit_profile_screen.dart';
// import 'screens/home_screen.dart'; // TODO: buat nanti

/// MAIN.DART
/// Ini adalah file pertama yang dijalankan saat aplikasi dibuka
/// runApp() akan menjalankan MyApp widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// MyApp adalah root widget dari aplikasi
/// Di sini kita setup theme, routing, dan home screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(
            create: (_) => NotificationProvider()..initialize()),
      ],
      child: MaterialApp(
        // Nama aplikasi
        title: 'MyBest Ramadhan',

        // Hilangkan banner "DEBUG" di pojok kanan atas
        debugShowCheckedModeBanner: false,

        // Global Builder to clamp text scaling
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.textScalerOf(context)
                  .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.2),
            ),
            child: child!,
          );
        },

        // Theme aplikasi (warna, font, dll)
        theme: ThemeData(
          // Color scheme utama aplikasi
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF32D74B), // primary_green
            primary: const Color(0xFF32D74B),
            secondary: const Color(0xFF63E677), // light_green
          ),

          primaryColor: const Color(0xFF32D74B),
          scaffoldBackgroundColor: Colors.white,

          // Gunakan Material 3 (design system terbaru dari Google)
          useMaterial3: true,

          // Font family
          fontFamily: 'Poppins',

          // App bar theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1A1A1A),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
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

        // Initial route
        initialRoute: '/',

        // Routes
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/onboarding-welcome': (context) => const OnboardingFlow(),
          '/onboarding-target': (context) => const OnboardingFlow(),
          '/onboarding-tips': (context) => const OnboardingFlow(),
          '/main': (context) => const MainScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          // '/home': (context) => const HomeScreen(), // TODO
        },
      ),
    );
  }
}
