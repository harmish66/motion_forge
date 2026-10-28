import 'package:flutter/widgets.dart';

/// Segmentation unit for the text wave animation.
enum TextWaveSplit {
  characters,
  words,
}

/// An animated text widget that reveals text sequentially character by character
/// or word by word with an elegant wave-like vertical motion and fade.
class MotionTextWave extends StatefulWidget {
  const MotionTextWave({
    super.key,
    required this.text,
    this.style,
    this.splitMode = TextWaveSplit.characters,
    this.staggerDuration = const Duration(milliseconds: 35),
    this.unitDuration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
    this.verticalOffset = 14.0,
    this.textAlign = TextAlign.start,
    this.autoStart = true,
  });

  /// The text content to animate.
  final String text;

  /// The text style applied to each segment.
  final TextStyle? style;

  /// Whether to split text by individual characters or whole words.
  final TextWaveSplit splitMode;

  /// Delay between the start of adjacent units.
  final Duration staggerDuration;

  /// Duration of an individual unit animation.
  final Duration unitDuration;

  /// Curve applied to the fade and slide of each unit.
  final Curve curve;

  /// Vertical distance each segment travels during reveal.
  final double verticalOffset;

  /// Alignment of the text within the container.
  final TextAlign textAlign;

  /// Whether the animation plays automatically on mount.
  final bool autoStart;

  @override
  State<MotionTextWave> createState() => MotionTextWaveState();
}

class MotionTextWaveState extends State<MotionTextWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _units;

  @override
  void initState() {
    super.initState();
    _computeUnits();
    _initController();

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  void _computeUnits() {
    if (widget.splitMode == TextWaveSplit.characters) {
      _units = widget.text.split('');
    } else {
      _units = widget.text.split(RegExp(r'(\s+)'));
    }
  }

  void _initController() {
    final int count = _units.isEmpty ? 1 : _units.length;
    final int totalMillis =
        widget.unitDuration.inMilliseconds + (count * widget.staggerDuration.inMilliseconds);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMillis),
    );
  }

  @override
  void didUpdateWidget(covariant MotionTextWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.splitMode != widget.splitMode) {
      _computeUnits();
      _controller.dispose();
      _initController();
      if (widget.autoStart) {
        _controller.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Replays the wave animation from the beginning.
  void replay() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final int count = _units.length;
    final int totalMillis = _controller.duration!.inMilliseconds;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final List<Widget> children = [];

        for (int i = 0; i < count; i++) {
          final int startMillis = i * widget.staggerDuration.inMilliseconds;
          final int endMillis = startMillis + widget.unitDuration.inMilliseconds;

          final double startNormalized =
              (startMillis / totalMillis).clamp(0.0, 1.0);
          final double endNormalized =
              (endMillis / totalMillis).clamp(0.0, 1.0);

          final double unitProgress;
          if (_controller.value <= startNormalized) {
            unitProgress = 0.0;
          } else if (_controller.value >= endNormalized) {
            unitProgress = 1.0;
          } else {
            unitProgress = widget.curve.transform(
              (_controller.value - startNormalized) /
                  (endNormalized - startNormalized),
            );
          }

          final double opacity = unitProgress;
          final double translateY = (1.0 - unitProgress) * widget.verticalOffset;

          children.add(
            Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, translateY),
                child: Text(
                  _units[i],
                  style: widget.style,
                ),
              ),
            ),
          );
        }

        return Wrap(
          alignment: _getWrapAlignment(widget.textAlign),
          children: children,
        );
      },
    );
  }

  WrapAlignment _getWrapAlignment(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return WrapAlignment.center;
      case TextAlign.right:
      case TextAlign.end:
        return WrapAlignment.end;
      case TextAlign.justify:
        return WrapAlignment.spaceBetween;
      case TextAlign.left:
      case TextAlign.start:
        return WrapAlignment.start;
    }
  }
}

