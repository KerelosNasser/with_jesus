import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../domain/bible/bible_randomizer_service.dart';
import '../../../../data/bible/bible_apps_repository.dart';

class JourneyGrid extends StatelessWidget {
  const JourneyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      (label: 'العهد القديم', icon: Icons.auto_stories),
      (label: 'العهد الجديد', icon: Icons.menu_book),
      (label: 'مزامير داود', icon: Icons.library_music),
      (label: 'الأنبياء', icon: Icons.record_voice_over),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'رحلة اليوم',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                onTap: () => _showDialog(context, cat.label),
                child: SurfaceCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: AppSpacing.xs),
                      Text(cat.label, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) => _RandomizerDialog(category: category),
    );
  }
}

class _RandomizerDialog extends StatefulWidget {
  final String category;
  const _RandomizerDialog({required this.category});

  @override
  State<_RandomizerDialog> createState() => _RandomizerDialogState();
}

class _RandomizerDialogState extends State<_RandomizerDialog> {
  late ({String book, int chapter}) _suggestion;
  final _randomizer = BibleRandomizerService(random: Random());
  final _repository = BibleAppsRepository();

  @override
  void initState() {
    super.initState();
    _reroll();
  }

  void _reroll() {
    setState(() {
      _suggestion = _randomizer.randomForCategory(widget.category);
    });
  }

  Future<void> _onRead() async {
    final apps = await _repository.getInstalledApps();
    if (apps.isEmpty) {
      // No Bible apps installed → open store for first supported app
      await _repository.openStore(_repository.getSupportedApps().first);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تثبيت تطبيق للكتاب المقدس من المتجر')),
      );
      return;
    }

    // Try with deep ref first
    final ref = 'https://www.bible.com/bible/${_suggestion.book}/${_suggestion.chapter}';
    final launched = await _repository.launchApp(apps.first, deepRef: ref);

    if (launched) {
      if (mounted) Navigator.pop(context);
      return;
    }

    // Retry without deepRef
    final launchedFallback = await _repository.launchApp(apps.first);
    if (launchedFallback) {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('قراءة من ${widget.category}'),
      content: Text('ما رأيك في قراءة ${_suggestion.book} الأصحاح ${_suggestion.chapter}؟'),
      actions: [
        TextButton(
          onPressed: _reroll,
          child: const Text('تغيير'),
        ),
        FilledButton(
          onPressed: _onRead,
          child: const Text('موافق'),
        ),
      ],
    );
  }
}
