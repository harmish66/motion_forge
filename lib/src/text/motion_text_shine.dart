import 'package:flutter/widgets.dart';

/// A text widget with a continuous light sweep shine moving across the glyphs.
class MotionTextShine extends StatefulWidget {
  const MotionTextShine({
    super.key,
    required this.text,
    this.style,
    this.baseColor = const Color(0xFF64748B),
    this.shineColor = const Color(0xFFFFFFFF),
    this.duration = const Duration(milliseconds: 2000),
    this.autoStart = true,
  });

  /// The text content.
  final String text;

  /// Text style.
  final TextStyle? style;

  /// Underlying base color of the text.
  final Color baseColor;

  /// Highlight color passing across the text.
  final Color shineColor;

  /// Duration of a full shine pass.
  final Duration duration;

  /// Whether the shine animation plays continuously.
  final bool autoStart;

  @override
  State<MotionTextShine> createState() => _MotionTextShineState();
}

class _MotionTextShineState extends State<MotionTextShine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.autoStart) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle =
        widget.style ?? const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = _controller.value;
        final double start = (progress * 2.0) - 1.0;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + start, 0),
              end: Alignment(1.0 + start, 0),
              colors: [
                widget.baseColor,
                widget.shineColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: defaultStyle.copyWith(color: const Color(0xFFFFFFFF)),
          ),
        );
      },
    );
  }
}
