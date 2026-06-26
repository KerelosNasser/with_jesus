import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// Settings screen matching the stitch-ui design.
///
/// Features:
/// - TopAppBar with menu, title, and profile icons
/// - Sectioned list groups with Material 3 style
/// - Toggle switches and navigation rows
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _focusMode = true;

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
            floating: false,
            backgroundColor: colors.surface,
            foregroundColor: colors.primary,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu, color: colors.primary),
              onPressed: () {},
            ),
            title: Text(
              'مع يسوع',
              style: textTheme.headlineMedium?.copyWith(
                color: colors.primary,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle_outlined, color: colors.primary),
                onPressed: () {},
              ),
            ],
          ),

          // ── Page Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
              ).copyWith(top: AppSpacing.lg, bottom: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الإعدادات',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تخصيص تجربتك في التطبيق',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Group 1: General ──
          _SettingsGroup(
            children: [
              _SettingsListItem(
                icon: Icons.language_outlined,
                title: 'اللغة',
                trailing: Text(
                  'العربية',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                onTap: () {},
              ),
              _SettingsListItem(
                icon: Icons.palette_outlined,
                title: 'المظهر',
                trailing: Text(
                  'فاتح',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                onTap: () {},
              ),
              _SettingsListItem(
                icon: Icons.format_size_outlined,
                title: 'حجم الخط',
                trailing: Text(
                  'متوسط',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          // ── Group 2: Focus & Privacy ──
          _SettingsGroup(
            children: [
              _SettingsListItem(
                icon: Icons.self_improvement_outlined,
                title: 'وضع التركيز',
                subtitle: 'إخفاء المشتتات أثناء الصلاة',
                trailing: Switch(
                  value: _focusMode,
                  onChanged: (value) => setState(() => _focusMode = value),
                ),
                onTap: null,
              ),
              _SettingsListItem(
                icon: Icons.lock_outlined,
                title: 'الخصوصية',
                onTap: () {},
              ),
            ],
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────
// Internal helpers
// ───────────────────────────────────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(
          Divider(
            height: 1,
            indent: AppSpacing.lg + 24 + AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color: colors.surfaceContainerHighest,
          ),
        );
      }
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(
              color: colors.surfaceContainerHighest,
              width: 1,
            ),
          ),
          child: Column(
            children: items,
          ),
        ),
      ),
    );
  }
}

class _SettingsListItem extends StatelessWidget {
  const _SettingsListItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: colors.outline),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
            ] else ...[
              Icon(
                Icons.chevron_left,
                size: 24,
                color: colors.outline,
              ),
            ],
          ],
        ),
      ),
    );

    if (onTap == null) {
      return Material(
        color: Colors.transparent,
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: content,
      ),
    );
  }
}
