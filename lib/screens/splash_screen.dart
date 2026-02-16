import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'onboarding_flow.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../services/notification_service.dart';

/// SPLASH SCREEN
/// Ini adalah layar pertama yang muncul saat aplikasi dibuka
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animasi untuk logo
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Mulai animasi
    _animationController.forward();

    // LOGIKA: Cek Login Status dulu, baru Cek Izin Notifikasi
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        // Trigger penjadwalan notifikasi sedini mungkin (tanpa nunggu login)
        context.read<NotificationProvider>().fetchAndScheduleNotifications();

        final authResult = FirebaseAuth.instance.currentUser;

        if (authResult == null) {
          // 1. BELUM LOGIN: Harus ke halaman Login dulu
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          // 2. SUDAH LOGIN: Cek apakah izin notifikasi aktif di HP ini?
          final bool isEnabled =
              await NotificationService().areNotificationsEnabled();

          if (isEnabled) {
            // Sudah aktif -> Langsung ke Home
            Navigator.of(context).pushReplacementNamed('/main');
          } else {
            // Belum aktif -> Lempar ke halaman "Yuk Izinkan" (Onboarding index 3)
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const OnboardingFlow(initialPage: 3),
              ),
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF32D74B), Color(0xFF63E677)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child:
                        ScaleTransition(scale: _scaleAnimation, child: child),
                  );
                },
                child: _buildLogo(),
              ),
              const SizedBox(height: 24),
              const Text(
                'My Best Ramadhan',
                style: TextStyle(
                  fontSize: 24, // Reduced from 32
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Jadikan Ramadhan Tahun ini berbeda',
                style: TextStyle(
                  fontSize: 13, // Reduced from 16
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 60),
              const SizedBox(
                width: 32, // Reduced from 40
                height: 32, // Reduced from 40
                child: CircularProgressIndicator(
                  strokeWidth: 2.5, // Reduced from 3
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100, // Reduced from 140
      height: 100, // Reduced from 140
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/images/app_logo_inverted.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
