import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';
import '../utils/ramadhan_utils.dart';
import 'main/main_screen.dart'; // Import real MainScreen instead of using placeholder

class OnboardingFlow extends StatefulWidget {
  final int initialPage;
  const OnboardingFlow({Key? key, this.initialPage = 0}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late PageController _pageController;
  late int _currentPage;
  int _targetPages = 1; // Default target
  final int _totalPages = 4; // Updated to include notification priming screen

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Save target khatam to database
      final auth = context.read<AuthProvider>();
      final dailyTarget = RamadhanUtils.calculateDailyTarget(
        totalTargetKhatam: _targetPages,
        completedJuz: 0.0,
        startDate: auth.ramadhanStartDate,
        totalRamadhanDays: auth.totalRamadhanDays,
      );
      await auth.updateTargetKhatam(_targetPages, dailyTarget);

      // Navigate to main screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                physics:
                    const ClampingScrollPhysics(), // Prevent bouncy scroll for better feel
                children: [
                  _WelcomeScreen(onNext: _nextPage),
                  _TargetSettingScreen(
                    onNext: _nextPage,
                    onTargetChanged: (pages) => _targetPages = pages,
                  ),
                  _TipsScreen(
                    onNext: _nextPage,
                    targetPages: _targetPages,
                  ),
                  _NotificationPrimingScreen(onNext: _nextPage),
                ],
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0), // Reduced from 32
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFF32D74B)
            : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Screen 1: Welcome
class _WelcomeScreen extends StatefulWidget {
  final Future<void> Function() onNext;

  const _WelcomeScreen({required this.onNext});

