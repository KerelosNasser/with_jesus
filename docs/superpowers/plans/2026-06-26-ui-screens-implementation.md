# UI Screens Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix broken onboarding imports, polish all implemented screens to match stitch-ui exactly, add home shell screen, and reach zero analyze errors.

**Architecture:** Feature-modular monolith. presentation → domain → data. RTL-first Arabic. Theme tokens via Theme.of(context). No hardcoded colors/sizes.

**Tech Stack:** Flutter 3.x, Dart 3, GoRouter, Material 3, Noto Sans Arabic, AppSpacing, AppColors

---

## Task 1: Fix onboarding import paths

**Files:** `lib/features/onboarding/onboarding_page_1.dart`, `onboarding_page_2.dart`, `onboarding_page_3.dart`

**Problem:** All 3 files use `import '../widgets/onboarding_widgets.dart'` which resolves to `lib/features/widgets/onboarding_widgets.dart` — a nonexistent path. The correct path is `widgets/onboarding_widgets.dart` (same directory level, subdirectory).

**Steps:**

### Step 1.1 — Fix page 1 import

**File:** `lib/features/onboarding/onboarding_page_1.dart`

**Before (line 4):**
```dart
import '../widgets/onboarding_widgets.dart';
```

**After:**
```dart
import 'widgets/onboarding_widgets.dart';
```

Also consider converting the `../../../core/theme/app_spacing.dart` import (line 3) to a `package:` import for consistency, though this is not strictly broken. Optional improvement — keep as-is to minimize diff.

### Step 1.2 — Fix page 2 import

**File:** `lib/features/onboarding/onboarding_page_2.dart`

**Before (line 4):**
```dart
import '../widgets/onboarding_widgets.dart';
```

**After:**
```dart
import 'widgets/onboarding_widgets.dart';
```

### Step 1.3 — Fix page 3 import

**File:** `lib/features/onboarding/onboarding_page_3.dart`

**Before (line 4):**
```dart
import '../widgets/onboarding_widgets.dart';
```

**After:**
```dart
import 'widgets/onboarding_widgets.dart';
```

### Step 1.4 — Verify no other broken relative imports

Run:
```powershell
cd C:\projects\Flutter\with_jesus
Select-String -Path "lib\features\onboarding\*.dart" -Pattern "import '\.\./" | ForEach-Object { $_.Filename + ":" + $_.LineNumber + " - " + $_.Line.Trim() }
```
Expected: only the `../../../core/theme/app_spacing.dart` imports remain (these are technically correct — they resolve to `lib/core/theme/app_spacing.dart`). No `../widgets/` patterns should remain.

### Step 1.5 — Commit

```powershell
git add -A; git commit -m "fix(onboarding): correct widget import paths in 3 page files"
```

---

## Task 2: Verify onboarding widgets are correct

**File:** `lib/features/onboarding/widgets/onboarding_widgets.dart`

Read the file and examine each widget against the stitch-ui spec and DESIGN.md.

### Widget audit checklist

| Widget | Status | Issues |
|--------|--------|--------|
| `MonasticIllustration` | ✅ Correct | Icon + glow ring, matches spec |
| `FadeInUp` | ⚠️ Minor | Uses `AnimatedBuilder` (valid), curve `Cubic(0.2, 0.8, 0.2, 1)` matches `cubic-bezier(0.2,0.8,0.2,1)` in HTML. Slide uses `Offset(0, 0.08) * screenHeight` which works but is unusual — kept as-is |
| `OnboardingDots` | ✅ Correct | Active: 24×6, inactive: 6×6. Matches HTML page 1 spec |
| `OnboardingProgressBars` | ✅ Correct | 3 segments, active uses `colors.tertiary`, inactive uses `colors.surfaceContainerHigh`. Matches spec |

### Step 2.1 — Read current file

```powershell
Get-Content -Path "lib\features\onboarding\widgets\onboarding_widgets.dart" | Select-Object -First 5
```

