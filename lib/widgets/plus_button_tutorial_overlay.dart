import 'package:flutter/material.dart';

class PlusButtonTutorialOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const PlusButtonTutorialOverlay({
    Key? key,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<PlusButtonTutorialOverlay> createState() =>
      _PlusButtonTutorialOverlayState();
}

class _PlusButtonTutorialOverlayState extends State<PlusButtonTutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
    // We assume the plus button is in the top right area of the list section
    // or we can just point to the top-ish area where it resides.
    // However, the user might prefer a FAB. I'll design it to point to a FAB-like position
    // or the specific plus icon. Let's assume it's roughly at (screenWidth - 60, 450)
    // Actually, I'll place it relative to the screen.

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background Dim with "Hole"
          GestureDetector(
            onTap: widget.onDismiss,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: SpotlightPainter(
                    animationValue: _animation.value,
                    // Targeted at roughly where the Plus button is (top right of list)
                    targetOffset:
                        const Offset(-40, 450), // Will be calculated below
                  ),
                );
              },
            ),
          ),

          // Tutorial Text & Arrow
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                bottom: 120, // Positioned above the FAB
                left: 40,
                right: 40,
                child: Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0, -20 * (1 - _animation.value)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Langkah Awalmu! 🌟',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Jadikan Ramadhan-mu lebih bermakna. Klik tombol "+" ini untuk mulai menyusun daftar amalan dan target ibadah harianmu!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF757575),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: widget.onDismiss,
                                  child: const Text(
                                    'Mulai Sekarang',
                                    style: TextStyle(
                                      color: Color(0xFF32D74B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Arrow pointing down to FAB
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SpotlightPainter extends CustomPainter {
  final double animationValue;
  final Offset targetOffset;

  SpotlightPainter({
    required this.animationValue,
    required this.targetOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7 * animationValue);

    // Targeted at FAB position (bottom right)
    final targetCenterReal = Offset(size.width - 44, size.height - 76);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addOval(Rect.fromCircle(center: targetCenterReal, radius: 35))
          ..close(),
      ),
      paint,
    );

    // Draw Highlight Border
    final borderPaint = Paint()
      ..color = const Color(0xFF32D74B).withValues(alpha: animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
        targetCenterReal, 35 + (5 * (1 - animationValue)), borderPaint);
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
