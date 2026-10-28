import 'package:flutter/widgets.dart';

/// A widget that smoothly expands and collapses its child vertically.
class MotionAccordion extends StatefulWidget {
  const MotionAccordion({
    super.key,
    required this.isExpanded,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
  });

  /// Controls whether the content is expanded or collapsed.
  final bool isExpanded;

  /// Content to expand or collapse.
  final Widget child;

  /// Duration of the expand/collapse transition.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  @override
  State<MotionAccordion> createState() => _MotionAccordionState();
}

class _MotionAccordionState extends State<MotionAccordion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isExpanded ? 1.0 : 0.0,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(covariant MotionAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: _animation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

