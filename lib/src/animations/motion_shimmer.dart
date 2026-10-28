import 'package:flutter/widgets.dart';

/// A widget that overlays a smooth light sweep shimmer over its child.
///
/// Can be used for loading skeletons, subtle highlight badges, or attention-grabbing
/// interactive elements without relying on heavy external dependencies.
class MotionShimmer extends StatefulWidget {
  const MotionShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE2E8F0),
    this.highlightColor = const Color(0xFFF8FAFC),
    this.duration = const Duration(milliseconds: 1500),
    this.angle = 0.35,
    this.enabled = true,
  });

  /// The widget content that will be masked by the shimmer gradient.
  final Widget child;

  /// The underlying color of the shimmer gradient.
  final Color baseColor;

  /// The highlighted sweep color passing through.
  final Color highlightColor;

  /// Duration of one complete light pass.
  final Duration duration;

  /// Angle of the gradient tilt in radians.
  final double angle;

  /// Controls whether the shimmer animation is active.
  final bool enabled;

  @override
  State<MotionShimmer> createState() => _MotionShimmerState();
}

class _MotionShimmerState extends State<MotionShimmer>
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
  void didUpdateWidget(covariant MotionShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      if (widget.enabled) {
        _controller.repeat();
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
        final double progress = _controller.value;
        final double start = (progress * 2.0) - 1.0;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + start, -0.5),
              end: Alignment(1.0 + start, 0.5),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