  @override
  State<_WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<_WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Animated icon/illustration
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 100, // Reduced from 140
              height: 100, // Reduced from 140
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF32D74B), Color(0xFF63E677)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF32D74B).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 50, // Reduced from 70
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Welcome text
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const Text(
                  'Assalamualaikum! 👋',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, // Reduced from 32
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F9EC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "🌙 Bulan Al-Qur'an Telah Tiba!",
                    style: TextStyle(
                      fontSize: 13, // Reduced from 16
                      color: Color(0xFF32D74B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "\"Bulan Ramadhan adalah (bulan) yang di dalamnya diturunkan Al-Qur'an...\" (QS. Al-Baqarah: 185)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13, // Reduced from 16
                    color: Colors.grey[600],
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Ramadhan adalah momentum terbaik untuk lebih dekat dengan Al-Qur\'an.\n\nAplikasi ini akan membantumu mencapai target khatam yang lebih baik! ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13, // Reduced from 16
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Continue button
          FadeTransition(
            opacity: _fadeAnimation,
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: widget.onNext,
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
                      'Lanjut',
                      style: TextStyle(
                        fontSize: 15, // Reduced from 16
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// Screen 2: Target Setting
class _TargetSettingScreen extends StatefulWidget {
  final Future<void> Function() onNext;
  final Function(int) onTargetChanged;

  const _TargetSettingScreen({
    required this.onNext,
    required this.onTargetChanged,
  });

  @override
  State<_TargetSettingScreen> createState() => _TargetSettingScreenState();
}

class _TargetSettingScreenState extends State<_TargetSettingScreen> {
  int _targetPages = 1;

  void _updateTarget(int delta) {
    setState(() {
      _targetPages = (_targetPages + delta).clamp(1, 999);
      widget.onTargetChanged(_targetPages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dailyTarget = RamadhanUtils.calculateDailyTarget(
      totalTargetKhatam: _targetPages,
      completedJuz: 0.0,
      startDate: auth.ramadhanStartDate,
      totalRamadhanDays: auth.totalRamadhanDays,
    );
    final juzPerDay = RamadhanUtils.formatJuzTarget(dailyTarget);
    final totalJuz = _targetPages * 30;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Target Khatam Al-Qur\'an 📖',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Berapa kali kamu ingin Khatam Al-Qur\'an di bulan Ramadhan tahun ini?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Counter with animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(begin: 0, end: _targetPages.toDouble()),
                    builder: (context, value, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF32D74B), Color(0xFF63E677)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF32D74B).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCounterButton(
                              icon: Icons.remove,
                              onTap: () => _updateTarget(-1),
                              enabled: _targetPages > 1,
                            ),
                            const SizedBox(width: 32),
                            Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 32),
                            _buildCounterButton(
                              icon: Icons.add,
                              onTap: () => _updateTarget(1),
                              enabled: true,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Kali Khatam',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 24),

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
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                '📅',
                                'Per Hari',
                                juzPerDay,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                '📖',
                                'Total Target',
                                '$totalJuz Juz',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    '* Berdasarkan standar Mushaf Utsmani & Kemenag RI\n(15 baris per halaman, total 604 halaman)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Matched with edit target screen (8)
                  Text(
                    'Tenang! Kamu bisa ubah target ini kapan saja 😊',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                      height:
                          24), // Added some bottom padding for the scrollable part
                ],
              ),
            ),
          ),

          // Continue button - Fixed at bottom to align with other screens
          SizedBox(
            width: double.infinity,
            height: 54, // Restored from 48 to match other onboarding screens
            child: ElevatedButton(
              onPressed: widget.onNext,
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
                    'Lanjut',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 48), // Consistent bottom spacing
        ],
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

// Screen 3: Tips
class _TipsScreen extends StatelessWidget {
  final Future<void> Function() onNext;
  final int targetPages;

  const _TipsScreen({
    required this.onNext,
    required this.targetPages,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Perhitungan harian berdasarkan sisa hari ramadhan
    final double dailyTarget = RamadhanUtils.calculateDailyTarget(
      totalTargetKhatam: targetPages,
      completedJuz: 0.0,
      startDate: auth.ramadhanStartDate,
      totalRamadhanDays: auth.totalRamadhanDays,
    );

    final String juzPerDayStr = RamadhanUtils.formatJuzTarget(dailyTarget);
    final int pagesPerDay = (dailyTarget * 20).round();
    final String pagesPerPrayerStr =
        RamadhanUtils.formatPagePerPrayer(dailyTarget);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Title
          const Text(
            'Tips Khatam Al-Qur\'an 💡',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22, // Reduced from 28
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Agar target ${targetPages}x khatam tercapai dengan lebih mudah dan konsisten',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13, // Reduced from 16
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          Expanded(
            child: ListView(
              children: [
                _buildTipCard(
                  icon: '📖',
                  color: const Color(0xFFE8F9EC),
                  title: 'Target Harian',
                  description:
                      'Targetmu adalah membaca $juzPerDayStr ($pagesPerDay halaman) setiap hari selama bulan Ramadhan.',
                ),
                const SizedBox(height: 16),
                _buildTipCard(
                  icon: '🕌',
                  color: const Color(0xFFE3F2FD),
                  title: 'Setiap Selesai Shalat',
                  description:
                      'Cukup baca $pagesPerPrayerStr setiap selesai shalat fardhu untuk mencicil target harianmu.',
                ),
                const SizedBox(height: 16),
                _buildTipCard(
                  icon: '🌅',
                  color: const Color(0xFFFFF3E0),
                  title: 'Manajemen Waktu',
                  description:
                      'Pikiran lebih fresh setelah Subuh. Gunakan waktu ini untuk memulai tilawah lebih awal.',
                ),
                const SizedBox(height: 16),
                _buildTipCard(
                  icon: '🌙',
                  color: const Color(0xFFF3E5F5),
                  title: 'Evaluasi Malam',
                  description:
                      'Gunakan waktu sebelum tidur untuk melengkapi jika ada target halaman yang belum tercapai.',
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
              onPressed: onNext,
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
                      fontSize: 15, // Reduced from 16
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
                    fontSize: 14, // Reduced from 16
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12, // Reduced from 14
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

// Screen 4: Notification Priming
class _NotificationPrimingScreen extends StatefulWidget {
  final Future<void> Function() onNext;

  const _NotificationPrimingScreen({required this.onNext});

  @override
  State<_NotificationPrimingScreen> createState() =>
      _NotificationPrimingScreenState();
}

class _NotificationPrimingScreenState extends State<_NotificationPrimingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isProcessing = false;

  Future<void> _handleEnableNotifications() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final notificationService = NotificationService();
      final bool isGranted = await notificationService.requestPermissions();

      if (isGranted) {
        // Berhasil diizinkan!
        await widget.onNext();
      } else {
        // Jika ditolak, beri tahu user bahwa mereka bisa mengaktifkannya nanti di setting
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Kamu bisa mengaktifkan notifikasi nanti di Pengaturan HP-mu 😊'),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
              backgroundColor: Colors.grey[800],
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Tetap lanjut ke Home meskipun tidak diizinkan sekarang,
          // agar user tidak terjebak di screen primining
          await widget.onNext();
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Main content - Scrollable to avoid overflow
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Bell icon with animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1500),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 0.5 - 0.25,
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF32D74B),
                                    Color(0xFF63E677)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF32D74B)
                                        .withOpacity(0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.notifications_active_rounded,
                                size: 48, // Reduced from 60
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Main title
                      const Text(
                        'Yuk, Izinkan notifikasi agar kami bisa mengingatkanmu dengan renungan harian yang menginspirasi!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18, // Reduced from 22
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Alert Screenshot with overlay
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Screenshot image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/AlertScreenshot.png',
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // "Manfaat yang didapat" section title
                      const Text(
                        'Manfaat yang didapat!',
                        style: TextStyle(
                          fontSize: 20, // Reduced from 28
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '🌟 Teman pengingat setia setiap hari',
                        style: TextStyle(
                          fontSize: 14, // Reduced from 16
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Notification Screenshot
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/renunganScreenshot.png',
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Benefits list
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F9EC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBenefitItem(
                              '📖',
                              'Ayat Al-Qur\'an harian',
                            ),
                            const SizedBox(height: 12),
                            _buildBenefitItem(
                              '🌙',
                              'Hadits pilihan setiap hari',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Action buttons - Fixed at bottom
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Primary button
                SizedBox(
                  width: double.infinity,
                  height:
                      54, // Restored from 48 to match other onboarding screens
                  child: ElevatedButton(
                    onPressed: _handleEnableNotifications,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF32D74B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Reduced from 12
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Ya, Saya Mau',
                          style: TextStyle(
                            fontSize: 15, // Reduced from 16
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    if (_isProcessing) return;
                    setState(() => _isProcessing = true);
                    try {
                      await widget.onNext();
                    } finally {
                      if (mounted) {
                        setState(() => _isProcessing = false);
                      }
                    }
                  },
                  child: Text(
                    'Nanti Saja',
                    style: TextStyle(
                      fontSize: 12, // Reduced from 14
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String emoji, String text) {
    return Row(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
