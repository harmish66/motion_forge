import 'package:flutter/widgets.dart';

/// An animated text widget where each word pops into view sequentially
/// with elastic scale and opacity fade.
class MotionTextFadeScale extends StatefulWidget {
  const MotionTextFadeScale({
    super.key,
    required this.text,
    this.style,
    this.staggerDuration = const Duration(milliseconds: 120),
    this.wordDuration = const Duration(milliseconds: 450),
    this.initialScale = 0.2,
    this.curve = Curves.easeOutBack,
    this.autoStart = true,
  });

  /// The text content.
  final String text;

  /// Text style.
  final TextStyle? style;

  /// Delay between the start of adjacent words.
  final Duration staggerDuration;

  /// Duration of an individual word entrance.
  final Duration wordDuration;

  /// Initial scale ratio before expanding to 1.0.
  final double initialScale;

  /// Entrance easing curve.
  final Curve curve;

  /// Whether the animation plays automatically on mount.
  final bool autoStart;

  @override
  State<MotionTextFadeScale> createState() => MotionTextFadeScaleState();
}

class MotionTextFadeScaleState extends State<MotionTextFadeScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _words;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');
    _initController();

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  void _initController() {
    final int count = _words.isEmpty ? 1 : _words.length;
    final int totalMillis =
        widget.wordDuration.inMilliseconds + (count * widget.staggerDuration.inMilliseconds);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMillis),
    );
  }

  @override
  void didUpdateWidget(covariant MotionTextFadeScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _words = widget.text.split(' ');
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

  /// Replays the entrance animation.
  void replay() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final int totalMillis = _controller.duration!.inMilliseconds;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final List<Widget> children = [];

        for (int i = 0; i < _words.length; i++) {
          final int startMillis = i * widget.staggerDuration.inMilliseconds;
          final int endMillis = startMillis + widget.wordDuration.inMilliseconds;

          final double startNormalized = (startMillis / totalMillis).clamp(0.0, 1.0);
          final double endNormalized = (endMillis / totalMillis).clamp(0.0, 1.0);

          final double progress;
          if (_controller.value <= startNormalized) {
            progress = 0.0;
          } else if (_controller.value >= endNormalized) {
            progress = 1.0;
          } else {
            progress = widget.curve.transform(
              (_controller.value - startNormalized) / (endNormalized - startNormalized),
            );
          }

          final double scale =
              widget.initialScale + (1.0 - widget.initialScale) * progress;
          final double opacity = progress.clamp(0.0, 1.0);

          children.add(
            Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Text(_words[i], style: widget.style),
                ),
              ),
            ),
          );
        }

        return Wrap(
          children: children,
        );
      },
    );
  }
}
