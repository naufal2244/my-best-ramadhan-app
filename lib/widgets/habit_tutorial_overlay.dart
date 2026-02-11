import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTutorialOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const HabitTutorialOverlay({
    Key? key,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<HabitTutorialOverlay> createState() => _HabitTutorialOverlayState();
}

class _HabitTutorialOverlayState extends State<HabitTutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _firstHabitCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        // Background Dim - Tap to dismiss
        GestureDetector(
          onTap: _handleDismiss,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                color: Colors.black.withOpacity(0.5 * _animation.value),
              );
            },
          ),
        ),

        // Content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! > 10) {
                _handleDismiss();
              }
            },
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 300 * (1 - _animation.value)),
                  child: Opacity(
                    opacity: _animation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    top: 12,
                    bottom: bottomPadding > 0 ? bottomPadding : 24,
                    left: 24,
                    right: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag indicator
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const Text(
                      'Panduan',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Geser kanan pada habit untuk menandai selesai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Single example - Swipe right to complete
                    _buildExampleHabit(
                      title: 'Tilawah 5 Halaman 📖',
                      icon: Icons.check,
                      backgroundColor: const Color(0xFF32D74B),
                      isCompleted: _firstHabitCompleted,
                      onComplete: () {
                        setState(() {
                          _firstHabitCompleted = true;
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    // OK Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleDismiss,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF32D74B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Mengerti',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleHabit({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required bool isCompleted,
    required VoidCallback onComplete,
    bool isLeftSwipe = false,
  }) {
    return Slidable(
      key: ValueKey(title),
      enabled: !isCompleted,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        dismissible: DismissiblePane(
          onDismissed: onComplete,
        ),
        children: [
          SlidableAction(
            onPressed: (context) => onComplete(),
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            icon: icon,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      startActionPane: null,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color:
              isCompleted ? const Color(0xFFE8F9EC) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF32D74B).withOpacity(0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
