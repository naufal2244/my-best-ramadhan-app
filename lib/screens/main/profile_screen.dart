import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';
import '../../providers/habit_provider.dart';
import '../../utils/security_utils.dart';
import '../onboarding/target_setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with gradient - Responsive height
            SliverToBoxAdapter(
              child: Builder(builder: (context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final screenWidth = MediaQuery.of(context).size.width;
                // Header takes approx 24% of screen height, but with limits
                final headerHeight = (screenHeight * 0.24).clamp(180.0, 240.0);

                return Container(
                  width: screenWidth,
                  constraints: BoxConstraints(minHeight: headerHeight),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical:
                        12.0, // Increased vertical padding for content safety
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF32D74B), Color(0xFF63E677)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final userData = auth.userData;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          // Profile Picture - Responsive size
                          Container(
                            width: (screenWidth * 0.18).clamp(60.0, 75.0),
                            height: (screenWidth * 0.18).clamp(60.0, 75.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: (screenWidth * 0.1).clamp(35.0, 45.0),
                              color: const Color(0xFF32D74B),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // Name
                          Text(
                            userData?.displayName ?? 'User',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: (screenWidth * 0.05)
                                  .clamp(16.0, 20.0), // Smaller
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Email
                          Text(
                            userData?.email ?? '',
                            style: TextStyle(
                              fontSize: (screenWidth * 0.032)
                                  .clamp(11.0, 13.0), // Smaller
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          // Redesigned Prominent Stat
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenHeight * 0.008),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.menu_book_rounded,
                                        color: Colors.white, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Target Khatam',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  '${userData?.targetKhatam ?? 1} KALI',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),

            // Menu Items
            SliverPadding(
              padding: const EdgeInsets.all(16.0), // Reduced from 24.0
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  const Text(
                    'Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profil',
                    subtitle: 'Ubah nama dan kata sandi',
                    onTap: () {
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.track_changes,
                    title: 'Target Saya',
                    subtitle: 'Atur target khatam Al-Qur\'an',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TargetSettingScreen(
                            isEditing: true,
                          ),
                        ),
                      );

                      if (result == 'target_updated' && context.mounted) {
                        _showSuccessSnackBar(
                            context, 'Target Khatam berhasil diperbarui! 🎯');
                      }
                    },
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Aplikasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildMenuItem(
                    svgAsset:
                        'assets/images/instagram-logo-facebook-2-svgrepo-com.svg',
                    title: 'Ikuti kami di Instagram',
                    subtitle: '@mybest.ramadhan',
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://www.instagram.com/mybest.ramadhan?igsh=OWt4a2Jsc28yYzVm');
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tidak dapat membuka Instagram')),
                          );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan dan Saran',
                    subtitle: 'Hubungi tim kami untuk bantuan',
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'mybest.ramadhan@gmail.com',
                        query:
                            'subject=Bantuan dan Saran&body=Halo Tim My Best Ramadhan,',
                      );
                      if (!await launchUrl(emailLaunchUri)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Tidak dapat membuka aplikasi email')),
                          );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    subtitle: 'Versi 1.0.0',
                    onTap: () {
                      // Show about
                    },
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF32D74B), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout,
                              color: Color(0xFF32D74B), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Keluar Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Delete Account Button (Security Requirement)
                  Center(
                    child: TextButton(
                      onPressed: () => _showDeleteAccountDialog(context),
                      child: Text(
                        'Hapus Akun Permanen',
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    IconData? icon,
    String? svgAsset,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // Reduced from 16
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Reduced from 16
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: svgAsset != null
                  ? SvgPicture.asset(
                      svgAsset,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF32D74B),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    )
                  : Icon(icon, color: const Color(0xFF32D74B), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14, // Reduced from 16
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced from 4
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12, // Reduced from 14
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Keluar dari Akun?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // Perform logout
                final authProvider = context.read<AuthProvider>();
                final habitProvider = context.read<HabitProvider>();

                // Bersihkan data habit dulu agar tidak bocor ke user selanjutnya
                habitProvider.clearData();
                await authProvider.logout();

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Hapus Akun Permanen?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: const Text(
            'Aksi ini tidak dapat dibatalkan. Semua data ibadah dan progres Ramadhan Anda akan dihapus selamanya.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final authProvider = context.read<AuthProvider>();

                try {
                  await authProvider.deleteAccount();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showErrorSnackBar(
                        context, SecurityUtils.sanitizeErrorMessage(e));
                  }
                }
              },
              child: const Text(
                'Hapus Selamanya',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF32D74B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
