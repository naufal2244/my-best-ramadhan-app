import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import 'feed_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Start at Home (middle tab)

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    final notificationProvider = context.read<NotificationProvider>();

    // Fetch quotes and schedule
    await notificationProvider.fetchAndScheduleNotifications();
  }

  final List<Widget> _screens = [
    const FeedScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 75, // Reduced from 85
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Bottom Bar Container
            Container(
              height: 58, // Reduced from 65
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), // Smaller radius
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    icon: Icons.menu_book_rounded,
                    label: 'Feed',
                    index: 0,
                  ),
                  const SizedBox(width: 70), // Reduced from 80
                  _buildNavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profil',
                    index: 2,
                  ),
                ],
              ),
            ),

            // Center Floating Button
            Positioned(
              top: 0,
              child: _buildCenterNavItem(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isActive ? const Color(0xFF32D74B) : const Color(0xFFBDBDBD),
              size: 24, // Reduced from 26
            ),
            const SizedBox(height: 2), // Reduced from 4
            if (isActive)
              Container(
                height: 4,
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF32D74B),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    final isActive = _currentIndex == 1;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 1),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56, // Reduced from 64
        height: 56, // Reduced from 64
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [
                    const Color(0xFF32D74B),
                    const Color(0xFF63E677),
                  ]
                : [
                    const Color(0xFF9E9E9E),
                    const Color(0xFFBDBDBD),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (isActive ? const Color(0xFF32D74B) : const Color(0xFF9E9E9E))
                      .withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white, width: 3), // Reduced from 4
        ),
        child: const Icon(
          Icons.home_rounded,
          color: Colors.white,
          size: 28, // Reduced from 30
        ),
      ),
    );
  }
}
