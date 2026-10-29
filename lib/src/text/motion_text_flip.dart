import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// An animated text widget that flips individual characters vertically
/// in 3D perspective with staggered timing.
class MotionTextFlip extends StatefulWidget {
  const MotionTextFlip({
    super.key,
    required this.text,
    this.style,
    this.staggerDuration = const Duration(milliseconds: 40),
    this.charDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutBack,
    this.perspective = 0.002,
    this.autoStart = true,
  });

  /// The text string to animate.
  final String text;

  /// Text style applied to characters.
  final TextStyle? style;

  /// Stagger interval between successive characters.
  final Duration staggerDuration;

  /// Duration of an individual character 3D flip.
  final Duration charDuration;

  /// Animation curve.
  final Curve curve;

  /// 3D perspective distortion factor.
  final double perspective;

  /// Whether the animation starts automatically on mount.
  final bool autoStart;

  @override
  State<MotionTextFlip> createState() => MotionTextFlipState();
}

class MotionTextFlipState extends State<MotionTextFlip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _characters;

  @override
  void initState() {
    super.initState();
    _characters = widget.text.split('');
    _initController();

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  void _initController() {
    final int count = _characters.isEmpty ? 1 : _characters.length;
    final int totalMillis =
        widget.charDuration.inMilliseconds + (count * widget.staggerDuration.inMilliseconds);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMillis),
    );
  }

  @override
  void didUpdateWidget(covariant MotionTextFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _characters = widget.text.split('');
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

  /// Replays the 3D flip animation.
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

        for (int i = 0; i < _characters.length; i++) {
          final int startMillis = i * widget.staggerDuration.inMilliseconds;
          final int endMillis = startMillis + widget.charDuration.inMilliseconds;

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

          // Angle from 90 degrees to 0 degrees
          final double angle = (1.0 - progress) * (math.pi / 2);
          final double opacity = progress.clamp(0.0, 1.0);

          final Matrix4 transform = Matrix4.identity()
            ..setEntry(3, 2, widget.perspective)
            ..rotateX(angle);

          children.add(
            Opacity(
              opacity: opacity,
              child: Transform(
                transform: transform,
                alignment: Alignment.center,
                child: Text(
                  _characters[i],
                  style: widget.style,
                ),
              ),
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
