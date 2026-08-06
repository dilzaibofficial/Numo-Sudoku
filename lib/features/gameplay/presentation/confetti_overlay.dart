import 'dart:math';

import 'package:flutter/material.dart';

class _Particle {
  _Particle(Random random)
      : x = random.nextDouble(),
        speed = 0.35 + random.nextDouble() * 0.5,
        size = 6 + random.nextDouble() * 6,
        swayAmount = 10 + random.nextDouble() * 20,
        swaySpeed = 1 + random.nextDouble() * 2,
        swayOffset = random.nextDouble() * pi * 2,
        rotationSpeed = (random.nextDouble() - 0.5) * 6,
        startDelay = random.nextDouble() * 0.3,
        color = _confettiColors[random.nextInt(_confettiColors.length)];

  final double x; // 0..1, horizontal position
  final double speed; // fall speed multiplier
  final double size;
  final double swayAmount;
  final double swaySpeed;
  final double swayOffset;
  final double rotationSpeed;
  final double startDelay;
  final Color color;
}

const _confettiColors = [
  Color(0xFFFFC107),
  Color(0xFFEF5350),
  Color(0xFF42A5F5),
  Color(0xFF66BB6A),
  Color(0xFFAB47BC),
  Color(0xFFFF7043),
];

/// A short, dependency-free confetti burst for the puzzle-solved moment.
/// Plays once and calls [onDone] when finished; does not intercept touches.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key, this.onDone});

  final VoidCallback? onDone;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _particles = List.generate(60, (_) => _Particle(random));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onDone?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(_particles, _controller.value),
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.particles, this.progress);

  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final localProgress =
          ((progress - particle.startDelay) / (1 - particle.startDelay)).clamp(0.0, 1.0);
      if (localProgress <= 0) continue;

      final fallDistance = size.height * 1.15 * particle.speed;
      final y = -particle.size + fallDistance * localProgress;
      final sway = sin(localProgress * particle.swaySpeed * pi * 2 + particle.swayOffset) *
          particle.swayAmount;
      final x = particle.x * size.width + sway;
      final rotation = localProgress * particle.rotationSpeed * pi * 2;
      final opacity = localProgress > 0.8 ? (1 - localProgress) / 0.2 : 1.0;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      paint.color = particle.color.withValues(alpha: opacity.clamp(0.0, 1.0));
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
