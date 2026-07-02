import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/core/result/result.dart';
import 'package:with_jesus/data/detox/detox_providers.dart';
import 'package:with_jesus/domain/detox/detox_reflection.dart';
import 'package:with_jesus/shared/widgets/empty_state.dart';

class DetoxReflectionsPage extends ConsumerWidget {
  const DetoxReflectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final asyncReflections = ref.watch(detoxReflectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.detoxReflectionsTitle),
      ),
      body: asyncReflections.when(
        data: (result) {
          return switch (result) {
            Success(data: final reflections) => reflections.isEmpty
                ? EmptyState(
                    icon: Icons.auto_stories_outlined,
                    title: l.detoxReflectionsEmpty,
                    subtitle: l.detoxReflectionsEmptySubtitle,
                  )
                : _ReflectionsList(reflections: reflections),
            Failure(failure: final failure) => Center(
                child: Text(failure.messageKey),
              ),
          };
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class _ReflectionsList extends ConsumerWidget {
  final List<DetoxReflection> reflections;

  const _ReflectionsList({required this.reflections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reflections.length,
      itemBuilder: (context, index) {
        final reflection = reflections[index];
        final promptText = _lookupPromptText(l, reflection.promptKey);

        return Dismissible(
          key: ValueKey(reflection.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsetsDirectional.only(end: 24),
            color: theme.colorScheme.error,
            child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(l.detoxReflectionsTitle),
                content: Text(l.detoxReflectionDeleteConfirm),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(l.detoxReflectionSkip),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(l.detoxReflectionContinue),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) {
            if (reflection.id != null) {
              ref
                  .read(detoxReflectionRepositoryProvider)
                  .delete(reflection.id!);
            }
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promptText,
                    style: theme.textTheme.titleSmall,
                  ),
                  if (reflection.answer != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      reflection.answer!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(reflection.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _lookupPromptText(AppLocalizations l, String key) {
    // Same lookup as DetoxSessionPage — map domain keys to ARB getters
    switch (key) {
      case 'detox.prompt.whyNow':
        return l.detoxPromptWhyNow;
      case 'detox.prompt.whatInstead':
        return l.detoxPromptWhatInstead;
      case 'detox.prompt.oneThingForGod':
        return l.detoxPromptOneThingForGod;
      case 'detox.prompt.justBreathe':
        return l.detoxPromptJustBreathe;
      default:
        return key;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
