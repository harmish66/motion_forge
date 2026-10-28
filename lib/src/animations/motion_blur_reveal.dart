import 'dart:ui';
import 'package:flutter/widgets.dart';

/// An entrance transition that reveals content by transitioning from blurred to sharp focus.
class MotionBlurReveal extends StatefulWidget {
  const MotionBlurReveal({
    super.key,
    required this.child,
    this.initialSigma = 12.0,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.autoStart = true,
  });

  /// The child widget to reveal from blur to sharp focus.
  final Widget child;

  /// Starting blur radius in pixels.
  final double initialSigma;

  /// Duration of the focus transition.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Whether the animation runs automatically on mount.
  final bool autoStart;

  @override
  State<MotionBlurReveal> createState() => MotionBlurRevealState();
}

class MotionBlurRevealState extends State<MotionBlurReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

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

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Replay the blur reveal transition.
  void replay() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double progress = _animation.value;
        final double sigma = (1.0 - progress) * widget.initialSigma;
        final double opacity = progress.clamp(0.0, 1.0);

        Widget content = Opacity(
          opacity: opacity,
          child: widget.child,
        );

        if (sigma > 0.05) {
          content = ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: content,
          );
        }

        return content;
      },
    );
  }
}

