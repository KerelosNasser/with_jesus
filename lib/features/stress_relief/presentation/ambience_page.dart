import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/ambience_player_provider.dart';

/// Ambience sound picker and player page.
///
/// Displays a list of ambient sounds (rain, church bells, wind, chant echo)
/// with play/pause controls and a volume slider.
class AmbiencePage extends ConsumerWidget {
  /// Creates an [AmbiencePage].
  const AmbiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(ambiencePlayerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.calmAmbience)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        children: [
          // Sound cards
          for (final sound in AmbienceSound.values)
            _AmbienceCard(
              sound: sound,
              isCurrent: state.currentSound == sound,
              isPlaying: state.isPlaying && state.currentSound == sound,
              onToggle: () {
                if (state.currentSound == sound) {
                  if (state.isPlaying) {
                    ref.read(ambiencePlayerProvider.notifier).pause();
                  } else {
                    ref.read(ambiencePlayerProvider.notifier).resume();
                  }
                } else {
                  ref.read(ambiencePlayerProvider.notifier).play(sound);
                }
              },
            ),

          const SizedBox(height: AppSpacing.xl),

          // Volume slider
          Row(
            children: [
              const Icon(Icons.volume_down),
              Expanded(
                child: Slider(
                  value: state.volume,
                  onChanged: (v) =>
                      ref.read(ambiencePlayerProvider.notifier).setVolume(v),
                ),
              ),
              const Icon(Icons.volume_up),
            ],
          ),
          Center(
            child: Text(
              l.calmAmbienceVolume,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbienceCard extends StatelessWidget {
  const _AmbienceCard({
    required this.sound,
    required this.isCurrent,
    required this.isPlaying,
    required this.onToggle,
  });

  final AmbienceSound sound;
  final bool isCurrent;
  final bool isPlaying;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final label = _soundLabel(l, sound.nameKey);
    final icon = _soundIcon(sound);

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: isCurrent ? theme.colorScheme.primary : null,
        ),
        title: Text(label),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
          onPressed: onToggle,
        ),
        selected: isCurrent,
      ),
    );
  }

  IconData _soundIcon(AmbienceSound sound) {
    return switch (sound) {
      AmbienceSound.rain => Icons.water_drop,
      AmbienceSound.churchBells => Icons.church,
      AmbienceSound.wind => Icons.air,
      AmbienceSound.chantEcho => Icons.record_voice_over,
    };
  }

  String _soundLabel(AppLocalizations l, String nameKey) {
    return switch (nameKey) {
      'calmAmbienceRain' => l.calmAmbienceRain,
      'calmAmbienceChurchBells' => l.calmAmbienceChurchBells,
      'calmAmbienceWind' => l.calmAmbienceWind,
      'calmAmbienceChantEcho' => l.calmAmbienceChantEcho,
      _ => nameKey,
    };
  }
}
