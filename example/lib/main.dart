import 'package:flutter/material.dart';
import 'package:motion_forge/motion_forge.dart';

void main() {
  runApp(const MotionForgeExampleApp());
}

class MotionForgeExampleApp extends StatelessWidget {
  const MotionForgeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Forge Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MotionForgeHomePage(),
    );
  }
}

class MotionForgeHomePage extends StatefulWidget {
  const MotionForgeHomePage({super.key});

  @override
  State<MotionForgeHomePage> createState() => _MotionForgeHomePageState();
}

class _MotionForgeHomePageState extends State<MotionForgeHomePage> {
  final GlobalKey<MotionSpringState> _springKey = GlobalKey<MotionSpringState>();
  final GlobalKey<MotionTextWaveState> _textWaveKey =
      GlobalKey<MotionTextWaveState>();
  final GlobalKey<MotionMorphRevealState> _morphKey =
      GlobalKey<MotionMorphRevealState>();
  final GlobalKey<MotionShakeState> _shakeKey = GlobalKey<MotionShakeState>();
  final GlobalKey<MotionBlurRevealState> _blurKey =
      GlobalKey<MotionBlurRevealState>();

  RevealShape _currentShape = RevealShape.circle;
  int _staggerKeyCounter = 0;
  bool _accordionExpanded = false;
  double _countTarget = 850.0;

