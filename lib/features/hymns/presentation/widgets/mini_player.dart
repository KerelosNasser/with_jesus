import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../data/hymns/hymns_audio_handler.dart';
import '../../../../data/hymns/hymns_audio_state.dart';

/// A compact mini-player that overlays the bottom of the hymns page.
///
/// Shows the currently playing hymn's title, artist, and transport controls
/// (play/pause, skip previous/next) along with a linear progress bar.
/// Auto-hides when nothing is playing (current hymn is `null` or the player
/// is in idle state).
class MiniPlayer extends ConsumerWidget {
  /// Creates a [MiniPlayer].
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentHymnAsync = ref.watch(currentHymnProvider);
    final playbackStateAsync = ref.watch(playbackStateProvider);
    final positionDataAsync = ref.watch(audioPositionProvider);

    // Don't show the mini-player if no hymn is loaded or playback is idle.
    final currentHymn = currentHymnAsync.valueOrNull;
    final playbackState = playbackStateAsync.valueOrNull;
    if (currentHymn == null ||
        playbackState?.processingState == AudioProcessingState.idle) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final positionData = positionDataAsync.valueOrNull;

    // Calculate progress fraction from position / duration.
    final progress = (positionData != null && positionData.duration > Duration.zero)
        ? (positionData.position.inMilliseconds /
                positionData.duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title, Artist, and Controls ──
          Row(
            children: [
              // Title and artist
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentHymn.title,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (currentHymn.artist.isNotEmpty)
                      Text(
                        currentHymn.artist,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Skip previous
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () =>
                    ref.read(audioHandlerProvider).skipToPrevious(),
                tooltip: 'السابق',
              ),
              // Play / Pause
              IconButton(
                icon: Icon(
                  playbackState?.playing == true
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                iconSize: 36,
                onPressed: () {
                  final handler = ref.read(audioHandlerProvider);
                  if (playbackState?.playing == true) {
                    handler.pause();
                  } else {
                    handler.play();
                  }
                },
                tooltip: playbackState?.playing == true
                    ? 'إيقاف مؤقت'
                    : 'تشغيل',
              ),
              // Skip next
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () =>
                    ref.read(audioHandlerProvider).skipToNext(),
                tooltip: 'التالي',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // ── Progress bar ──
          LinearProgressIndicator(
            value: progress,
            backgroundColor: colors.surfaceContainerHighest,
            color: colors.primary,
            minHeight: 3,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppSpacing.radiusSm),
            ),
          ),
        ],
      ),
    );
  }
}
