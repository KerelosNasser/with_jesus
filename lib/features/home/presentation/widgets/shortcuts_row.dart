import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class ShortcutsRow extends StatelessWidget {
  const ShortcutsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final shortcuts = [
      (icon: Icons.music_note, label: 'الألحان'),
      (icon: Icons.self_improvement, label: 'الخلوة'),
      (icon: Icons.book, label: 'القطمارس'),
      (icon: Icons.edit_note, label: 'المذكرات'),
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
        scrollDirection: Axis.horizontal,
        itemCount: shortcuts.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = shortcuts[index];
          return _ShortcutItem(icon: item.icon, label: item.label);
        },
      ),
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ShortcutItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: colors.surfaceContainerHighest,
          child: Icon(icon, color: colors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
