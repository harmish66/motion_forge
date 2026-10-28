import 'package:flutter/widgets.dart';

/// Directions for directional animations such as slide and wipe reveals.
enum MotionDirection {
  top,
  bottom,
  left,
  right,
}

/// Reveal styles available for morph reveal animations.
enum RevealShape {
  circle,
  horizontalWipe,
  verticalWipe,
  diamond,
}

/// Global configuration and defaults for motion kit animations.
class MotionConfig {
  const MotionConfig._();

  static const Duration defaultDuration = Duration(milliseconds: 400);
  static const Duration defaultDelay = Duration.zero;
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve defaultBounceCurve = Curves.elasticOut;
}

