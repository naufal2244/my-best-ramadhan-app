import 'package:flutter/material.dart';

class TargetSettingScreen extends StatefulWidget {
  final bool isEditing;
  final VoidCallback? onNext;
  final Function(int)? onTargetChanged;

  const TargetSettingScreen({
    Key? key,
    this.isEditing = false,
    this.onNext,
    this.onTargetChanged,
  }) : super(key: key);

  @override
  State<TargetSettingScreen> createState() => _TargetSettingScreenState();
}

class _TargetSettingScreenState extends State<TargetSettingScreen> {
  int _targetPages = 2;

  void _updateTarget(int delta) {
    setState(() {
      _targetPages = (_targetPages + delta).clamp(1, 10);
      if (widget.onTargetChanged != null) {
        widget.onTargetChanged!(_targetPages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagesPerDay = (_targetPages * 20 / 30).toStringAsFixed(1);
    final pagesPerWeek = (_targetPages * 20 / 4.3).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Title
              const Text(
                'Target Khatam Al-Qur\'an 📖',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Berapa kali kamu ingin Khatam Al-Qur\'an di bulan Ramadhan tahun ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Counter with animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                tween: Tween(begin: 0, end: _targetPages.toDouble()),
                builder: (context, value, child) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF32D74B), Color(0xFF63E677)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF32D74B).withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Minus button
                        _buildCounterButton(
                          icon: Icons.remove,
                          onTap: () => _updateTarget(-1),
                          enabled: _targetPages > 1,
                        ),

                        const SizedBox(width: 48),

                        // Number display
                        Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 48),

                        // Plus button
                        _buildCounterButton(
                          icon: Icons.add,
                          onTap: () => _updateTarget(1),
                          enabled: _targetPages < 10,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Kali Khatam',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const Spacer(),

              // Stats
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Untuk mencapai target ini:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '📅',
                            'Per Hari',
                            '$pagesPerDay Halaman',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            '📊',
                            'Per Minggu',
                            '$pagesPerWeek Halaman',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Tenang! Kamu bisa ubah target ini kapan saja 😊',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 32),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: widget.isEditing
                      ? () => Navigator.pop(context)
                      : (widget.onNext ??
                          () => Navigator.pushNamed(context, '/onboarding-tips',
                              arguments: _targetPages)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32D74B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isEditing ? 'Simpan' : 'Lanjut',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!widget.isEditing) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
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

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color:
              enabled ? const Color(0xFF32D74B) : Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
