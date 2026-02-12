import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/auth_provider.dart';
import '../../services/notification_service.dart';
import '../onboarding_flow.dart';

/// HALAMAN LOGIN
/// Ini adalah halaman pertama yang akan muncul setelah splash screen
/// Di sini user bisa login dengan email/password atau Google
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk mengambil input dari TextField
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Key untuk form validation (cek apakah email valid, password tidak kosong, dll)
  final _formKey = GlobalKey<FormState>();

  // Variable untuk show/hide password
  bool _obscurePassword = true;

  // Variable untuk loading state saat login
  bool _isLoading = false;

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus dari memory
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Fungsi untuk handle login dengan email & password
  Future<void> _handleEmailLogin() async {
    // Validasi form dulu
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      try {
        await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // Syunkronkan dengan logika Splash: Cek Izin Notifikasi setelah login
        if (mounted) {
          final bool isEnabled =
              await NotificationService().areNotificationsEnabled();

          if (isEnabled) {
            Navigator.pushReplacementNamed(context, '/main');
          } else {
            // Belum aktif -> Lempar ke halaman "Yuk Izinkan"
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const OnboardingFlow(initialPage: 3),
              ),
            );
          }
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Login Gagal: ${e.toString().split('] ').last}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  /// Fungsi untuk handle login dengan Google
  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    // Simulasi delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // LOGO APLIKASI
                  _buildLogo(),

                  const SizedBox(height: 16),

                  // NAMA APLIKASI
                  _buildAppName(),

                  const SizedBox(height: 12),

                  // TAGLINE RAMADHAN
                  _buildTagline(),

                  const SizedBox(height: 48),

                  // INPUT EMAIL
                  _buildEmailField(),

                  const SizedBox(height: 16),

                  // INPUT PASSWORD
                  _buildPasswordField(),

                  const SizedBox(height: 24),

                  // TOMBOL LOGIN
                  _buildLoginButton(),

                  const SizedBox(height: 20),

                  // DIVIDER "atau"
                  _buildDivider(),

                  const SizedBox(height: 20),

                  // TOMBOL GOOGLE SIGN IN
                  _buildGoogleButton(),

                  const SizedBox(height: 24),

                  // LINK KE REGISTER & FORGOT PASSWORD
                  _buildBottomLinks(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Widget Logo Aplikasi dengan gradient
  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF32D74B), // primary_green
            Color(0xFF63E677), // light_green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF32D74B).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.menu_book_rounded, // Icon Quran/Buku
        size: 60,
        color: Colors.white,
      ),
    );
  }

  /// Widget Nama Aplikasi
  Widget _buildAppName() {
    return const Text(
      'My Best Ramadhan',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
        letterSpacing: -0.5,
      ),
    );
  }

  /// Widget Tagline
  Widget _buildTagline() {
    return const Text(
      'Jadikan Ramadhan Tahun ini\nRamadhan terbaik mu!',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    );
  }

  /// Widget Input Email
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'abc@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        if (!value.contains('@')) {
          return 'Email tidak valid';
        }
        return null;
      },
    );
  }

  /// Widget Input Password
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Kata Sandi',
        hintText: 'Masukkan password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  /// Widget Tombol Login
  Widget _buildLoginButton() {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleEmailLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF32D74B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: const Color(0xFF32D74B).withOpacity(0.3),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  /// Widget Divider dengan text "atau"
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'atau',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  /// Widget Tombol Google Sign In
  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _handleGoogleLogin,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1A1A1A),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Image.network(
          'https://www.google.com/favicon.ico',
          height: 24,
          width: 24,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.g_mobiledata, size: 24);
          },
        ),
        label: const Text(
          'Lanjutkan dengan Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Widget Link Register & Forgot Password
  Widget _buildBottomLinks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Belum memiliki akun? ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                // Pindah ke halaman register menggunakan named route
                Navigator.pushNamed(context, '/register');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Buat Akun',
                style: TextStyle(
                  color: Color(0xFF32D74B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // TODO: Navigate ke halaman forgot password
            print('Navigate to Forgot Password');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Lupa Kata Sandi?',
            style: TextStyle(
              color: Color(0xFF32D74B),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
