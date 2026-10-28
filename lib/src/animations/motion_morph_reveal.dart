import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../core/motion_config.dart';

/// A widget that reveals its child using dynamic clip path morphing
/// such as expanding circles, diamond shapes, or directional wipes.
class MotionMorphReveal extends StatefulWidget {
  const MotionMorphReveal({
    super.key,
    required this.child,
    this.shape = RevealShape.circle,
    this.duration = const Duration(milliseconds: 700),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOutCubic,
    this.autoStart = true,
    this.centerAlignment = Alignment.center,
    this.onCompleted,
  });

  /// The child widget to reveal.
  final Widget child;

  /// The shape pattern used to reveal the content.
  final RevealShape shape;

  /// Duration of the reveal animation.
  final Duration duration;

  /// Delay before the animation begins.
  final Duration delay;

  /// Curve applied to the reveal transition.
  final Curve curve;

  /// Whether the animation should start automatically on mount.
  final bool autoStart;

  /// Origin alignment for circle and diamond reveal shapes.
  final Alignment centerAlignment;

  /// Callback executed when the reveal completes.
  final VoidCallback? onCompleted;

  @override
  State<MotionMorphReveal> createState() => MotionMorphRevealState();
}

class MotionMorphRevealState extends State<MotionMorphReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.onCompleted != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onCompleted!();
        }
      });
    }

    if (widget.autoStart) {
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        _delayTimer = Timer(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Manually starts the reveal animation forward.
  void reveal() => _controller.forward();

  /// Manually reverses the reveal animation (hides the content).
  void conceal() => _controller.reverse();

  /// Resets the animation back to initial state.
  void reset() => _controller.reset();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipPath(
          clipper: _MorphClipper(
            progress: _animation.value,
            shape: widget.shape,
            alignment: widget.centerAlignment,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _MorphClipper extends CustomClipper<Path> {
  const _MorphClipper({
    required this.progress,
    required this.shape,
    required this.alignment,
  });

  final double progress;
  final RevealShape shape;
  final Alignment alignment;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    if (progress <= 0.0) {
      return path;
    }
    if (progress >= 1.0) {
      path.addRect(Offset.zero & size);
      return path;
    }

    final Offset center = Offset(
      (alignment.x + 1.0) / 2.0 * size.width,
      (alignment.y + 1.0) / 2.0 * size.height,
    );

    switch (shape) {
      case RevealShape.circle:
        final double maxDistance = math.sqrt(
          math.pow(math.max(center.dx, size.width - center.dx), 2) +
              math.pow(math.max(center.dy, size.height - center.dy), 2),
        );
        path.addOval(
          Rect.fromCircle(
            center: center,
            radius: maxDistance * progress,
          ),
        );
        break;

      case RevealShape.horizontalWipe:
        path.addRect(
          Rect.fromLTWH(0, 0, size.width * progress, size.height),
        );
        break;

      case RevealShape.verticalWipe:
        path.addRect(
          Rect.fromLTWH(0, 0, size.width, size.height * progress),
        );
        break;

      case RevealShape.diamond:
        final double maxSpan = math.max(size.width, size.height) * 1.5;
        final double span = maxSpan * progress;
        path.moveTo(center.dx, center.dy - span);
        path.lineTo(center.dx + span, center.dy);
        path.lineTo(center.dx, center.dy + span);
        path.lineTo(center.dx - span, center.dy);
        path.close();
        break;
    }

    return path;
  }

  @override
  bool shouldReclip(covariant _MorphClipper oldClipper) {
    return oldClipper.progress != progress ||
        oldClipper.shape != shape ||
        oldClipper.alignment != alignment;
  }
}

