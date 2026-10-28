import 'dart:async';
import 'package:flutter/widgets.dart';

/// An animated widget that pops into view with a snappy elastic overshoot.
class MotionElasticPop extends StatefulWidget {
  const MotionElasticPop({
    super.key,
    required this.child,
    this.initialScale = 0.0,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.elasticOut,
    this.autoStart = true,
  });

  /// The child widget to animate.
  final Widget child;

  /// Starting scale value. Default is 0.0.
  final double initialScale;

  /// Total duration of the pop entrance.
  final Duration duration;

  /// Delay before triggering the pop animation.
  final Duration delay;

  /// Easing curve with elastic characteristic.
  final Curve curve;

  /// Whether the animation runs automatically on mount.
  final bool autoStart;

  @override
  State<MotionElasticPop> createState() => MotionElasticPopState();
}

class MotionElasticPopState extends State<MotionElasticPop>
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

    _animation = Tween<double>(
      begin: widget.initialScale,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

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

  /// Replay the pop animation.
  void pop() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

