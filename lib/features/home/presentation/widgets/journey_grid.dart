import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/widgets.dart';

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
  late int chapter;

  @override
  void initState() {
    super.initState();
    _reroll();
  }

  void _reroll() {
    setState(() {
      chapter = Random().nextInt(50) + 1; // Fake logic for now
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('قراءة من ${widget.category}'),
      content: Text('ما رأيك في قراءة الأصحاح $chapter؟'),
      actions: [
        TextButton(
          onPressed: _reroll,
          child: const Text('تغيير'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Launching ${widget.category} chapter $chapter')),
            );
          },
          child: const Text('موافق'),
        ),
      ],
    );
  }
}
