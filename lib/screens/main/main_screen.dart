import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../services/notification_service.dart';
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

    // Request permissions
    await NotificationService().requestPermissions();

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
        height: 100, // Increased height to prevent clipping
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Bottom Bar Container
            Container(
              height: 70,
              margin: const EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
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
                  const SizedBox(width: 80), // Space for center FAB
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
              top: 0, // Positioned at the top of the 100px SizedBox
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
              size: 26,
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: isActive ? 4 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFF32D74B),
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
        width: 64,
        height: 64,
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
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: const Icon(
          Icons.home_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
