import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// An animated text widget that produces occasional digital glitch slices
/// and chromatic aberration offsets.
class MotionTextGlitch extends StatefulWidget {
  const MotionTextGlitch({
    super.key,
    required this.text,
    this.style,
    this.glitchInterval = const Duration(milliseconds: 2500),
    this.glitchDuration = const Duration(milliseconds: 200),
    this.maxOffset = 6.0,
    this.autoStart = true,
  });

  /// The text content to display.
  final String text;

  /// Text style.
  final TextStyle? style;

  /// Interval between random glitch bursts.
  final Duration glitchInterval;

  /// Duration of an individual glitch glitch event.
  final Duration glitchDuration;

  /// Maximum pixel displacement during glitch.
  final double maxOffset;

  /// Whether the glitch timer runs automatically.
  final bool autoStart;

  @override
  State<MotionTextGlitch> createState() => MotionTextGlitchState();
}

class MotionTextGlitchState extends State<MotionTextGlitch> {
  final math.Random _random = math.Random();
  Timer? _intervalTimer;
  Timer? _burstTimer;
  bool _isGlitching = false;
  double _offsetX = 0.0;
  double _offsetY = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      _startGlitchLoop();
    }
  }

  void _startGlitchLoop() {
    _intervalTimer = Timer.periodic(widget.glitchInterval, (_) {
      triggerGlitch();
    });
  }

  /// Triggers a glitch burst manually.
  void triggerGlitch() {
    if (!mounted) return;
    setState(() {
      _isGlitching = true;
      _offsetX = (_random.nextDouble() * 2 - 1) * widget.maxOffset;
      _offsetY = (_random.nextDouble() * 2 - 1) * (widget.maxOffset * 0.4);
    });

    _burstTimer?.cancel();
    _burstTimer = Timer(widget.glitchDuration, () {
      if (mounted) {
        setState(() {
          _isGlitching = false;
          _offsetX = 0.0;
          _offsetY = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _intervalTimer?.cancel();
    _burstTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = widget.style ?? DefaultTextStyle.of(context).style;

    if (!_isGlitching) {
      return Text(widget.text, style: baseStyle);
    }

    return Stack(
      children: [
        // Cyan / Blue offset layer
        Transform.translate(
          offset: Offset(-_offsetX, 0),
          child: Text(
            widget.text,
            style: baseStyle.copyWith(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.75),
            ),
          ),
        ),
        // Red offset layer
        Transform.translate(
          offset: Offset(_offsetX, _offsetY),
          child: Text(
            widget.text,
            style: baseStyle.copyWith(
              color: const Color(0xFFFF1744).withValues(alpha: 0.75),
            ),
          ),
        ),
        // Main layer
        Text(widget.text, style: baseStyle),
      ],
    );
  }
}
