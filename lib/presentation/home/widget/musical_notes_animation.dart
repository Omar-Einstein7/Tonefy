import 'dart:math';
import 'package:flutter/material.dart';

class _NoteData {
  final String glyph;
  final double startX; // Horizontal offset within the widget
  final double delay; // Fraction 0.0–1.0

  const _NoteData({
    required this.glyph,
    required this.startX,
    required this.delay,
  });
}

/// Looping floating musical notes animation.
/// Starts when [isPlaying] is true, pauses otherwise.
class MusicalNotesAnimation extends StatefulWidget {
  final bool isPlaying;
  final double width;
  final double height;

  const MusicalNotesAnimation({
    super.key,
    required this.isPlaying,
    this.width = 80,
    this.height = 60,
  });

  @override
  State<MusicalNotesAnimation> createState() => _MusicalNotesAnimationState();
}

class _MusicalNotesAnimationState extends State<MusicalNotesAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _yAnimations;
  late final List<Animation<double>> _opacityAnimations;

  // 3 notes staggered organically
  final List<_NoteData> _notes = const [
    _NoteData(glyph: '♪', startX: 0.15, delay: 0.0),
    _NoteData(glyph: '♫', startX: 0.55, delay: 0.35),
    _NoteData(glyph: '♪', startX: 0.8, delay: 0.65),
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(_notes.length, (i) {
      final duration = Duration(milliseconds: 1400 + i * 180);
      return AnimationController(vsync: this, duration: duration);
    });

    _yAnimations = _controllers
        .map(
          (c) => Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic)),
        )
        .toList();

    _opacityAnimations = _controllers
        .map(
          (c) => TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
          ]).animate(c),
        )
        .toList();

    _applyPlayingState();
  }

  @override
  void didUpdateWidget(MusicalNotesAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) {
      _applyPlayingState();
    }
  }

  void _applyPlayingState() {
    if (widget.isPlaying) {
      for (int i = 0; i < _controllers.length; i++) {
        // Stagger the initial start using a delay fraction
        final delay = Duration(milliseconds: (_notes[i].delay * 1200).round());
        Future.delayed(delay, () {
          if (mounted && widget.isPlaying) {
            _controllers[i].repeat();
          }
        });
      }
    } else {
      for (final c in _controllers) {
        c.stop();
        c.reset();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying)
      return SizedBox(width: widget.width, height: widget.height);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: List.generate(_notes.length, (i) {
          final note = _notes[i];
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, _) {
              final yProgress = _yAnimations[i].value; // 0 = top, 1 = bottom
              final opacity = _opacityAnimations[i].value;

              // Add a subtle horizontal wobble
              final wobble = sin(_controllers[i].value * 2 * pi) * 4.0;

              final xOffset = widget.width * note.startX + wobble;
              final yOffset = widget.height * yProgress;

              return Positioned(
                left: xOffset,
                top: yOffset,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Text(
                    note.glyph,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      shadows: const [
                        Shadow(color: Colors.purpleAccent, blurRadius: 6),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