  static const List<Tab> _tabs = [
    Tab(text: '3D Tilt'),
    Tab(text: '3D Flip'),
    Tab(text: 'Shake'),
    Tab(text: 'Blur Reveal'),
    Tab(text: 'Ripple'),
    Tab(text: 'Morph'),
    Tab(text: 'Text Wave'),
    Tab(text: 'Spring'),
    Tab(text: 'Shimmer & Pulse'),
    Tab(text: 'Staggered'),
    Tab(text: 'Numbers & Panel'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Motion Forge Animation Gallery'),
          backgroundColor: Colors.white,
          elevation: 0.5,
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Color(0xFF0284C7),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFF0284C7),
            indicatorWeight: 3,
            tabs: _tabs,
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabWrapper(_buildTiltDemo()),
            _buildTabWrapper(_buildFlipCardDemo()),
            _buildTabWrapper(_buildShakeDemo()),
            _buildTabWrapper(_buildBlurRevealDemo()),
            _buildTabWrapper(_buildRippleDemo()),
            _buildTabWrapper(_buildMorphDemo()),
            _buildTabWrapper(_buildTextWaveDemo()),
            _buildTabWrapper(_buildSpringDemo()),
            _buildTabWrapper(_buildShimmerAndPulseDemo()),
            _buildTabWrapper(_buildStaggeredDemo()),
            _buildTabWrapper(_buildNumbersAndAccordionDemo()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabWrapper(Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTiltDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interactive 3D Perspective Tilt',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hover or drag the card below. The widget computes the cursor offset and rotates dynamically along the X and Y axes in true 3D perspective.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 28),
        Center(
          child: MotionTilt3D(
            maxAngleX: 0.35,
            maxAngleY: 0.35,
            scaleOnHover: 1.05,
            glareEffect: true,
            child: Container(
              width: 320,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MotionTilt3D',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.touch_app, color: Colors.white70),
                    ],
                  ),
                  const Text(
                    'Drag or hover to rotate in 3D perspective space.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Interactive Matrix4',
                          style: TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlipCardDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3D Flip Card',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tap the card to smoothly flip between front and back views in 3D perspective space.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 28),
        Center(
          child: MotionFlipCard(
            front: Container(
              width: 300,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Front Card View',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(Icons.flip, color: Colors.white70),
                    ],
                  ),
                  Text(
                    'Tap anywhere on this card to flip to the back view.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            back: Container(
              width: 300,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Back Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(Icons.check_circle_outline,
                          color: Color(0xFF38BDF8)),
                    ],
                  ),
                  Text(
                    'Flipped with full 180-degree matrix transform. Tap to flip back.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShakeDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shake Feedback Animation',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sinusoidal decay oscillation ideal for validation errors, wrong codes, or attention cues.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _shakeKey.currentState?.shake(),
          child: const Text('Trigger Validation Shake'),
        ),
        const SizedBox(height: 32),
        Center(
          child: MotionShake(
            key: _shakeKey,
            amplitude: 14.0,
            shakes: 4,
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFEF4444)),
                  SizedBox(width: 12),
                  Text(
                    'Invalid entry detected',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlurRevealDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Blur to Sharp Focus Reveal',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Smoothly transitions from a blurred state to razor-sharp focus with opacity interpolation.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _blurKey.currentState?.replay(),
          icon: const Icon(Icons.refresh),
          label: const Text('Replay Focus Transition'),
        ),
        const SizedBox(height: 32),
        Center(
          child: MotionBlurReveal(
            key: _blurKey,
            initialSigma: 16.0,
            duration: const Duration(milliseconds: 700),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.camera, color: Color(0xFF38BDF8), size: 40),
                  SizedBox(height: 12),
                  Text(
                    'Cinematic Focus Reveal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Transitions from defocus blur to clarity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRippleDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expanding Concentric Ripple Rings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Radar pulse rings expanding outward around any widget for active indicators or live beacons.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 48),
        Center(
          child: MotionRipple(
            ringColor: const Color(0xFF0284C7),
            maxRadius: 50.0,
            ringCount: 3,
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF0284C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMorphDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Morph Reveal Transitions',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Geometric clipping paths allow smooth circular, wipe, or diamond reveal animations.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() => _currentShape = RevealShape.circle);
                _morphKey.currentState?.reset();
                _morphKey.currentState?.reveal();
              },
              child: const Text('Circle Expand'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _currentShape = RevealShape.horizontalWipe);
                _morphKey.currentState?.reset();
                _morphKey.currentState?.reveal();
              },
              child: const Text('Horizontal Wipe'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _currentShape = RevealShape.diamond);
                _morphKey.currentState?.reset();
                _morphKey.currentState?.reveal();
              },
              child: const Text('Diamond Expand'),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Center(
          child: MotionMorphReveal(
            key: _morphKey,
            shape: _currentShape,
            duration: const Duration(milliseconds: 650),
            child: Container(
              width: 340,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(24),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF38BDF8), size: 40),
                  SizedBox(height: 12),
                  Text(
                    'Revealed Card Content',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Dynamic geometric clipping in action.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextWaveDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text Wave and Character Reveal',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Staggers individual characters with smooth vertical translation and opacity fade.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _textWaveKey.currentState?.replay(),
          icon: const Icon(Icons.replay),
          label: const Text('Replay Wave'),
        ),
        const SizedBox(height: 36),
        Center(
          child: MotionTextWave(
            key: _textWaveKey,
            text: 'Fluid animations built natively for Flutter',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpringDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Physics Spring Animation',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Realistic spring motion driven by mass, stiffness, and damping simulations.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _springKey.currentState?.trigger(),
          child: const Text('Trigger Spring Bounce'),
        ),
        const SizedBox(height: 36),
        Center(
          child: MotionSpring(
            key: _springKey,
            mass: 1.0,
            stiffness: 220.0,
            damping: 14.0,
            initialScale: 0.65,
            initialOffsetY: 40.0,
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.bolt, color: Color(0xFF0284C7), size: 36),
                  SizedBox(height: 8),
                  Text(
                    'SpringSimulation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Natural rebound without fixed curves.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerAndPulseDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shimmer Sweep and Organic Breathe',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Smooth light sweep shader mask and subtle organic breathing pulse.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text('Shimmer Card',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                MotionShimmer(
                  baseColor: const Color(0xFFE2E8F0),
                  highlightColor: const Color(0xFFFFFFFF),
                  child: Container(
                    width: 140,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 100,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text('Breathe Pulse',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                MotionBreathe(
                  minScale: 0.94,
                  maxScale: 1.06,
                  glowColor: const Color(0xFF0284C7),
                  glowRadius: 16.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Status Pulse',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStaggeredDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Staggered Entrance Cascade',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Automatically cascades entrance transitions across child elements with incremental delay.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _staggerKeyCounter++;
            });
          },
          child: const Text('Re-trigger Cascade'),
        ),
        const SizedBox(height: 24),
        StaggeredMotionGroup(
          key: ValueKey('stagger_group_$_staggerKeyCounter'),
          staggerDelay: const Duration(milliseconds: 90),
          direction: MotionDirection.bottom,
          offset: 28.0,
          children: List.generate(
            4,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Item ${index + 1}: Cascaded animation element'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumbersAndAccordionDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number Counter and Accordion',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Interpolated numeric counters and animated accordion expandable cards.',
          style: TextStyle(color: Color(0xFF475569)),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interpolated Counter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              MotionCountNumber(
                begin: 100,
                end: _countTarget,
                prefix: '\$',
                duration: const Duration(milliseconds: 1000),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _countTarget = _countTarget == 850.0 ? 1420.0 : 850.0;
                  });
                },
                child: const Text('Update Target Number'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text('Expandable Section Panel'),
                trailing: Icon(
                  _accordionExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _accordionExpanded = !_accordionExpanded;
                  });
                },
              ),
              MotionAccordion(
                isExpanded: _accordionExpanded,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'This expandable accordion content opens and closes with smooth height animation interpolation.',
                      style: TextStyle(color: Color(0xFF334155)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
