import 'package:flutter/widgets.dart';

/// A widget that performs a gentle, organic breathing scale and ambient glow cycle.
///
/// Ideal for live status badges, recording indicators, or subtle card highlights.
class MotionBreathe extends StatefulWidget {
  const MotionBreathe({
    super.key,
    required this.child,
    this.minScale = 0.96,
    this.maxScale = 1.04,
    this.period = const Duration(milliseconds: 2200),
    this.curve = Curves.easeInOutSine,
    this.glowColor,
    this.glowRadius = 12.0,
    this.enabled = true,
  });

  /// The child widget to animate.
  final Widget child;

  /// The minimum scale factor at the trough of the breath.
  final double minScale;

  /// The maximum scale factor at the crest of the breath.
  final double maxScale;

  /// Duration of a full breathe in and out cycle.
  final Duration period;

  /// Curve applied to the breathing interpolation.
  final Curve curve;

  /// Optional ambient glow shadow color.
  final Color? glowColor;

  /// Blur radius of the glow effect.
  final double glowRadius;

  /// Controls whether breathing is actively animated.
  final bool enabled;

  @override
  State<MotionBreathe> createState() => _MotionBreatheState();
}

class _MotionBreatheState extends State<MotionBreathe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.period.inMilliseconds ~/ 2),
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MotionBreathe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
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
      animation: _scaleAnimation,
      builder: (context, child) {
        Widget content = Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );

        if (widget.glowColor != null) {
          final double progress = (_scaleAnimation.value - widget.minScale) /
              (widget.maxScale - widget.minScale);
          final double currentSpread = widget.glowRadius * progress;

          content = DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor!.withValues(alpha: 0.35 * progress),
                  blurRadius: currentSpread,
                  spreadRadius: currentSpread * 0.5,
                ),
              ],
            ),
            child: content,
          );
        }

        return content;
      },
    );
  }
}

