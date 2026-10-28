import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Shake direction style.
enum ShakeDirection {
  horizontal,
  vertical,
  rotational,
}

/// A widget that produces a decaying shake oscillation on command or mount.
///
/// Useful for input validation feedback, attention cues, or alert emphasis.
class MotionShake extends StatefulWidget {
  const MotionShake({
    super.key,
    required this.child,
    this.direction = ShakeDirection.horizontal,
    this.amplitude = 12.0,
    this.shakes = 4,
    this.duration = const Duration(milliseconds: 500),
    this.autoStart = false,
  });

  /// The widget to shake.
  final Widget child;

  /// Direction of the oscillation.
  final ShakeDirection direction;

  /// Maximum initial displacement in pixels (or radians for rotational shake).
  final double amplitude;

  /// Number of full oscillation cycles.
  final int shakes;

  /// Duration of the shake sequence.
  final Duration duration;

  /// Whether to shake automatically when mounted.
  final bool autoStart;

  @override
  State<MotionShake> createState() => MotionShakeState();
}

class MotionShakeState extends State<MotionShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.autoStart) {
      shake();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Triggers the shake animation.
  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.value == 0.0 || _controller.value == 1.0) {
          return widget.child;
        }

        // Decaying sinusoidal function: sin(2 * pi * shakes * t) * (1 - t)
        final double t = _controller.value;
        final double decay = 1.0 - t;
        final double offset =
            math.sin(2 * math.pi * widget.shakes * t) * widget.amplitude * decay;

        switch (widget.direction) {
          case ShakeDirection.horizontal:
            return Transform.translate(
              offset: Offset(offset, 0),
              child: widget.child,
            );
          case ShakeDirection.vertical:
            return Transform.translate(
              offset: Offset(0, offset),
              child: widget.child,
            );
          case ShakeDirection.rotational:
            // Convert amplitude to small rotation radians
            final double rotationAngle = offset * (math.pi / 180.0);
            return Transform.rotate(
              angle: rotationAngle,
              child: widget.child,
            );
        }
      },
    );
  }
}

