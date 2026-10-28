import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// A physics-driven spring animation widget that uses realistic mass, stiffness,
/// and damping rather than rigid time curves.
class MotionSpring extends StatefulWidget {
  const MotionSpring({
    super.key,
    required this.child,
    this.mass = 1.0,
    this.stiffness = 180.0,
    this.damping = 12.0,
    this.initialScale = 0.8,
    this.initialOffsetY = 30.0,
    this.initialOffsetX = 0.0,
    this.autoStart = true,
  });

  /// The widget to animate with spring physics.
  final Widget child;

  /// Spring mass. Default is 1.0.
  final double mass;

  /// Spring stiffness. Default is 180.0. Higher values yield faster snaps.
  final double stiffness;

  /// Damping ratio. Lower values oscillate more, higher values settle smoothly.
  final double damping;

  /// Initial scale ratio before springing to 1.0.
  final double initialScale;

  /// Initial vertical pixel offset before springing to 0.0.
  final double initialOffsetY;

  /// Initial horizontal pixel offset before springing to 0.0.
  final double initialOffsetX;

  /// Whether the spring starts automatically upon mounting.
  final bool autoStart;

  @override
  State<MotionSpring> createState() => MotionSpringState();
}

class MotionSpringState extends State<MotionSpring>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);

    if (widget.autoStart) {
      _runSpring();
    }
  }

  void _runSpring() {
    final SpringSimulation simulation = SpringSimulation(
      SpringDescription(
        mass: widget.mass,
        stiffness: widget.stiffness,
        damping: widget.damping,
      ),
      0.0,
      1.0,
      0.0,
    );

    _controller.animateWith(simulation);
  }

  /// Triggers a spring oscillation manually.
  void trigger() {
    _controller.value = 0.0;
    _runSpring();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;
        final double currentScale =
            widget.initialScale + (1.0 - widget.initialScale) * value;
        final double currentOffsetX = widget.initialOffsetX * (1.0 - value);
        final double currentOffsetY = widget.initialOffsetY * (1.0 - value);

        return Transform.translate(
          offset: Offset(currentOffsetX, currentOffsetY),
          child: Transform.scale(
            scale: currentScale,
            child: widget.child,
          ),
        );
      },
    );
  }
}

