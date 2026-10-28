import 'package:flutter/widgets.dart';

/// A widget that applies interactive 3D perspective tilt to its child on hover or drag.
///
/// When the user hovers or touches the widget, it calculates the offset from center
/// and rotates the child along the X and Y axes with perspective depth.
/// On release or pointer exit, it smoothly springs back to the flat position.
class MotionTilt3D extends StatefulWidget {
  const MotionTilt3D({
    super.key,
    required this.child,
    this.maxAngleX = 0.25,
    this.maxAngleY = 0.25,
    this.perspective = 0.0015,
    this.scaleOnHover = 1.04,
    this.duration = const Duration(milliseconds: 250),
    this.reverseDuration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    this.reverseCurve = Curves.easeOutBack,
    this.enableHover = true,
    this.enableTouch = true,
    this.glareEffect = false,
  });

  /// The widget to display with the 3D tilt effect.
  final Widget child;

  /// Maximum tilt angle along the X axis in radians.
  final double maxAngleX;

  /// Maximum tilt angle along the Y axis in radians.
  final double maxAngleY;

  /// Perspective distortion strength. Default is 0.0015.
  final double perspective;

  /// Scale applied to the child when tilted.
  final double scaleOnHover;

  /// Duration to reach the target tilt angle.
  final Duration duration;

  /// Duration to return to the rest position.
  final Duration reverseDuration;

  /// Animation curve when tilting towards touch or pointer.
  final Curve curve;

  /// Animation curve when returning to rest.
  final Curve reverseCurve;

  /// Whether pointer hover events trigger the tilt.
  final bool enableHover;

  /// Whether touch drag events trigger the tilt.
  final bool enableTouch;

  /// Whether to render a subtle light glare overlay.
  final bool glareEffect;

  @override
  State<MotionTilt3D> createState() => _MotionTilt3DState();
}

class _MotionTilt3DState extends State<MotionTilt3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;

  double _angleX = 0.0;
  double _angleY = 0.0;
  double _targetAngleX = 0.0;
  double _targetAngleY = 0.0;
  Offset _pointerNormalized = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnHover,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    ));
  }

  @override
  void didUpdateWidget(covariant MotionTilt3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scaleOnHover != widget.scaleOnHover ||
        oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.reverseDuration = widget.reverseDuration;
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.scaleOnHover,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePointerMove(Offset localPosition, Size size) {
    if (size.width == 0 || size.height == 0) return;

    final double normalizedX = (localPosition.dx / size.width) * 2 - 1;
    final double normalizedY = (localPosition.dy / size.height) * 2 - 1;

    setState(() {
      _pointerNormalized = Offset(normalizedX, normalizedY);
      _targetAngleY = normalizedX.clamp(-1.0, 1.0) * widget.maxAngleY;
      _targetAngleX = -normalizedY.clamp(-1.0, 1.0) * widget.maxAngleX;
      _angleX = _targetAngleX;
      _angleY = _targetAngleY;
    });

    if (!_controller.isAnimating && _controller.value != 1.0) {
      _controller.forward();
    }
  }

  void _handlePointerExit() {
    setState(() {
      _targetAngleX = 0.0;
      _targetAngleY = 0.0;
      _angleX = 0.0;
      _angleY = 0.0;
      _pointerNormalized = Offset.zero;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double currentAngleX = _angleX * _controller.value;
            final double currentAngleY = _angleY * _controller.value;

            final Matrix4 transform = Matrix4.identity()
              ..setEntry(3, 2, widget.perspective)
              ..rotateX(currentAngleX)
              ..rotateY(currentAngleY)
              ..scaleByDouble(_scaleAnimation.value, _scaleAnimation.value, 1.0, 1.0);

            return Transform(
              alignment: FractionalOffset.center,
              transform: transform,
              child: Stack(
                children: [
                  widget.child,
                  if (widget.glareEffect && _controller.value > 0.01)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(
                                -_pointerNormalized.dx,
                                -_pointerNormalized.dy,
                              ),
                              end: Alignment(
                                _pointerNormalized.dx,
                                _pointerNormalized.dy,
                              ),
                              colors: [
                                const Color(0x33FFFFFF),
                                const Color(0x00FFFFFF),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );

        Widget interactiveContent = content;

        if (widget.enableHover) {
          interactiveContent = MouseRegion(
            onHover: (event) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null && box.hasSize) {
                _handlePointerMove(event.localPosition, box.size);
              }
            },
            onExit: (_) => _handlePointerExit(),
            child: interactiveContent,
          );
        }

        if (widget.enableTouch) {
          interactiveContent = GestureDetector(
            onPanUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null && box.hasSize) {
                _handlePointerMove(details.localPosition, box.size);
              }
            },
            onPanEnd: (_) => _handlePointerExit(),
            onPanCancel: () => _handlePointerExit(),
            child: interactiveContent,
          );
        }

        return interactiveContent;
      },
    );
  }
}

