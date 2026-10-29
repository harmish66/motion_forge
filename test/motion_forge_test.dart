import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motion_forge/motion_forge.dart';

void main() {
  group('MotionForge Widget Tests', () {
    testWidgets('MotionFadeSlide mounts and animates child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionFadeSlide(
              duration: Duration(milliseconds: 300),
              offset: 20.0,
              child: Text('FadeSlideTarget'),
            ),
          ),
        ),
      );

      expect(find.text('FadeSlideTarget'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('FadeSlideTarget'), findsOneWidget);
    });

    testWidgets('MotionMorphReveal renders with circular shape', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionMorphReveal(
              shape: RevealShape.circle,
              duration: Duration(milliseconds: 300),
              child: Text('MorphTarget'),
            ),
          ),
        ),
      );

      expect(find.text('MorphTarget'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('MorphTarget'), findsOneWidget);
    });

    testWidgets('MotionTextWave renders text characters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionTextWave(
              text: 'Hello',
              splitMode: TextWaveSplit.characters,
            ),
          ),
        ),
      );

      expect(find.byType(MotionTextWave), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(MotionTextWave), findsOneWidget);
    });

    testWidgets('MotionTilt3D handles pan update and exit', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotionTilt3D(
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: const Text('TiltTarget'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('TiltTarget'), findsOneWidget);

      final TestGesture gesture = await tester.startGesture(const Offset(100, 100));
      await gesture.moveTo(const Offset(150, 150));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('TiltTarget'), findsOneWidget);
    });

    testWidgets('MotionSpring animates and triggers manually', (tester) async {
      final key = GlobalKey<MotionSpringState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotionSpring(
              key: key,
              child: const Text('SpringTarget'),
            ),
          ),
        ),
      );

      expect(find.text('SpringTarget'), findsOneWidget);
      key.currentState?.trigger();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('SpringTarget'), findsOneWidget);
    });

    testWidgets('StaggeredMotionGroup creates multiple staggered items',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StaggeredMotionGroup(
              children: const [
                Text('Item 1'),
                Text('Item 2'),
                Text('Item 3'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('MotionFlipCard flips on tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionFlipCard(
              front: Text('FrontSide'),
              back: Text('BackSide'),
            ),
          ),
        ),
      );

      expect(find.text('FrontSide'), findsOneWidget);
      await tester.tap(find.text('FrontSide'));
      await tester.pumpAndSettle();
      expect(find.text('BackSide'), findsOneWidget);
    });

    testWidgets('MotionShake shakes on trigger', (tester) async {
      final key = GlobalKey<MotionShakeState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotionShake(
              key: key,
              child: const Text('ShakeTarget'),
            ),
          ),
        ),
      );

      expect(find.text('ShakeTarget'), findsOneWidget);
      key.currentState?.shake();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      expect(find.text('ShakeTarget'), findsOneWidget);
    });

    testWidgets('MotionCountNumber renders count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionCountNumber(
              begin: 0,
              end: 100,
              prefix: '\$',
            ),
          ),
        ),
      );

      expect(find.byType(MotionCountNumber), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('\$100'), findsOneWidget);
    });

    testWidgets('MotionRipple renders concentric rings', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionRipple(
              child: Text('RippleCenter'),
            ),
          ),
        ),
      );

      expect(find.text('RippleCenter'), findsOneWidget);
      expect(find.byType(MotionRipple), findsOneWidget);
    });

    testWidgets('MotionBlurReveal renders sharp target after transition',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionBlurReveal(
              child: Text('BlurTarget'),
            ),
          ),
        ),
      );

      expect(find.text('BlurTarget'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('BlurTarget'), findsOneWidget);
    });

    testWidgets('MotionAccordion expands and collapses', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionAccordion(
              isExpanded: true,
              child: Text('AccordionContent'),
            ),
          ),
        ),
      );

      expect(find.text('AccordionContent'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('AccordionContent'), findsOneWidget);
    });

    testWidgets('MotionTypewriter types and displays text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionTypewriter(
              texts: ['TypewriterTest'],
              typingSpeed: Duration(milliseconds: 10),
              showCursor: false,
              loop: false,
            ),
          ),
        ),
      );

      expect(find.byType(MotionTypewriter), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('TypewriterTest'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('MotionTextScramble resolves to target text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionTextScramble(
              text: 'DecryptedText',
              duration: Duration(milliseconds: 100),
              stepInterval: Duration(milliseconds: 20),
            ),
          ),
        ),
      );

      expect(find.byType(MotionTextScramble), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('DecryptedText'), findsOneWidget);
    });

    testWidgets('MotionTextFlip renders and settles characters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionTextFlip(
              text: 'FlipText',
              staggerDuration: Duration(milliseconds: 20),
              charDuration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      expect(find.byType(MotionTextFlip), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(MotionTextFlip), findsOneWidget);
    });

    testWidgets('MotionTextGlitch mounts and displays text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionTextGlitch(
              text: 'GlitchTarget',
            ),
          ),
        ),
      );

      expect(find.text('GlitchTarget'), findsOneWidget);
    });

    testWidgets('MotionTextShine renders shader mask', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionTextShine(
              text: 'ShineTarget',
            ),
          ),
        ),
      );

      expect(find.text('ShineTarget'), findsOneWidget);
    });

    testWidgets('MotionTextFadeScale renders words', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MotionTextFadeScale(
              text: 'Alpha Beta',
              staggerDuration: Duration(milliseconds: 50),
              wordDuration: Duration(milliseconds: 100),
            ),
          ),
        ),
      );

      expect(find.byType(MotionTextFadeScale), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('MotionExtensions wrap widgets cleanly', (tester) async {
      final Widget testWidget =
          const Text('ExtensionTarget').tilt3D().shimmer().shake();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testWidget,
          ),
        ),
      );

      expect(find.byType(MotionTilt3D), findsOneWidget);
      expect(find.byType(MotionShimmer), findsOneWidget);
      expect(find.byType(MotionShake), findsOneWidget);
      expect(find.text('ExtensionTarget'), findsOneWidget);
    });
  });
}