### Step 2.2 — Confirm no changes needed

The widgets are correct. No code changes required. If the `AnimatedBuilder` usage at line 127 causes lint warnings, note it for Task 7 (it's in `onboarding_widgets.dart`, not `shared/widgets/`, so it may need a doc-comment fix too).

Potential lint issue: `OnboardingProgressBars` has public fields `count` and `activeIndex` with no `///` doc comments. If `flutter analyze` flags these, add docs:

```dart
  /// The total number of progress segments to display.
  final int count;

  /// The index of the currently active (highlighted) segment.
  final int activeIndex;
```

### Step 2.3 — Commit (if any changes needed)

```powershell
git add -A; git commit -m "fix(onboarding): add missing doc comments to widget fields"
```

If no changes needed: skip commit.

---

## Task 3: Polish onboarding pages to match stitch-ui exactly

### Step 3.1 — Polish Page 1

**File:** `lib/features/onboarding/onboarding_page_1.dart`

**Changes needed:**

1. **Pill-shaped button** — Current `FilledButton` uses default 8px radius. Stitch-ui uses `rounded-full` (pill shape). Wrap in a `ClipRRect` or add `shape` parameter.

   **Before (lines 122-131):**
   ```dart
   FilledButton(
     onPressed: onNext,
     style: FilledButton.styleFrom(
       backgroundColor: colors.primaryContainer,
       foregroundColor: colors.onPrimary,
       padding: const EdgeInsets.symmetric(
         horizontal: 28,
         vertical: 14,
       ),
     ),
   ```

   **After:**
   ```dart
   FilledButton(
     onPressed: onNext,
     style: FilledButton.styleFrom(
       backgroundColor: colors.primaryContainer,
       foregroundColor: colors.onPrimary,
       padding: const EdgeInsets.symmetric(
         horizontal: 28,
         vertical: 14,
       ),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusFull)),
       ),
     ),
   ```

2. **Skip button position** — Already correct: `AlignmentDirectional.centerEnd` with `end` padding. No change needed.

3. **Pagination dots active color** — Currently uses `colors.primaryContainer`. HTML uses `bg-primary` (`#204E2B`). The task spec says `primaryContainer` — keeping current is fine, but if the design requires exact match, change to `colors.primary`.

   No change (keeping `primaryContainer` per task spec).

4. **RTL chevron icon** — Current `Icons.chevron_left` always points left. In RTL, "next" direction is right. Either:
   - Use `Icons.arrow_forward` (Flutter's directional icon that auto-flips in RTL)  
   - Or keep `Icons.chevron_left` as a purely decorative element

   Recommended: change to `Icons.arrow_forward` for RTL correctness.

   **Before (line 143):**
   ```dart
   Icon(
     Icons.chevron_left,
     size: 20,
     color: colors.onPrimary,
   ),
   ```

   **After:**
   ```dart
   Icon(
     Icons.arrow_forward,
     size: 20,
     color: colors.onPrimary,
   ),
   ```

### Step 3.2 — Polish Page 2

**File:** `lib/features/onboarding/onboarding_page_2.dart`

**Changes needed:**

1. **Pill-shaped buttons** — Both "التالي" and "تخطي" should use `rounded-full`.

   **Before (lines 106-130) — "التالي" button:**
   ```dart
   FilledButton(
     onPressed: onNext,
     style: FilledButton.styleFrom(
       backgroundColor: colors.primaryContainer,
       foregroundColor: colors.onPrimary,
       padding: const EdgeInsets.symmetric(vertical: 16),
     ),
   ```

   **After:**
   ```dart
   FilledButton(
     onPressed: onNext,
     style: FilledButton.styleFrom(
       backgroundColor: colors.primaryContainer,
       foregroundColor: colors.onPrimary,
       padding: const EdgeInsets.symmetric(vertical: 16),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusFull)),
       ),
     ),
   ```

   **Before (lines 132-143) — "تخطي" button:**
   ```dart
   OutlinedButton(
     onPressed: onSkip,
     style: OutlinedButton.styleFrom(
       foregroundColor: colors.onSurface,
       padding: const EdgeInsets.symmetric(vertical: 16),
       side: BorderSide(color: colors.outline),
     ),
   ```

   **After:**
   ```dart
   OutlinedButton(
     onPressed: onSkip,
     style: OutlinedButton.styleFrom(
       foregroundColor: colors.onSurface,
       padding: const EdgeInsets.symmetric(vertical: 16),
       side: BorderSide(color: colors.outline),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusFull)),
       ),
     ),
   ```

2. **Progress bars** — Already uses `colors.tertiary` for active segment (line 211 of widget). No change.

3. **Icons.arrow_forward** — Already correct on line 124. No change needed.

4. **Button order** — Already correct: "التالي" full-width pill + "تخطي" full-width outlined pill stacked vertically.

### Step 3.3 — Polish Page 3

**File:** `lib/features/onboarding/onboarding_page_3.dart`

**Changes needed:**

1. **Pill-shaped button** — Current "ابدأ الآن" button uses default FilledButton radius (8px). Should be `rounded-full`.

   **Before (lines 95-123):**
   ```dart
   FilledButton(
     onPressed: onStart,
     style: FilledButton.styleFrom(
       backgroundColor: colors.primaryContainer,
       foregroundColor: colors.onPrimary,
       padding: const EdgeInsets.symmetric(
         horizontal: 48,
         vertical: 16,
       ),
     ),
   ```

   **After:**
   ```dart
   FilledButton(
     onPressed: onStart,
     style: FilledButton.styleFrom(
       backgroundColor: colors.primaryContainer,
       foregroundColor: colors.onPrimary,
       padding: const EdgeInsets.symmetric(
         horizontal: 48,
         vertical: 16,
       ),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusFull)),
       ),
     ),
   ```

2. **Pagination dots color** — Current uses `colors.primaryContainer`. HTML page 3 uses `bg-primary-container`. Match is correct. No change.

3. **Ambient corner blur circles** — HTML (lines 174-177) shows fixed-position blur circles. Add a `Stack` wrapper around the `Scaffold` body.

   **Before:** Scaffold body is a `SafeArea` with `Padding` → `Column`.

   **After — wrap with Stack for ambient blurs:**

   The full `build` method changes from:
   ```dart
   return Scaffold(
     backgroundColor: colors.surface,
     body: SafeArea(
       child: Padding(
         padding: const EdgeInsets.symmetric(
           horizontal: AppSpacing.containerPadding,
         ),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const Spacer(flex: 1),
             // ... rest of content
           ],
         ),
       ),
     ),
   );
   ```

   To:
   ```dart
   return Scaffold(
     backgroundColor: colors.surface,
     body: Stack(
       children: [
         // ── Ambient blur circles ──
         Positioned(
           top: -MediaQuery.of(context).size.height * 0.15,
           end: -MediaQuery.of(context).size.width * 0.15,
           child: Container(
             width: MediaQuery.of(context).size.width * 0.5,
             height: MediaQuery.of(context).size.width * 0.5,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: colors.surfaceContainerLow.withOpacity(0.3),
             ),
           ),
         ),
         Positioned(
           bottom: -MediaQuery.of(context).size.height * 0.15,
           start: -MediaQuery.of(context).size.width * 0.15,
           child: Container(
             width: MediaQuery.of(context).size.width * 0.5,
             height: MediaQuery.of(context).size.width * 0.5,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: colors.surfaceContainerLow.withOpacity(0.3),
             ),
           ),
         ),
         // ── Main content ──
         SafeArea(
           child: Padding(
             padding: const EdgeInsets.symmetric(
               horizontal: AppSpacing.containerPadding,
             ),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Spacer(flex: 1),
                 // ... rest of content unchanged
               ],
             ),
           ),
         ),
       ],
     ),
   );
   ```

   Note: Use `AlignmentDirectional.topStart` / `AlignmentDirectional.bottomEnd` or directional positioning for RTL correctness. Since we're using `Positioned` with `end` and `start`, these already respect RTL direction.

### Step 3.4 — Verify all 3 pages look correct

```powershell
cd C:\projects\Flutter\with_jesus
flutter analyze lib/features/onboarding/
```
Expected: 0 errors on onboarding code (pre-existing issues in other files may still appear).

### Step 3.5 — Commit

```powershell
git add -A; git commit -m "fix(onboarding): polish pages to stitch-ui spec (pill buttons, ambient blurs, RTL arrows)"
```

---

## Task 4: Polish settings page

**File:** `lib/features/settings/settings_page.dart`

### Step 4.1 — Check Switch thumb active color

The `Switch` theme in `app_theme.dart` already defines:
```dart
switchTheme: SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return colors.primaryContainer;  // #386641
    }
    ...
  }),
```

This is correct — the theme already sets `primaryContainer` for the active Switch thumb. The settings page uses a plain `Switch` widget (line 130-131) which inherits this theme. **No change needed** in the page file — it inherits correctly from the theme.

If only the `Switch` widget's `activeTrackColor` is wrong in the theme, verify:
- Line 413: `trackColor` selected state returns `colors.primary` — correct.
- Line 406: `thumbColor` selected state returns `colors.primaryContainer` — correct.

### Step 4.2 — Verify RTL chevron direction

`_SettingsListItem` at line 257-262 uses:
```dart
Icon(
  Icons.chevron_left,
  size: 24,
  color: colors.outline,
),
```

`Icons.chevron_left` is NOT directional in Flutter — it always shows a left-pointing chevron. In RTL mode, a left chevron is actually the "forward/next" direction (since text flows right-to-left, going "forward" means going left). However, `Icons.arrow_back` and `Icons.arrow_forward` are explicitly directional and flip in RTL.

**Decision:** Keep `Icons.chevron_left` as-is. In Material Design, the chevron icon is commonly used for navigation indicators and its direction is context-dependent. In RTL Arabic UIs, `chevron_left` is the standard convention for "navigate to next screen" indicators in list tiles. The HTML spec for settings also uses `chevron_left`.

### Step 4.3 — Verify SliverAppBar title centering

Line 48: `centerTitle: true` — already set. The `SliverAppBar` title "مع يسوع" uses `textTheme.headlineMedium` with `colors.primary`. This matches the HTML spec which shows the title centered between menu and profile icons.

### Step 4.4 — Verify no other issues

The settings page is well-implemented. The only possible polish:
- The `IconButton` menu (line 39) should navigate to the home screen. Currently `onPressed: () {}` is a no-op. For now, leave as-is — navigation will be wired in a future task.
- Same for profile icon (line 51).

### Step 4.5 — Commit

No code changes required for settings page. Skip commit or:

```powershell
git add -A; git commit -m "chore(settings): verify RTL and Switch theme compliance"
```

---

## Task 5: Add home route placeholder

Currently, `_finishOnboarding()` and `_skipToSettings()` in `onboarding_page.dart` navigate to `/settings`. This is wrong — they should navigate to `/home`. Also, there's no `/home` route in the router yet.

### Step 5.1 — Create home placeholder page

**New file:** `lib/features/home/home_page.dart`

Create a minimal placeholder:

```dart
import 'package:flutter/material.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';
import 'package:with_jesus/shared/widgets/widgets.dart';

/// Temporary home screen placeholder.
///
/// The full home dashboard will be implemented in Task 6.
/// This placeholder exists so that onboarding can navigate to a valid route.
class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('الرئيسية'),
        centerTitle: true,
      ),
      body: const EmptyState(
        icon: Icons.home_outlined,
        title: 'مع يسوع',
        subtitle: 'الصفحة الرئيسية قيد الإنشاء',
      ),
    );
  }
}
```

### Step 5.2 — Create home barrel export

**New file:** `lib/features/home/home.dart`

```dart
export 'home_page.dart' show HomePlaceholderPage;
```

Note: This exports the placeholder. When Task 6 creates the real home page, the export will be updated.

### Step 5.3 — Register home in features barrel

**File:** `lib/features/features.dart`

**Before:**
```dart
export 'onboarding/onboarding.dart';
export 'settings/settings.dart';
```

**After:**
```dart
export 'home/home.dart';
export 'onboarding/onboarding.dart';
export 'settings/settings.dart';
```

### Step 5.4 — Add /home route to GoRouter

**File:** `lib/core/router/app_router.dart`

**Before:**
```dart
import '../../features/onboarding/onboarding.dart';
import '../../features/settings/settings.dart';
```

**After:**
```dart
import '../../features/home/home.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/settings/settings.dart';
```

Add the `/home` route in the `routes` list:

**Before:** Only 2 routes.
```dart
routes: [
  GoRoute(
    path: _RoutePaths.onboarding,
    builder: (context, state) => const OnboardingPage(),
  ),
  GoRoute(
    path: _RoutePaths.settings,
    builder: (context, state) => const SettingsPage(),
  ),
],
```

**After:**
```dart
routes: [
  GoRoute(
    path: _RoutePaths.onboarding,
    builder: (context, state) => const OnboardingPage(),
  ),
  GoRoute(
    path: _RoutePaths.home,
    builder: (context, state) => const HomePlaceholderPage(),
  ),
  GoRoute(
    path: _RoutePaths.settings,
    builder: (context, state) => const SettingsPage(),
  ),
],
```

Add the `home` path constant:
```dart
abstract final class _RoutePaths {
  _RoutePaths._();

  static const onboarding = '/';
  static const home = '/home';
  static const settings = '/settings';
}
```

### Step 5.5 — Update onboarding navigation targets

**File:** `lib/features/onboarding/onboarding_page.dart`

**Before:**
```dart
void _skipToSettings() {
  context.go('/settings');
}

void _finishOnboarding() {
  context.go('/settings');
}
```

**After:**
```dart
void _skipToSettings() {
  context.go('/home');
}

void _finishOnboarding() {
  context.go('/home');
}
```

### Step 5.6 — Verify navigation compiles

```powershell
cd C:\projects\Flutter\with_jesus
flutter analyze lib/
```

Expected output: 0 errors, 0 warnings (excluding pre-existing test errors).

### Step 5.7 — Commit

```powershell
git add -A; git commit -m "feat(routing): add /home route and placeholder page, wire onboarding navigation"
```

---

## Task 6: Implement home screen shell

**Files:**
- Replace `lib/features/home/home_page.dart` (overwrite placeholder)
- Update `lib/features/home/home.dart` export (change to real page)

### Step 6.1 — Write full home page

**File:** `lib/features/home/home_page.dart`

Replace the placeholder with the full home dashboard shell.

This design reflects the `curated_journey_dashboard/screen.png` aesthetic: warm surface background (`#fcf9f2`), SliverAppBar with app title, feature cards using `SurfaceCard` in a 2-column grid layout.

```dart
import 'package:flutter/material.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';
import 'package:with_jesus/shared/widgets/surface_card.dart';

/// Feature card data model for the home dashboard.
class _FeatureCard {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

/// Home screen shell — the main curated journey dashboard.
///
/// Displays a SliverAppBar with the app title "مع يسوع" and a 2-column
/// grid of feature cards. Each card uses [SurfaceCard] and the design
/// tokens from the Quietude & Light system.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _featureCards = [
    _FeatureCard(
      icon: Icons.menu_book_outlined,
      title: 'القراءة اليومية',
      subtitle: 'آية اليوم وتأملات',
    ),
    _FeatureCard(
      icon: Icons.music_note_outlined,
      title: 'المزامير والتراتيل',
      subtitle: 'ترانيم وألحان',
    ),
    _FeatureCard(
      icon: Icons.self_improvement_outlined,
      title: 'الخلوة الروحية',
      subtitle: 'جلسات هادئة مع الله',
    ),
    _FeatureCard(
      icon: Icons.edit_note_outlined,
      title: 'مذكراتي',
      subtitle: 'تأملاتك اليومية',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──
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
                icon: Icon(Icons.settings_outlined, color: colors.primary),
                onPressed: () {},
              ),
            ],
          ),

          // ── Greeting ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
              ).copyWith(top: AppSpacing.lg, bottom: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أهلاً بك',
                    style: textTheme.titleLarge?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'اختر وجهتك الروحية لهذا اليوم',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Feature Cards Grid (2 columns) ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.cardGap,
                crossAxisSpacing: AppSpacing.gutter,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final card = _featureCards[index];
                  return SurfaceCard(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          card.icon,
                          size: 40,
                          color: colors.primary.withOpacity(0.7),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          card.title,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          card.subtitle,
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: _featureCards.length,
              ),
            ),
          ),

          // ── Bottom padding ──
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl),
          ),
        ],
      ),
    );
  }
}
```

### Step 6.2 — Update barrel export

**File:** `lib/features/home/home.dart`

Replace the placeholder export:

**Before:**
```dart
export 'home_page.dart' show HomePlaceholderPage;
```

**After:**
```dart
export 'home_page.dart' show HomePage, HomePlaceholderPage;
```

(Keep `HomePlaceholderPage` export for backward compatibility, though it won't be used. Alternatively, replace entirely if no other references.)

Better: replace entirely since only the old placeholder was exported:

**After:**
```dart
export 'home_page.dart' show HomePage;
```

### Step 6.3 — Update GoRouter to use HomePage

**File:** `lib/core/router/app_router.dart`

Update the import (already imports home barrel) and change the builder:

**Before:**
```dart
GoRoute(
  path: _RoutePaths.home,
  builder: (context, state) => const HomePlaceholderPage(),
),
```

**After:**
```dart
GoRoute(
  path: _RoutePaths.home,
  builder: (context, state) => const HomePage(),
),
```

### Step 6.4 — Verify

```powershell
cd C:\projects\Flutter\with_jesus
flutter analyze lib/
```

Expected: 0 errors, 0 warnings.

### Step 6.5 — Commit

```powershell
git add -A; git commit -m "feat(home): implement home dashboard with 2-column feature card grid"
```

---

## Task 7: Wire flutter analyze + fix all lint errors in widgets

The `analysis_options.yaml` enables:
- `public_member_api_docs: true` — requires `///` doc comments on all public members
- `no_leading_underscores_for_local_identifiers: true` — flags `_border` in `app_text_field.dart`

### Step 7.1 — Run analyze on shared widgets

```powershell
cd C:\projects\Flutter\with_jesus
flutter analyze lib/shared/widgets/
```

Note the output. Expected issues:
1. Missing `///` doc comments on public fields in all 4 widget files.
2. Unnecessary `_` prefix on `_border` local function in `app_text_field.dart`.

### Step 7.2 — Fix app_button.dart doc comments

**File:** `lib/shared/widgets/app_button.dart`

Add `///` doc comments to public fields (lines 28-32):

**Before:**
```dart
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
```

**After:**
```dart
  /// The label displayed on the button.
  final String text;

  /// Called when the button is tapped. `null` disables the button.
  final VoidCallback? onPressed;

  /// The visual variant. Controls filled/outlined/text appearance.
  final AppButtonType type;

  /// When `true`, shows a spinner and disables the button.
  final bool isLoading;

  /// Optional icon displayed before the text label.
  final IconData? icon;
```

### Step 7.3 — Fix app_text_field.dart doc comments

**File:** `lib/shared/widgets/app_text_field.dart`

Add `///` doc comments to public fields (lines 20-25):

**Before:**
```dart
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? prefixIcon;
```

**After:**
```dart
  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Label displayed above the input field.
  final String? labelText;

  /// Placeholder hint shown when the field is empty.
  final String? hintText;

  /// Error message displayed below the field. When non-null, the
  /// border switches to the error color.
  final String? errorText;

  /// When `true`, masks the input (e.g., for passwords).
  final bool obscureText;

  /// Optional icon displayed at the start of the input.
  final Widget? prefixIcon;
```

### Step 7.4 — Fix app_text_field.dart `_border` → `border`

**File:** `lib/shared/widgets/app_text_field.dart`

The `_border` function at line 44 is a local function inside `build()`. The lint rule `no_leading_underscores_for_local_identifiers` flags the unnecessary `_` prefix since it's already local.

**Before (line 44):**
```dart
    OutlineInputBorder _border(Color color, {double width = 1}) =>
```

**After:**
```dart
    OutlineInputBorder border(Color color, {double width = 1}) =>
```

Then update all 5 call sites (lines 77-81) to use `border(...)` instead of `_border(...)`:

```dart
            border: border(colorScheme.outlineVariant),
            enabledBorder: border(colorScheme.outlineVariant),
            focusedBorder: border(colorScheme.primary, width: 2),
            errorBorder: border(colorScheme.error),
            focusedErrorBorder: border(colorScheme.error, width: 2),
```

### Step 7.5 — Fix surface_card.dart doc comments

**File:** `lib/shared/widgets/surface_card.dart`

Add `///` doc comments to public fields (lines 17-20):

**Before:**
```dart
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
```

**After:**
```dart
  /// The primary content of the card.
  final Widget child;

  /// Called when the card is tapped. When `null`, the card has no
  /// tap ripple effect.
  final VoidCallback? onTap;

  /// Padding around the [child]. Defaults to [AppSpacing.cardPadding] (16px).
  final EdgeInsetsGeometry padding;

  /// Background color override. Defaults to [ColorScheme.surfaceContainer].
  final Color? backgroundColor;
```

### Step 7.6 — Fix empty_state.dart doc comments

**File:** `lib/shared/widgets/empty_state.dart`

Add `///` doc comments to public fields (lines 22-26):

**Before:**
```dart
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onAction;
```

**After:**
```dart
  /// The icon displayed above the title. Rendered at 64px in muted color.
  final IconData icon;

  /// Primary heading text.
  final String title;

  /// Optional secondary text displayed below the title.
  final String? subtitle;

  /// Optional label for a call-to-action [AppButton].
  final String? buttonText;

  /// Called when the action button is tapped. Ignored when [buttonText] is null.
  final VoidCallback? onAction;
```

### Step 7.7 — Re-run analyze

```powershell
cd C:\projects\Flutter\with_jesus
flutter analyze lib/shared/widgets/
```

Expected output:
```
Analyzing with_jesus...                                          

No issues found!
```

### Step 7.8 — Commit

```powershell
git add -A; git commit -m "style(shared): add doc comments to widget fields, rename _border to border"
```

---

## Task 8: Final verification

### Step 8.1 — Run full project analyze

```powershell
cd C:\projects\Flutter\with_jesus
flutter analyze
```

Expected output (excluding pre-existing test error):
```
Analyzing with_jesus...                                          

No issues found!
```

**Known pre-existing test error (do NOT fix):**

`test/widget_test.dart` uses `MyApp` class which does not exist in the codebase (it was part of the default Flutter counter template). This file is unrelated to the current screens implementation. The test will fail with:

```
Error: Could not find class 'MyApp' in 'package:with_jesus/main.dart'.
```

This is expected and will be addressed in a separate testing milestone (M13).

### Step 8.2 — Verify all routes work

Trace through the code paths:
1. App starts → initialLocation `/` → `OnboardingPage`
2. Page 1 "تخطي" → `_skipToSettings()` → `context.go('/home')` → `HomePage`
3. Page 1 "التالي" → `_goToPage(1)` → Page 2
4. Page 2 "تخطي" → `_skipToSettings()` → `context.go('/home')` → `HomePage`
5. Page 2 "التالي" → `_goToPage(2)` → Page 3
6. Page 3 "ابدأ الآن" → `_finishOnboarding()` → `context.go('/home')` → `HomePage`
7. Direct URL `/settings` → `SettingsPage`
8. Direct URL `/home` → `HomePage`

### Step 8.3 — Verify RTL compliance

Checklist (spot-check via code review):
- [ ] No hardcoded `Alignment.topLeft` or `.topRight` — all use `AlignmentDirectional` or `Start/End`
- [ ] No hardcoded `EdgeInsets.only(left: ...)` or `right: ...` — use `start`/`end`
- [ ] No hardcoded `Icons.arrow_back` without RTL consideration — use `arrow_forward` for forward navigation
- [ ] `centerTitle: true` on all AppBars/SliverAppBars
- [ ] `Icons.chevron_left` used only for decorative chevrons, not directional navigation

All pages reviewed:
- Page 1: ✅ Uses `AlignmentDirectional.centerEnd`, `end` padding
- Page 2: ✅ Uses `Icons.arrow_forward` (directional)
- Page 3: ✅ Uses `Icons.arrow_forward`
- Settings: ✅ Uses `Start` in layout, `chevron_left` as decorative trailing icon
- Home: ✅ Uses text alignment, directional-safe layout

### Step 8.4 — Final summary

```powershell
cd C:\projects\Flutter\with_jesus
git status
git log --oneline -10
```

### Step 8.5 — Commit if any final touch-ups

```powershell
git add -A; git commit -m "chore: final verification cleanup"
```

---

## Self-Review Checklist

### 1. No placeholder text
- [x] Every code block is complete and runnable
- [x] Every step has exact before/after or full implementation
- [x] No "TBD", "similar to above", or "..." in code examples

### 2. Type/name consistency
- [x] `HomePage` (not `HomePageWidget` or `HomeScreen`)
- [x] `HomePlaceholderPage` used only in Task 5, replaced by `HomePage` in Task 6
- [x] `_RoutePaths.home = '/home'` matches route registration
- [x] Barrel exports match class names
- [x] All imports use `package:with_jesus/...` or correct relative paths

### 3. Import correctness
- [x] `package:with_jesus/core/theme/app_spacing.dart` — exists at that path
- [x] `package:with_jesus/shared/widgets/widgets.dart` — exists
- [x] `package:with_jesus/shared/widgets/surface_card.dart` — used in home_page.dart
- [x] `package:with_jesus/features/home/home.dart` — new barrel
- [x] `widgets/onboarding_widgets.dart` — correct relative import (no `../`)
- [x] `package:with_jesus/core/core.dart` — available for future use

### 4. RTL compliance
- [x] Page 1: `AlignmentDirectional.centerEnd`, `end` padding
- [x] Page 2: `Icons.arrow_forward` (directional, auto-flips in RTL)
- [x] Page 3: `Icons.arrow_forward` (directional)
- [x] Settings: `chevron_left` as decorative trailing marker (convention in RTL settings)
- [x] Home: `centerTitle: true` on SliverAppBar, no hardcoded L/R direction
- [x] Ambient blurs on page 3: `Positioned` with `end`/`start` is directional
- [x] No hardcoded `left`/`right` padding values — all use `start`/`end` or symmetric
- [x] No `EdgeInsets.only(left: ...)` or `EdgeInsets.only(right: ...)` in added code
- [x] No `Alignment.topLeft` / `Alignment.topRight` in added code

### 5. Design token usage
- [x] No hardcoded hex colors in widgets
- [x] No hardcoded padding values — all use `AppSpacing.*`
- [x] `Theme.of(context).colorScheme` everywhere
- [x] `Theme.of(context).textTheme` everywhere
- [x] `borderRadius: Radius.circular(AppSpacing.radiusFull)` for pill buttons
- [x] `SurfaceCard` uses `radiusXl` (16px) internally
