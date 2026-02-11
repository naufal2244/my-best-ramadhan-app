import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class TipsScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final int? targetPages;

  const TipsScreen({
    Key? key,
    this.onNext,
    this.targetPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil targetPages dari arguments jika tidak dipassing lewat constructor
    final int displayTarget = targetPages ??
        (ModalRoute.of(context)?.settings.arguments as int? ?? 1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: const Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'Tips Khatam Al-Qur\'an 💡',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Agar target ${displayTarget}x khatam tercapai dengan lebih mudah dan konsisten',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: ListView(
                  children: [
                    _buildTipCard(
                      icon: '🌅',
                      color: const Color(0xFFFFF3E0),
                      title: 'Setelah Subuh',
                      description:
                          'Baca 3 halaman setelah shalat Subuh ketika pikiran masih fresh',
                    ),
                    const SizedBox(height: 16),
                    _buildTipCard(
                      icon: '🕌',
                      color: const Color(0xFFE3F2FD),
                      title: 'Setelah Tarawih',
                      description:
                          'Baca 3 halaman setelah shalat Tarawih untuk melengkapi tilawah harian',
                    ),
                    const SizedBox(height: 16),
                    _buildTipCard(
                      icon: '🌙',
                      color: const Color(0xFFF3E5F5),
                      title: 'Sebelum Tidur',
                      description:
                          'Baca 3 halaman sebelum tidur sebagai penutup hari yang berkah',
                    ),
                    const SizedBox(height: 16),
                    _buildTipCard(
                      icon: '💚',
                      color: const Color(0xFFE8F9EC),
                      title: 'Konsisten & Ikhlas',
                      description:
                          'Yang terpenting adalah konsistensi dan keikhlasan dalam beribadah',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Start button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onNext ??
                      () async {
                        // Simpan target khatam ke database
                        final authProvider = context.read<AuthProvider>();
                        await authProvider.updateTargetKhatam(displayTarget);

                        // Pindah ke halaman utama (MainScreen)
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/main',
                            (route) => false,
                          );
                        }
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32D74B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mulai Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.rocket_launch_rounded, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required String icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              icon,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
