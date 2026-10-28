import 'package:flutter/widgets.dart';
import '../animations/motion_accordion.dart';
import '../animations/motion_blur_reveal.dart';
import '../animations/motion_breathe.dart';
import '../animations/motion_elastic_pop.dart';
import '../animations/motion_fade_slide.dart';
import '../animations/motion_morph_reveal.dart';
import '../animations/motion_ripple.dart';
import '../animations/motion_shake.dart';
import '../animations/motion_shimmer.dart';
import '../animations/motion_spring.dart';
import '../animations/motion_tilt_3d.dart';
import '../core/motion_config.dart';

/// Convenient extension methods on [Widget] for declarative animation chaining.
extension MotionExtensions on Widget {
  /// Wraps this widget in a [MotionTilt3D] for interactive 3D perspective tilt.
  Widget tilt3D({
    Key? key,
    double maxAngleX = 0.25,
    double maxAngleY = 0.25,
    double perspective = 0.0015,
    double scaleOnHover = 1.04,
    Duration duration = const Duration(milliseconds: 250),
    Duration reverseDuration = const Duration(milliseconds: 400),
    bool glareEffect = false,
  }) {
    return MotionTilt3D(
      key: key,
      maxAngleX: maxAngleX,
      maxAngleY: maxAngleY,
      perspective: perspective,
      scaleOnHover: scaleOnHover,
      duration: duration,
      reverseDuration: reverseDuration,
      glareEffect: glareEffect,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionMorphReveal] for geometric reveal transitions.
  Widget morphReveal({
    Key? key,
    RevealShape shape = RevealShape.circle,
    Duration duration = const Duration(milliseconds: 700),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeInOutCubic,
    Alignment centerAlignment = Alignment.center,
  }) {
    return MotionMorphReveal(
      key: key,
      shape: shape,
      duration: duration,
      delay: delay,
      curve: curve,
      centerAlignment: centerAlignment,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionShimmer] for a light-sweep shimmer effect.
  Widget shimmer({
    Key? key,
    Color baseColor = const Color(0xFFE2E8F0),
    Color highlightColor = const Color(0xFFF8FAFC),
    Duration duration = const Duration(milliseconds: 1500),
    double angle = 0.35,
    bool enabled = true,
  }) {
    return MotionShimmer(
      key: key,
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      angle: angle,
      enabled: enabled,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionSpring] for physics-driven spring motion.
  Widget animateSpring({
    Key? key,
    double mass = 1.0,
    double stiffness = 180.0,
    double damping = 12.0,
    double initialScale = 0.8,
    double initialOffsetY = 30.0,
    double initialOffsetX = 0.0,
  }) {
    return MotionSpring(
      key: key,
      mass: mass,
      stiffness: stiffness,
      damping: damping,
      initialScale: initialScale,
      initialOffsetY: initialOffsetY,
      initialOffsetX: initialOffsetX,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionFadeSlide] for fade and slide entrance.
  Widget fadeSlide({
    Key? key,
    MotionDirection direction = MotionDirection.bottom,
    double offset = 32.0,
    Duration duration = const Duration(milliseconds: 450),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOutCubic,
  }) {
    return MotionFadeSlide(
      key: key,
      direction: direction,
      offset: offset,
      duration: duration,
      delay: delay,
      curve: curve,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionElasticPop] for snappy elastic entrance.
  Widget elasticPop({
    Key? key,
    double initialScale = 0.0,
    Duration duration = const Duration(milliseconds: 600),
    Duration delay = Duration.zero,
    Curve curve = Curves.elasticOut,
  }) {
    return MotionElasticPop(
      key: key,
      initialScale: initialScale,
      duration: duration,
      delay: delay,
      curve: curve,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionBreathe] for gentle breathing pulse motion.
  Widget breathe({
    Key? key,
    double minScale = 0.96,
    double maxScale = 1.04,
    Duration period = const Duration(milliseconds: 2200),
    Curve curve = Curves.easeInOutSine,
    Color? glowColor,
    double glowRadius = 12.0,
    bool enabled = true,
  }) {
    return MotionBreathe(
      key: key,
      minScale: minScale,
      maxScale: maxScale,
      period: period,
      curve: curve,
      glowColor: glowColor,
      glowRadius: glowRadius,
      enabled: enabled,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionShake] for oscillation feedback.
  Widget shake({
    Key? key,
    ShakeDirection direction = ShakeDirection.horizontal,
    double amplitude = 12.0,
    int shakes = 4,
    Duration duration = const Duration(milliseconds: 500),
    bool autoStart = false,
  }) {
    return MotionShake(
      key: key,
      direction: direction,
      amplitude: amplitude,
      shakes: shakes,
      duration: duration,
      autoStart: autoStart,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionBlurReveal] for a defocus-to-sharpness transition.
  Widget blurReveal({
    Key? key,
    double initialSigma = 12.0,
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutCubic,
    bool autoStart = true,
  }) {
    return MotionBlurReveal(
      key: key,
      initialSigma: initialSigma,
      duration: duration,
      curve: curve,
      autoStart: autoStart,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionRipple] for expanding concentric rings.
  Widget ripple({
    Key? key,
    Color ringColor = const Color(0x330284C7),
    int ringCount = 3,
    double maxRadius = 45.0,
    Duration duration = const Duration(milliseconds: 2000),
    Curve curve = Curves.easeOutQuad,
    bool enabled = true,
  }) {
    return MotionRipple(
      key: key,
      ringColor: ringColor,
      ringCount: ringCount,
      maxRadius: maxRadius,
      duration: duration,
      curve: curve,
      enabled: enabled,
      child: this,
    );
  }

  /// Wraps this widget in a [MotionAccordion] for vertical expand/collapse.
  Widget accordion({
    Key? key,
    required bool isExpanded,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    return MotionAccordion(
      key: key,
      isExpanded: isExpanded,
      duration: duration,
      curve: curve,
      child: this,
    );
  }
}
