import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/hymns/hymns_audio_handler.dart';
import '../../../data/hymns/hymns_repository.dart';
import 'widgets/mini_player.dart';

/// Hymns & liturgical audio screen.
///
/// Displays a scrollable list of available hymns scanned from the device's
/// local storage. A persistent [MiniPlayer] overlays the bottom of the screen
/// for playback control when a hymn is active.
class HymnsPage extends ConsumerWidget {
  /// Creates a [HymnsPage].
  const HymnsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hymnsAsync = ref.watch(hymnsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('الألحان والترانيم'),
        backgroundColor: colors.surface,
        foregroundColor: colors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          // ── Hymn list ──
          hymnsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'تعذر تحميل الألحان',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.error,
                  ),
                ),
              ),
            ),
            data: (hymns) {
              if (hymns.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'لم يتم العثور على ألحان',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(
                  left: AppSpacing.containerPadding,
                  right: AppSpacing.containerPadding,
                  top: AppSpacing.sm,
                  bottom: 120, // Space for the mini-player overlay.
                ),
                itemCount: hymns.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  indent: AppSpacing.lg,
                  endIndent: AppSpacing.lg,
                  color: colors.surfaceContainerHighest,
                ),
                itemBuilder: (context, index) {
                  final hymn = hymns[index];
                  return ListTile(
                    title: Text(
                      hymn.title,
                      style: textTheme.bodyLarge,
                    ),
                    subtitle: hymn.artist.isNotEmpty
                        ? Text(
                            hymn.artist,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          )
                        : null,
                    trailing: hymn.duration != null
                        ? Text(
                            _formatDuration(hymn.duration!),
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          )
                        : null,
                    onTap: () async {
                      final handler = ref.read(audioHandlerProvider);
                      await handler.loadPlaylist(hymns, initialIndex: index);
                      await handler.play();
                    },
                  );
                },
              );
            },
          ),

          // ── Mini-player overlay at the bottom ──
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}

/// Formats a [Duration] into a `MM:SS` string for display.
String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
