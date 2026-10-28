import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Axis orientation along which a 3D flip card rotates.
enum FlipAxis {
  horizontal,
  vertical,
}

/// A widget that flips smoothly in 3D perspective between front and back views.
class MotionFlipCard extends StatefulWidget {
  const MotionFlipCard({
    super.key,
    required this.front,
    required this.back,
    this.flipAxis = FlipAxis.horizontal,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutCubic,
    this.flipOnTap = true,
    this.perspective = 0.0015,
  });

  /// Widget displayed on the front face.
  final Widget front;

  /// Widget displayed on the back face.
  final Widget back;

  /// Rotation axis (horizontal rotates around Y-axis, vertical rotates around X-axis).
  final FlipAxis flipAxis;

  /// Duration of the 180-degree flip transition.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Whether tapping toggles the flip state.
  final bool flipOnTap;

  /// 3D perspective distortion factor.
  final double perspective;

  @override
  State<MotionFlipCard> createState() => MotionFlipCardState();
}

class MotionFlipCardState extends State<MotionFlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isFront = true;

  /// Whether the card currently faces forward.
  bool get isFront => _isFront;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Toggles the flip card between front and back.
  void toggle() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  /// Flips to the front face.
  void showFront() {
    if (!_isFront) {
      _controller.reverse();
      setState(() {
        _isFront = true;
      });
    }
  }

  /// Flips to the back face.
  void showBack() {
    if (_isFront) {
      _controller.forward();
      setState(() {
        _isFront = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double angle = _animation.value * math.pi;
        final bool showFrontSide = angle <= (math.pi / 2);

        final Matrix4 transform = Matrix4.identity()
          ..setEntry(3, 2, widget.perspective);

        if (widget.flipAxis == FlipAxis.horizontal) {
          transform.rotateY(angle);
        } else {
          transform.rotateX(angle);
        }

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: showFrontSide
              ? widget.front
              : Transform(
                  transform: widget.flipAxis == FlipAxis.horizontal
                      ? (Matrix4.identity()..rotateY(math.pi))
                      : (Matrix4.identity()..rotateX(math.pi)),
                  alignment: Alignment.center,
                  child: widget.back,
                ),
        );
      },
    );

    if (widget.flipOnTap) {
      content = GestureDetector(
        onTap: toggle,
        child: content,
      );
    }

    return content;
  }
}

