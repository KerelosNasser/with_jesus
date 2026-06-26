import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class ContinueReadingBanner extends StatelessWidget {
  const ContinueReadingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Card(
        elevation: 0,
        color: colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: BorderSide(color: colors.outlineVariant.withOpacity(0.5)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, 
            vertical: AppSpacing.xs,
          ),
          leading: Icon(Icons.menu_book, color: colors.primary),
          title: const Text('متابعة القراءة'),
          subtitle: const Text('إنجيل مرقس - الأصحاح ٣'),
          trailing: FilledButton.tonal(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Launching placeholder...')),
              );
            },
            child: const Text('متابعة'),
          ),
        ),
      ),
    );
  }
}
