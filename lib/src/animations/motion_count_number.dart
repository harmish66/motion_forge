import 'package:flutter/widgets.dart';

/// An animated number widget that smoothly interpolates between numeric values.
class MotionCountNumber extends StatefulWidget {
  const MotionCountNumber({
    super.key,
    this.begin = 0.0,
    required this.end,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOutCubic,
    this.fractionDigits = 0,
    this.prefix = '',
    this.suffix = '',
    this.style,
  });

  /// Starting number value.
  final double begin;

  /// Target end number value.
  final double end;

  /// Duration of the count interpolation.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Number of decimal places to show.
  final int fractionDigits;

  /// String prefix placed before the number.
  final String prefix;

  /// String suffix placed after the number.
  final String suffix;

  /// Text style applied to the displayed count.
  final TextStyle? style;

  @override
  State<MotionCountNumber> createState() => MotionCountNumberState();
}

class MotionCountNumberState extends State<MotionCountNumber>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant MotionCountNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.end != widget.end) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.end,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Restarts the count animation from begin.
  void restart() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final String formattedNumber =
            _animation.value.toStringAsFixed(widget.fractionDigits);
        return Text(
          '${widget.prefix}$formattedNumber${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}

