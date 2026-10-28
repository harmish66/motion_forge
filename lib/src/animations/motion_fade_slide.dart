import 'dart:async';
import 'package:flutter/widgets.dart';
import '../core/motion_config.dart';

/// A composable entrance widget combining opacity fade and directional slide.
class MotionFadeSlide extends StatefulWidget {
  const MotionFadeSlide({
    super.key,
    required this.child,
    this.direction = MotionDirection.bottom,
    this.offset = 32.0,
    this.duration = const Duration(milliseconds: 450),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.autoStart = true,
    this.onCompleted,
  });

  /// The child widget to animate.
  final Widget child;

  /// The direction from which the child slides into position.
  final MotionDirection direction;

  /// Distance in pixels for the slide entrance.
  final double offset;

  /// Duration of the transition.
  final Duration duration;

  /// Delay before initiating the animation.
  final Duration delay;

  /// Curve of the transition.
  final Curve curve;

  /// Whether the animation triggers automatically on mount.
  final bool autoStart;

  /// Callback fired when entrance finishes.
  final VoidCallback? onCompleted;

  @override
  State<MotionFadeSlide> createState() => MotionFadeSlideState();
}

class MotionFadeSlideState extends State<MotionFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curved;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _curved = CurvedAnimation(
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

  /// Forward the entrance animation.
  void play() => _controller.forward();

  /// Reverse the animation.
  void reverse() => _controller.reverse();

  /// Reset to initial state.
  void reset() => _controller.reset();

  Offset _computeOffset(double progress) {
    final double remaining = (1.0 - progress) * widget.offset;
    switch (widget.direction) {
      case MotionDirection.top:
        return Offset(0, -remaining);
      case MotionDirection.bottom:
        return Offset(0, remaining);
      case MotionDirection.left:
        return Offset(-remaining, 0);
      case MotionDirection.right:
        return Offset(remaining, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      builder: (context, child) {
        return Opacity(
          opacity: _curved.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: _computeOffset(_curved.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}

