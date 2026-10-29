import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// An animated text widget that reveals text by cycling through random glyphs
/// before settling into each resolved character.
class MotionTextScramble extends StatefulWidget {
  const MotionTextScramble({
    super.key,
    required this.text,
    this.style,
    this.characters = r'!<>-_\\/[]{}~=+*^?#________',
    this.duration = const Duration(milliseconds: 900),
    this.stepInterval = const Duration(milliseconds: 35),
    this.autoStart = true,
    this.textAlign = TextAlign.start,
  });

  /// The final target text to display.
  final String text;

  /// Text style applied to the scrambled and resolved glyphs.
  final TextStyle? style;

  /// Characters used to generate the scrambled glyphs.
  final String characters;

  /// Total duration of the scramble decryption transition.
  final Duration duration;

  /// Interval between random character scrambles.
  final Duration stepInterval;

  /// Whether the animation triggers automatically on mount.
  final bool autoStart;

  /// Text alignment.
  final TextAlign textAlign;

  @override
  State<MotionTextScramble> createState() => MotionTextScrambleState();
}

class MotionTextScrambleState extends State<MotionTextScramble> {
  final math.Random _random = math.Random();
  Timer? _timer;
  late String _displayText;
  int _frame = 0;
  int _totalFrames = 0;

  @override
  void initState() {
    super.initState();
    _totalFrames =
        (widget.duration.inMilliseconds / widget.stepInterval.inMilliseconds).round();
    if (_totalFrames <= 0) _totalFrames = 1;
    _displayText = _generateScramble(0);

    if (widget.autoStart) {
      _startScramble();
    } else {
      _displayText = widget.text;
    }
  }

  void _startScramble() {
    _timer?.cancel();
    _frame = 0;
    _timer = Timer.periodic(widget.stepInterval, (timer) {
      _frame++;
      if (_frame >= _totalFrames) {
        _timer?.cancel();
        setState(() {
          _displayText = widget.text;
        });
      } else {
        setState(() {
          _displayText = _generateScramble(_frame);
        });
      }
    });
  }

  String _generateScramble(int currentFrame) {
    final int targetLength = widget.text.length;
    final double progress = currentFrame / _totalFrames;
    final int resolvedCharsCount = (progress * targetLength).floor();

    final buffer = StringBuffer();
    for (int i = 0; i < targetLength; i++) {
      if (widget.text[i] == ' ') {
        buffer.write(' ');
      } else if (i < resolvedCharsCount) {
        buffer.write(widget.text[i]);
      } else {
        final int randIndex = _random.nextInt(widget.characters.length);
        buffer.write(widget.characters[randIndex]);
      }
    }
    return buffer.toString();
  }

  /// Triggers the scramble reveal animation again.
  void scramble() {
    _startScramble();
  }

  @override
  void didUpdateWidget(covariant MotionTextScramble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startScramble();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
      textAlign: widget.textAlign,
    );
  }
}
