import 'dart:async';
import 'package:flutter/widgets.dart';

/// A text widget that simulates typewriter typing, optional backspacing,
/// and looping through multiple phrases with an animated blinking cursor.
class MotionTypewriter extends StatefulWidget {
  const MotionTypewriter({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 65),
    this.deletingSpeed = const Duration(milliseconds: 35),
    this.pauseDuration = const Duration(milliseconds: 1400),
    this.cursor = '|',
    this.cursorStyle,
    this.showCursor = true,
    this.cursorBlinkPeriod = const Duration(milliseconds: 500),
    this.loop = true,
    this.autoStart = true,
    this.textAlign = TextAlign.start,
  });

  /// The list of strings to type out sequentially.
  final List<String> texts;

  /// Text style for the animated characters.
  final TextStyle? style;

  /// Duration per character while typing.
  final Duration typingSpeed;

  /// Duration per character while backspacing.
  final Duration deletingSpeed;

  /// Pause duration after typing a full string before deleting or switching.
  final Duration pauseDuration;

  /// Cursor symbol to display after the text.
  final String cursor;

  /// Text style specifically for the cursor.
  final TextStyle? cursorStyle;

  /// Whether the blinking cursor is rendered.
  final bool showCursor;

  /// Cursor blink cycle period.
  final Duration cursorBlinkPeriod;

  /// Whether to loop continuously through the phrases.
  final bool loop;

  /// Whether to start typing automatically on mount.
  final bool autoStart;

  /// Alignment of the text within its parent container.
  final TextAlign textAlign;

  @override
  State<MotionTypewriter> createState() => MotionTypewriterState();
}

class MotionTypewriterState extends State<MotionTypewriter>
    with SingleTickerProviderStateMixin {
  int _currentTextIndex = 0;
  int _characterIndex = 0;
  bool _isDeleting = false;
  bool _cursorVisible = true;
  Timer? _typingTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    if (widget.showCursor) {
      _startCursorBlink();
    }
    if (widget.autoStart && widget.texts.isNotEmpty) {
      _startTyping();
    }
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(widget.cursorBlinkPeriod, (_) {
      if (mounted) {
        setState(() {
          _cursorVisible = !_cursorVisible;
        });
      }
    });
  }

  void _startTyping() {
    if (widget.texts.isEmpty) return;

    final String currentFullText = widget.texts[_currentTextIndex];

    if (!_isDeleting) {
      if (_characterIndex < currentFullText.length) {
        _characterIndex++;
        setState(() {});
        _typingTimer = Timer(widget.typingSpeed, _startTyping);
      } else {
        // Finished typing the current string
        if (widget.texts.length > 1 && widget.loop) {
          _typingTimer = Timer(widget.pauseDuration, () {
            _isDeleting = true;
            _startTyping();
          });
        }
      }
    } else {
      if (_characterIndex > 0) {
        _characterIndex--;
        setState(() {});
        _typingTimer = Timer(widget.deletingSpeed, _startTyping);
      } else {
        // Finished deleting
        _isDeleting = false;
        _currentTextIndex = (_currentTextIndex + 1) % widget.texts.length;
        _typingTimer = Timer(const Duration(milliseconds: 250), _startTyping);
      }
    }
  }

  /// Restarts the typewriter sequence from the first phrase.
  void restart() {
    _typingTimer?.cancel();
    _currentTextIndex = 0;
    _characterIndex = 0;
    _isDeleting = false;
    setState(() {});
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.texts.isEmpty) {
      return const SizedBox.shrink();
    }

    final String currentFull = widget.texts[_currentTextIndex];
    final String displayed = currentFull.substring(0, _characterIndex.clamp(0, currentFull.length));

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        style: widget.style ?? DefaultTextStyle.of(context).style,
        children: [
          TextSpan(text: displayed),
          if (widget.showCursor)
            TextSpan(
              text: _cursorVisible ? widget.cursor : ' ',
              style: widget.cursorStyle ?? widget.style,
            ),
        ],
      ),
    );
  }
}
