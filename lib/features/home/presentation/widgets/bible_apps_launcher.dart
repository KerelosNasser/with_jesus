// Public API is self-documenting for this simple widget.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

/// Launcher for Bible companion apps in an orbital layout.
///
/// Matches the Stitch "Quietude & Light" design: a large center circle
/// (Jesus image placeholder) with three smaller orbiting circles
/// (Catena, Coptic, Katamaras) positioned around it.
class BibleAppsLauncher extends StatelessWidget {
  const BibleAppsLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Transform.scale(
      scale: 0.95,
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          children: [
            // ── Catena — top left ─────────────────────────────────────
            Positioned(
              top: 0,
              left: AppSpacing.lg,
              child: _OrbitingApp(
                colors: colors,
                icon: Icons.auto_stories,
                label: 'Catena',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Catena')),
                  );
                },
              ),
            ),

            // ── Coptic Reader — top right ─────────────────────────────
            Positioned(
              top: 0,
              right: AppSpacing.lg,
              child: _OrbitingApp(
                colors: colors,
                icon: Icons.church,
                label: 'Coptic',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coptic')),
                  );
                },
              ),
            ),

            // ── Orthodox Katamaras — bottom center ────────────────────
            Positioned(
              bottom: -AppSpacing.lg,
              left: 0,
              right: 0,
              child: Center(
                child: _OrbitingApp(
                  colors: colors,
                  icon: Icons.calendar_today,
                  label: 'Katamaras',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Katamaras')),
                    );
                  },
                ),
              ),
            ),

            // ── Center: Jesus placeholder (painted last for z-order) ──
            Positioned(
              left: (320 - 128) / 2,
              top: (320 - 128) / 2,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('يسوع')),
                    );
                  },
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Icon(
                      Icons.cruelty_free,
                      color: colors.primaryContainer,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single orbiting app circle in the bible-apps launcher.
///
/// Renders an 80×80 circle with [icon] and [label] on [colors.surfaceContainer],
/// bordered with [colors.surfaceContainerHighest]. Uses [InkWell] for Material ripple.
class _OrbitingApp extends StatelessWidget {
  final ColorScheme colors;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OrbitingApp({
    required this.colors,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            shape: BoxShape.circle,
            border: Border.all(color: colors.surfaceContainerHighest),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colors.primaryContainer, size: 24),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
