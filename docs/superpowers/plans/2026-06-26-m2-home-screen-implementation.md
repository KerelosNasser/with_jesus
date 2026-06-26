# M2 - Home Screen (Spiritual Home) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the M2 Home Screen layout with YouVersion-style verse, shortcuts, continue reading banner, and randomized journey grid.

**Architecture:** Pure UI implementation with placeholder logic. Components are broken down into small, single-responsibility widgets inside `lib/features/home/presentation/widgets/`.

**Tech Stack:** Flutter, Material 3, Riverpod

---

### Task 1: Create Hero VerseCard

**Files:**
- Create: `lib/features/home/presentation/widgets/verse_card.dart`
- Modify: `lib/features/home/home.dart` (export it)

- [ ] **Step 1: Write the widget**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

/// A hero card displaying the verse of the day, styled beautifully.
class VerseCard extends StatelessWidget {
  const VerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'لا تخف لأني معك. لا تتلفت لأني إلهك. قد أيدتك وأعنتك وعضدتك بيمين بري.',
            style: textTheme.headlineMedium?.copyWith(
              color: colors.onPrimaryContainer,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'إشعياء ٤١: ١٠',
            style: textTheme.labelLarge?.copyWith(
              color: colors.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Export from home.dart**

Add `export 'presentation/widgets/verse_card.dart';` to `lib/features/home/home.dart`.

- [ ] **Step 3: Commit**

```bash
git add lib/features/home
git commit -m "feat(home): create hero VerseCard widget"
```

---

### Task 2: Create Shortcuts Row

**Files:**
- Create: `lib/features/home/presentation/widgets/shortcuts_row.dart`
- Modify: `lib/features/home/home.dart`

- [ ] **Step 1: Write the widget**

```dart
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
```

- [ ] **Step 2: Export from home.dart**

Add `export 'presentation/widgets/shortcuts_row.dart';` to `lib/features/home/home.dart`.

- [ ] **Step 3: Commit**

```bash
git add lib/features/home
git commit -m "feat(home): create shortcuts row widget"
```

---

### Task 3: Create Continue Reading Banner

**Files:**
- Create: `lib/features/home/presentation/widgets/continue_reading_banner.dart`
- Modify: `lib/features/home/home.dart`

- [ ] **Step 1: Write the widget**

```dart
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
```

- [ ] **Step 2: Export from home.dart**

Add `export 'presentation/widgets/continue_reading_banner.dart';` to `lib/features/home/home.dart`.

- [ ] **Step 3: Commit**

```bash
git add lib/features/home
git commit -m "feat(home): create continue reading banner widget"
```

---

### Task 4: Create Randomized Journey Grid

**Files:**
- Create: `lib/features/home/presentation/widgets/journey_grid.dart`
- Modify: `lib/features/home/home.dart`

- [ ] **Step 1: Write the widget logic**

```dart
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
      chapter: Random().nextInt(50) + 1; // Fake logic for now
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
```

- [ ] **Step 2: Export from home.dart**

Add `export 'presentation/widgets/journey_grid.dart';` to `lib/features/home/home.dart`.

- [ ] **Step 3: Commit**

```bash
git add lib/features/home
git commit -m "feat(home): create randomized journey grid and dialog"
```

---

### Task 5: Assemble HomePage

**Files:**
- Modify: `lib/features/home/home_page.dart`

- [ ] **Step 1: Replace old grid with new sections**

Remove the `_FeatureItem` class, `_featureItems` list, and `_FeatureCard` class at the bottom of `home_page.dart`.
Update `HomePage.build`:

```dart
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'presentation/widgets/continue_reading_banner.dart';
import 'presentation/widgets/journey_grid.dart';
import 'presentation/widgets/shortcuts_row.dart';
import 'presentation/widgets/verse_card.dart';

/// Home screen — the main hub of مع يسوع.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          // ── TopAppBar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: colors.surface,
            foregroundColor: colors.primary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu, color: colors.primary),
              onPressed: () {},
            ),
            title: Text(
              'مع يسوع',
              style: textTheme.headlineMedium?.copyWith(color: colors.primary),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle_outlined, color: colors.primary),
                onPressed: () {},
              ),
            ],
          ),

          // ── Hero VerseCard ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
              child: VerseCard(),
            ),
          ),

          // ── Shortcuts Row ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: ShortcutsRow(),
            ),
          ),

          // ── Continue Reading Banner ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: ContinueReadingBanner(),
            ),
          ),

          // ── Randomized Journey Grid ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
              child: JourneyGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/home
git commit -m "feat(home): assemble M2 home page layout"
```