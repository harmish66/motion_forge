import 'package:flutter/widgets.dart';
import '../core/motion_config.dart';
import 'motion_fade_slide.dart';

/// Wraps multiple children in a Column or Row and automatically applies an incremental
/// staggered entrance animation to each child.
class StaggeredMotionGroup extends StatelessWidget {
  const StaggeredMotionGroup({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 65),
    this.initialDelay = Duration.zero,
    this.itemDuration = const Duration(milliseconds: 400),
    this.direction = MotionDirection.bottom,
    this.offset = 24.0,
    this.curve = Curves.easeOutCubic,
    this.isRow = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  /// The list of child widgets to animate sequentially.
  final List<Widget> children;

  /// Time interval between the entrance of successive items.
  final Duration staggerDelay;

  /// Initial delay before the first child starts animating.
  final Duration initialDelay;

  /// Duration of each individual item transition.
  final Duration itemDuration;

  /// Direction of the slide transition for each child.
  final MotionDirection direction;

  /// Travel distance in pixels for each child.
  final double offset;

  /// Curve of each item animation.
  final Curve curve;

  /// When true, renders a Row; otherwise renders a Column.
  final bool isRow;

  /// Main axis alignment for the layout container.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment for the layout container.
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size for the layout container.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final List<Widget> animatedChildren = [];

    for (int i = 0; i < children.length; i++) {
      final Duration itemDelay =
          initialDelay + Duration(milliseconds: i * staggerDelay.inMilliseconds);

      animatedChildren.add(
        MotionFadeSlide(
          key: ValueKey('stagger_$i'),
          direction: direction,
          offset: offset,
          duration: itemDuration,
          delay: itemDelay,
          curve: curve,
          child: children[i],
        ),
      );
    }

    if (isRow) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: animatedChildren,
      );
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: animatedChildren,
    );
  }
}

