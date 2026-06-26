# Shared Widget Library — Design Spec

**Date:** 2026-06-25  
**Project:** مع يسوع (With Jesus)  
**Scope:** `lib/shared/widgets/` — Core Component Library only

---

## 1. Goal

Implement four reusable, design-system-aligned widgets that all features in the
app can consume. Every widget:

- Sources colors **exclusively** from `Theme.of(context).colorScheme`
- Sources spacing/radius from `AppSpacing` constants
- Enforces the 48 dp minimum touch target
- Is `const`-constructable where possible

No custom colors. No magic numbers. No dark patterns.

---

## 2. Approach

**Material 3 Wrappers (Approach 1)**  
Thin wrappers around Flutter's built-in Material 3 widgets
(`FilledButton`, `OutlinedButton`, `TextButton`, `Card`, `TextField`).
`AppTheme` already configures `ThemeData` — widgets simply inherit from it.

---

## 3. Components

### 3.1 AppButton — `lib/shared/widgets/app_button.dart`

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `text` | `String` | required | Button label |
| `onPressed` | `VoidCallback?` | `null` | null = disabled |
| `type` | `AppButtonType` | `primary` | enum |
| `isLoading` | `bool` | `false` | disables + shows spinner |
| `icon` | `IconData?` | `null` | optional leading icon |

Named constructors: `.primary()`, `.secondary()`, `.text()`

Behavior:
- `isLoading == true` → `onPressed` is set to null (disabled) + label replaced by `CircularProgressIndicator`
- Minimum height: `AppSpacing.touchTarget` (48 dp)
- Border radius: `AppSpacing.radiusMd` (8 px)
- `primary` → `FilledButton` — `colorScheme.primary` / `onPrimary`
- `secondary` → `OutlinedButton` — `colorScheme.primary` outline `colorScheme.outline`
- `text` → `TextButton` — `colorScheme.primary`

---

### 3.2 SurfaceCard — `lib/shared/widgets/surface_card.dart`

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `child` | `Widget` | required | |
| `onTap` | `VoidCallback?` | `null` | null = no ripple |
| `padding` | `EdgeInsetsGeometry` | `EdgeInsets.all(AppSpacing.cardPadding)` | 16 px |
| `backgroundColor` | `Color?` | `colorScheme.surfaceContainer` | |

Behavior:
- Default radius: `AppSpacing.radiusXl` (16 px)
- Wraps Flutter `Card` with `clipBehavior: Clip.antiAlias`
- `onTap != null` → `InkWell` child for ripple; otherwise plain `Padding`
- Subtle border: `colorScheme.outlineVariant` at reduced opacity

---

### 3.3 AppTextField — `lib/shared/widgets/app_text_field.dart`

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `controller` | `TextEditingController?` | `null` | |
| `labelText` | `String?` | `null` | |
| `hintText` | `String?` | `null` | |
| `errorText` | `String?` | `null` | |
| `obscureText` | `bool` | `false` | |
| `prefixIcon` | `Widget?` | `null` | |

Behavior:
- Label sits **above** the `TextField` in a `Column` (not floating inside)
- Border radius: `AppSpacing.radiusMd` (8 px) on all border states
- Fill: `colorScheme.surface`
- Focused border: 2 px `colorScheme.primary`
- Error border: `colorScheme.error`

---

### 3.4 EmptyState — `lib/shared/widgets/empty_state.dart`

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `icon` | `IconData` | required | |
| `title` | `String` | required | |
| `subtitle` | `String?` | `null` | |
| `buttonText` | `String?` | `null` | |
| `onAction` | `VoidCallback?` | `null` | |

Behavior:
- Centered layout (column), muted `onSurfaceVariant` palette
- Icon: 64 px, `onSurfaceVariant` at half opacity
- Title: `titleLarge`, `onSurface`
- Subtitle: `bodyMedium`, `onSurfaceVariant`
- Optional CTA → `AppButton.secondary(text: buttonText, onPressed: onAction)`

---

## 4. Barrel Export

`lib/shared/widgets/widgets.dart` — exports all four components.

---

## 5. What is NOT in scope

- Theming logic (already in `lib/core/theme/`)
- Feature-specific widgets
- Navigation
- Any screen/page
- Analytics, gamification, dark patterns
