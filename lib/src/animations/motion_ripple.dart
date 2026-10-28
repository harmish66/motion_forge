import 'package:flutter/widgets.dart';

/// A widget that emits concentric expanding ripple rings around a child widget.
class MotionRipple extends StatefulWidget {
  const MotionRipple({
    super.key,
    required this.child,
    this.ringColor = const Color(0x330284C7),
    this.ringCount = 3,
    this.maxRadius = 45.0,
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeOutQuad,
    this.enabled = true,
  });

  /// Central widget wrapped by the expanding ripple rings.
  final Widget child;

  /// Base color of the ripple rings (opacity will fade outward).
  final Color ringColor;

  /// Number of simultaneous concentric rings.
  final int ringCount;

  /// Maximum radius expansion in pixels beyond child size.
  final double maxRadius;

  /// Duration of a full cycle for one ring.
  final Duration duration;

  /// Curve of the ripple expansion.
  final Curve curve;

  /// Whether the ripple animation is actively running.
  final bool enabled;

  @override
  State<MotionRipple> createState() => _MotionRippleState();
}

class _MotionRippleState extends State<MotionRipple>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MotionRipple oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _RipplePainter(
            progress: _controller.value,
            ringCount: widget.ringCount,
            ringColor: widget.ringColor,
            maxRadius: widget.maxRadius,
            curve: widget.curve,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter({
    required this.progress,
    required this.ringCount,
    required this.ringColor,
    required this.maxRadius,
    required this.curve,
  });

  final double progress;
  final int ringCount;
  final Color ringColor;
  final double maxRadius;
  final Curve curve;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double baseRadius = (size.width < size.height ? size.width : size.height) / 2;

    for (int i = 0; i < ringCount; i++) {
      final double ringOffset = i / ringCount;
      final double ringProgress = (progress + ringOffset) % 1.0;
      final double curvedProgress = curve.transform(ringProgress);

      final double radius = baseRadius + (maxRadius * curvedProgress);
      final double opacity = (1.0 - curvedProgress).clamp(0.0, 1.0);

      final Paint paint = Paint()
        ..color = ringColor.withValues(alpha: ringColor.a * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringCount != ringCount ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.maxRadius != maxRadius;
  }
}

