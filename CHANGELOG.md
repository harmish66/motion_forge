# Changelog

## 0.0.2

- Refactored `MotionAccordion` to use `ClipRect` and `Align` height factors, eliminating deprecated `axisAlignment`.
- Updated `MotionTilt3D` matrix scaling to use `scaleByDouble` to address deprecation warnings on newer SDKs.
- Clean static analysis pass with zero warnings for full pub points.

## 0.0.1

- Initial release of motion_forge.
- Added MotionTilt3D with interactive 4x4 matrix perspective transforms and glare overlay.
- Added MotionFlipCard with 180-degree 3D perspective flip.
- Added MotionShake with sinusoidal decay oscillation for validation feedback.
- Added MotionBlurReveal with defocus to sharp focus transitions.
- Added MotionRipple with expanding concentric radar rings.
- Added MotionMorphReveal with circle, diamond, and wipe clipping paths.
- Added MotionTextWave for staggered character and word reveal.
- Added MotionSpring physics simulation with mass, stiffness, and damping controls.
- Added MotionShimmer light sweep shader mask.
- Added MotionBreathe organic pulsing scale with ambient glow.
- Added MotionCountNumber for smooth numeric interpolation.
- Added MotionAccordion for vertical height expand and collapse transitions.
- Added MotionFadeSlide and MotionElasticPop entrance transitions.
- Added StaggeredMotionGroup for list cascades.
- Added fluent Widget extension methods.
