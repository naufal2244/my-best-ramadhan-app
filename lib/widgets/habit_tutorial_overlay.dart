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

  // Local states for tutorial interaction
  bool _example1Done = false;
  bool _example2Done = true; // Starts as done for "Undo" tutorial

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
                      'Panduan Penggunaan',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Row 1: Swipe Right to Complete
                    Text(
                      'Geser kanan untuk tandai Selesai',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTutorialItem(
                      title: 'Shalat Dhuha',
                      isDone: _example1Done,
                      swipeRight: true,
                      onSwipe: () {
                        setState(() {
                          _example1Done = !_example1Done;
                        });
                      },
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    // Row 2: Swipe Left to Undo
                    Text(
                      'Geser kiri untuk Membatalkan',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTutorialItem(
                      title: 'Shalat Tahajud',
                      isDone: _example2Done,
                      swipeRight: false,
                      onSwipe: () {
                        setState(() {
                          _example2Done = !_example2Done;
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

  Widget _buildTutorialItem({
    required String title,
    required bool isDone,
    required bool swipeRight,
    required VoidCallback onSwipe,
  }) {
    return Slidable(
      key: ValueKey('${title}_$isDone'),
      // Swipe Right for Done (if swipeRight is true and it's not done)
      startActionPane: swipeRight && !isDone
          ? ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.3,
              dismissible: DismissiblePane(onDismissed: onSwipe),
              children: [
                SlidableAction(
                  onPressed: (_) => onSwipe(),
                  backgroundColor: const Color(0xFF32D74B),
                  foregroundColor: Colors.white,
                  icon: Icons.check,
                  label: 'Selesai',
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            )
          : null,
      // Swipe Left for Undo (if swipeRight is false and it's done)
      endActionPane: !swipeRight && isDone
          ? ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.3,
              dismissible: DismissiblePane(onDismissed: onSwipe),
              children: [
                SlidableAction(
                  onPressed: (_) => onSwipe(),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  icon: Icons.undo,
                  label: 'Batal',
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            )
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFFE8F9EC) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone
                ? const Color(0xFF32D74B).withOpacity(0.3)
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Icon(
              isDone ? Icons.chevron_left : Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
