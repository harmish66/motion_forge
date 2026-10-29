# Motion Forge

A lightweight, declarative Flutter package for fluid UI animations, interactive 3D perspective transforms, physics-driven spring motion, staggered entrances, and advanced typography text animations.

## Animation Previews

| Animation | Animated Preview | Description |
| :--- | :--- | :--- |
| **MotionTilt3D** | ![MotionTilt3D Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_tilt_3d.gif) | Interactive 4x4 matrix perspective rotation on touch drag or cursor hover with dynamic specular glare. |
| **MotionFlipCard** | ![MotionFlipCard Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_flip_card.gif) | 180-degree flip in 3D perspective between front and back views with backface culling. |
| **MotionTypewriter** | ![MotionTypewriter Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_typewriter.gif) | Types, pauses, backspaces, and cycles through phrases with an animated blinking caret. |
| **MotionTextScramble** | ![MotionTextScramble Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_text_scramble.gif) | Hacker matrix decryption effect cycling through random glyphs before resolving characters. |
| **MotionTextFlip** | ![MotionTextFlip Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_text_flip.gif) | Split-flap 3D character rotation along the X-axis with perspective depth. |
| **MotionRipple** | ![MotionRipple Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_ripple.gif) | Expanding concentric radar rings around icons, buttons, or avatar badges. |
| **MotionShake** | ![MotionShake Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_shake.gif) | Sinusoidal decay oscillation feedback for validation errors and attention cues. |
| **MotionSpring** | ![MotionSpring Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_spring.gif) | Physics-driven simulation with customizable mass, stiffness, and damping. |
| **MotionMorphReveal** | ![MotionMorphReveal Preview](https://raw.githubusercontent.com/harmish66/motion_forge/main/doc/assets/motion_morph_reveal.gif) | Geometric clipping path transitions including expanding circles, directional wipes, and diamonds. |

---

## Features

### UI and Motion Animations
- **MotionTilt3D**: Interactive 3D perspective tilt that rotates cards and widgets dynamically on hover or touch drag using 4x4 matrix transforms with optional glare overlay.
- **MotionFlipCard**: Smooth 180-degree 3D perspective flip between front and back views along horizontal or vertical axes.
- **MotionShake**: Sinusoidal decay oscillation feedback for validation errors, wrong passcodes, and attention cues.
- **MotionBlurReveal**: Cinematic focus entrance transitioning from defocus blur to razor-sharp clarity.
- **MotionRipple**: Concentric radar pulse rings expanding outward around any widget or active beacon.
- **MotionMorphReveal**: Dynamic geometric clipping path transitions (circle expand, horizontal wipe, vertical wipe, diamond expand).
- **MotionSpring**: Natural physics-based spring animations driven by mass, stiffness, and damping simulations.
- **MotionShimmer**: High-performance shader mask light sweep for skeletons and UI highlights.
- **MotionBreathe**: Organic breathing pulse with customizable ambient glow.
- **MotionCountNumber**: Smoothly interpolated numeric counters with custom prefixes, suffixes, and decimals.
- **MotionAccordion**: Smooth height expand and collapse transitions for panels and dropdown cards.
- **MotionFadeSlide**: Composable fade and directional slide entrance (top, bottom, left, right).
- **MotionElasticPop**: Snappy pop-in entrance with elastic overshoot.
- **StaggeredMotionGroup**: Automated sequential entrance cascades for lists and groups.

### Typography and Text Animations
- **MotionTypewriter**: Multi-phrase cycling, customizable typing speed, backspacing, and blinking cursor.
- **MotionTextScramble**: Matrix and cyberpunk decryption text reveal using randomized glyph cycling.
- **MotionTextFlip**: Split-flap departure board 3D character rotation.
- **MotionTextGlitch**: Digital chromatic aberration with RGB slice offsets.
- **MotionTextShine**: Continuous metallic and light sweep gradient shader mask across letter glyphs.
- **MotionTextFadeScale**: Staggered word pop-in with elastic scale bounce.
- **MotionTextWave**: Sequential character or word reveal with vertical float and fade wave.

### Fluent Extensions
Call animations directly on widgets or strings:
- Widgets: `card.tilt3D()`, `input.shake()`, `badge.ripple()`, `box.shimmer()`, `item.fadeSlide()`
- Strings: `'Hello'.typewriter()`, `'Secret'.scramble()`, `'Launch'.textFlip()`, `'Cyber'.textGlitch()`, `'Pro'.textShine()`

---

## Installation

Add `motion_forge` to your `pubspec.yaml`:

```yaml
dependencies:
  motion_forge: ^0.0.3
```

Then run:

```bash
flutter pub get
```

---

## Code Examples

### 1. Typography and Text Animations

```dart
import 'package:flutter/material.dart';
import 'package:motion_forge/motion_forge.dart';

// Typewriter cycling through multiple phrases
MotionTypewriter(
  texts: const [
    'Build fluid Flutter apps',
    'Smooth physics transitions',
    'Declarative animations made simple',
  ],
  typingSpeed: Duration(milliseconds: 60),
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
);

// Matrix/Hacker scramble decryption
MotionTextScramble(
  text: 'System Authentication Verified',
  duration: Duration(milliseconds: 1200),
  style: TextStyle(fontFamily: 'monospace', fontSize: 16),
);

// Split-flap 3D letter flip
MotionTextFlip(
  text: 'FLUTTER MOTION FORGE',
  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
);

// Metallic light sweep shine
MotionTextShine(
  text: 'PREMIUM SHINE EFFECT',
  shineColor: Colors.lightBlueAccent,
);
```

### 2. Interactive 3D Perspective Tilt

```dart
MotionTilt3D(
  maxAngleX: 0.30,
  maxAngleY: 0.30,
  scaleOnHover: 1.05,
  glareEffect: true,
  child: Card(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Text('Interactive 3D Card'),
    ),
  ),
);
```

### 3. 3D Flip Card

```dart
MotionFlipCard(
  flipOnTap: true,
  front: CardFrontWidget(),
  back: CardBackWidget(),
);
```

### 4. Validation Shake

```dart
final GlobalKey<MotionShakeState> shakeKey = GlobalKey<MotionShakeState>();

MotionShake(
  key: shakeKey,
  amplitude: 14.0,
  shakes: 4,
  child: ErrorAlertWidget(),
);

// Trigger on validation failure:
shakeKey.currentState?.shake();
```

### 5. Concentric Ripple Rings

```dart
MotionRipple(
  ringColor: Color(0xFF0284C7),
  maxRadius: 50.0,
  ringCount: 3,
  child: CircleAvatar(
    child: Icon(Icons.mic),
  ),
);
```

### 6. Physics Spring

```dart
MotionSpring(
  mass: 1.0,
  stiffness: 200.0,
  damping: 12.0,
  initialScale: 0.7,
  initialOffsetY: 30.0,
  child: ActionWidget(),
);
```

---

## Running the Showcase App

To explore all interactive animations in the gallery app:

```bash
cd example
flutter run
```

---

## License

MIT License. See the LICENSE file for details.
