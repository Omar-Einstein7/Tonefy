import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CachedArtworkWidget extends StatelessWidget {
  final int id;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const CachedArtworkWidget({
    super.key,
    required this.id,
    this.width,
    this.height,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: QueryArtworkWidget(
        id: id,
        type: ArtworkType.AUDIO,
        artworkWidth: width ?? 50,
        artworkHeight: height ?? 50,
        artworkFit: BoxFit.cover,
        keepOldArtwork: true, // Prevents flickering during ID changes
        quality: 100, // Performance optimization
        format: ArtworkFormat.JPEG, // Faster than PNG
        nullArtworkWidget:
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[800],
              child: const Icon(Icons.music_note, color: Colors.white24),
            ),
      ),
    );
  }
}
