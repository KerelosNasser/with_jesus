# Design — مع يسوع (With Jesus)

> **Status:** Blueprint / pre-implementation. Last updated: 2026-06-25.
> **Companion:** `architecture.md`, `context.md`. Implements the philosophy in `context.md §2`.
> **First principle:** the phone should feel quieter, not busier. If a design choice adds
> engagement, urgency, or noise, it is wrong — even if it is "modern" or "delightful."

---

## 1. Design Philosophy

The product is a **digital spiritual retreat (خلوة)**. Design serves stillness.

| Principle | Do | Don't |
|-----------|----|-------|
| **Silence over stimulus** | Generous whitespace, slow or no motion, muted palette | Auto-playing media, blinking badges, red dots |
| **One thing at a time** | A single primary action per screen | Toolbars full of competing actions |
| **Invitation, not pressure** | "Continue reading" offered, never nagged | Streaks, guilt copy, push by default |
| **Readable above all** | Large body type, high contrast, calm line-height | Tiny gray text, dense lists |
| **Honest** | Real states: empty, loading, error — all calm | Fake skeletons that imply progress |
| **Accessible** | WCAG AA minimum, AAA where feasible | Color-only meaning, low-contrast icons |
| **Monastic, not corporate** | Hand-feel, ink, vellum, candlelight | Gradients, neon, "SaaS" look |

### Anti-patterns we explicitly forbid (addictive UX)
No infinite scroll, no pull-to-refresh-as-dopamine, no variable-reward animations,
no streak counters, no red notification dots, no auto-advancing carousels, no
count-up numbers, no confetti, no "you're on a 7-day streak 🔥". Every one of
these is a documented engagement hook; we reject them on purpose (see detox rationale
in `context.md §5`).

---

## 2. Typography

**Arabic is the default and the hardest case — we design for it first.**

### Typeface selection (recommended)
- **Arabic body:** a refined Naskh such as **"Noto Naskh Arabic"** or **"Amiri"**
  (Amiri is calligraphic, monastery-appropriate, and open-licensed — strong default
  for headings/verses). Body text stays with the more legible Noto Naskh.
- **Latin body/headings:** **"Cormorant Garamond"** or **"EB Garamond"** for a
  quiet, liturgical feel; **"Inter"** for UI chrome (small labels) where x-height
  and clarity matter.
- **Fallback:** system fonts so the app never shows missing glyphs.

> Final font files are bundled in `assets/fonts/` and declared in `pubspec.yaml`.
> Choose **one** Arabic + **one** Latin pairing and commit to it; font sprawl
> destroys a calm identity.

### Type scale (Material 3 `textTheme`, tuned for Arabic)

Token names map to Material 3 roles. Sizes in logical px (sp).

| Token | Use | Size | Weight | Line | Notes |
|-------|-----|-----:|--------|-----:|-------|
| `displayLarge` | Verse of the day (Arabic) | 34 | 500 (Amiri) | 1.5 | The hero moment; breathe around it |
| `headlineMedium` | Screen titles | 24 | 600 | 1.4 | |
| `titleLarge` | Card titles | 20 | 600 | 1.4 | |
| `titleMedium` | List item titles | 16 | 600 | 1.4 | |
| `bodyLarge` | Reading body, journal | 18 | 400 | **1.8** | Large + airy for long-form Arabic |
| `bodyMedium` | Default body | 15 | 400 | 1.7 | |
| `labelLarge` | Buttons | 14 | 600 | 1.2 | ALL CAPS off for Arabic |
| `labelSmall` | Timestamps, meta | 11 | 500 | 1.2 | Muted color |

**Arabic-specific rules**
- **Never** apply `TextTransform.uppercase` — Arabic has no case.
- Letter-spacing (`letterSpacing`) ≈ **0** for Arabic (it distorts joined glyphs);
  Latin labels may use up to +0.5.
- Use `TextHeightBehavior` to trim excessive leading at block edges.
- Numbers: honor locale digit shaping via `Intl` (Arabic-Indic digits optional,
  user setting) — but keep digits readable; default Western Arabic numerals unless
  the user opts into `٠١٢٣`.

---

## 3. Color Palette

A **single** calm identity in light + dark + an optional **"Candlelight"** warm
dark variant for evening prayer. Material 3 `ColorScheme` tokens only.

### Light — "Vellum"
```
primary        #5C6B4F  (monastery olive / sage)     <- calm, not corporate blue
onPrimary      #FFFFFF
primaryContainer #DCE4D2
secondary      #8A7B5C  (parchment tan)
tertiary       #6E5544  (wood / icon outline)
surface        #FBF8F1  (warm vellum)
surfaceVariant #EFE9DC
onSurface      #1F1B16  (warm near-black, not pure #000)
onSurfaceVariant #4D4639
outline        #7A7264
error          #9B4A3B  (muted clay-red, never alarm-red)
background     #FBF8F1
```

### Dark — "Night Vigil"
```
primary        #A9C18C  (soft sage glow)
onPrimary      #1B2216
primaryContainer #424F36
secondary      #C9B98F
tertiary       #D6BCA5
surface        #141210  (warm charcoal)
surfaceVariant #2A2620
onSurface      #EFE9DC
onSurfaceVariant #C9C2B5
outline        #8E8676
error          #D98A6E
background     #100E0C
```

### Candlelight (optional warm-dark for prayer at night)
Sub-variant of Dark with lower overall luminance and an amber accent
(`primary #C9A66B`, `surface #0E0B07`). Reduces blue-light without claiming
medical "eye strain" benefits — it is an aesthetic, calming choice.

**Color rules**
- **Color never carries meaning alone.** Always pair with an icon or text label
  (a11y). Example: error states use `error` color **and** an icon **and** text.
- **Contrast:** text-on-background ≥ 4.5:1 (AA), aiming ≥ 7:1 (AAA) for body.
  Verify with `flutter test` contrast checks / golden assertions.
- **No pure black/white** on large areas — use warm `#1F1B16` / `#FBF8F1`.
- **Limited palette:** at most 3 hues visible on a typical screen. Restraint reads
  as premium; variety reads as noise.
- Status colors used **sparingly**: a Focus session is calm sage, not green-go.

---

## 4. Iconography

- **Style:** thin/regular stroke outline icons (≈1.5–2px), rounded line caps.
  Matches the monastery/ink aesthetic. Avoid filled, glossy, or 3D icons.
- **Set:** Material Symbols (Rounded variant) as the default; custom SVGs for
  liturgical concepts not covered (cross variants, candle, incense, dove) — drawn
  in-house, consistent stroke.
- **No emoji in the UI chrome.** Emoji read as casual/engagement-y. (Emoji in
  user-authored journal text is, of course, allowed.)
- **Icon + label** for any non-obvious action (launcher shortcuts, settings).
- **Touch targets ≥ 48×48 dp**, with icon centered in the target.
- Tinted by `onSurfaceVariant` at rest, `primary` when active/selected — but
  active state is also conveyed by **shape/position**, never color alone.

---

## 5. Spacing System

A single 4 dp base grid. Use these tokens only (exposes `AppSpacing`):

| Token | dp | Use |
|-------|---:|-----|
| `xs` | 4 | tight inline gaps |
| `sm` | 8 | icon-to-label |
| `md` | 12 | list row internal |
| `lg` | 16 | card padding, default gaps |
| `xl` | 24 | section gaps |
| `xxl` | 32 | major section breaks |
| `xxxl` | 48 | screen edge breathing on tablets |
| `verse` | 64 | padding around the Verse of the Day (signature whitespace) |

- Screen horizontal padding default = **24 dp** (phones), scaling up on tablets.
- Cards have **16 dp** internal padding and **24 dp** gaps between them.
- **Whitespace is the default**, not the leftover. When in doubt, leave it out.

---

## 6. Layout Rules

- **Vertical, scannable, shallow.** Max ~5 top-level destinations. Avoid nested
  tabs deeper than two levels.
- **One hero per screen** (e.g., the Verse of the Day on Home). Everything else
  supports it.
- **Lists are finite and short.** No infinite scroll. Reading Journey shows today;
  past days are a deliberate, paginated archive — not a feed.
- **Cards, not sheets of rows.** Group related content into calm cards with clear
  borders/subtle elevation (`elevation: 0` + hairline border preferred over shadow).
- **Safe area respected** on all screens (notches, gesture nav).
- **Responsive:** `LayoutBuilder` breakpoints — phone (≤600), small tablet
  (601–840), large tablet (≥841). On tablets, content max-width ~720 dp centered
  to preserve a "page" feel rather than stretching.
- **Bottom navigation:** 3–5 items, labeled, large touch targets. It may hide
  during an active Focus Retreat.

---

## 7. Component Library

Defined in `lib/shared/widgets/` and themed centrally. Every component has light,
dark, RTL, and disabled states, plus an empty/error variant.

| Component | Notes |
|-----------|-------|
| `AppScaffold` | base scaffold: safe area, background, optional calm app bar |
| `VerseCard` | the hero card; large `displayLarge` Arabic, attribution, ample `verse` padding |
| `ReadingJourneyCard` | 4 slots (Prophet / OT / Psalm / NT) as a calm 2×2 or stacked list |
| `ContinueReadingCard` | "Continue" CTA with book/chapter + last app used |
| `ShortcutTile` | launcher shortcut to Bible apps (Catena/Coptic Reader/Katamaras) |
| `FocusTimerDial` | large, slow dial; presets 15/30/60/120 min + custom |
| `HymnRow` | title, chanter, duration, overflow menu (queue/favorite) |
| `MiniPlayer` | persistent bottom mini-player; queue/sleep timer accessible |
| `BreathingOrb` | expanding/contracting circle for breathing exercises |
| `JournalComposer` | full-screen, distraction-free writing surface |
| `EmptyState` | calm illustration (line art) + one sentence + optional action |
| `ErrorState` | calm, non-alarming; retry offered, never red-flashing |
| `CalmButton` | primary/secondary/ghost variants; generous padding |
| `CalmListTile` | list row with RTL-correct leading/trailing |
| `SegmentedChoice` | for focus duration / detox prompt choices |

Each component ships with a **golden test** (RTL + LTR + dark).

---

## 8. RTL Guidelines (Arabic is the default)

- `Directionality` is `TextDirection.rtl` by default; widgets must use
  `Directionality.of(context)` or `Start`/`End` semantics — **never** hardcode
  `left`/`right`.
- Use `EdgeInsetsDirectional`, `BorderRadiusDirectional`, `Align(alignment: AlignmentDirectional...)`.
- Icons that imply direction (back arrow, play) **flip logically**: back chevron
  points right-to-left in Arabic; **play (▶) stays ▶** (media convention) —
  document this exception.
- Lists reorder: leading = end in RTL. Avatars/icons sit on the start side.
- Sliders/progress fill from the start (right in Arabic).
- **Mirror every golden test** in both directions; CI fails on asymmetry.
- Punctuation in mixed Arabic/Latin strings: use Unicode bidi marks where needed;
  test with real sentences, not placeholders.

---

## 9. Accessibility Rules

- **Contrast ≥ AA** (4.5:1 text, 3:1 large/UI), targeting AAA for body text.
- **Touch targets ≥ 48×48 dp.**
- **Text scales:** support up to **200%** font scale without breaking layout
  (test with `MediaQuery(textScaleFactor: 2.0)`). Use `TextOverflow.ellipsis` /
  wrapping, never fixed-height text containers.
- **Semantics:** every interactive widget has a semantic label in the active
  locale. Decorative images marked `excludeSemantics`.
- **Screen reader order:** logical reading order verified with TalkBack; provide
  `Semantics(header: true)` for titles.
- **No motion?** Honor `MediaQuery.disableAnimations` / OS "remove animations" —
  breathing orb and transitions collapse to fades or instant.
- **No color-only meaning**, **no time-pressure by default** (timers are
  user-initiated, not forced).
- **Dynamic Type + bold text** respected from OS settings.
- **Haptics** optional, never required for function.

---

## 10. Motion Guidelines

Motion is **functional and slow**, never decorative.

| Use | Treatment | Duration | Curve |
|-----|-----------|------:|-------|
| Screen enter/exit | gentle fade + 4dp slide | 220 ms | `easeOut` |
| Card press | scale 0.99 + tint | 120 ms | `easeOut` |
| Sheet/modal | slide from bottom, dim background | 260 ms | `easeOut` |
| Focus timer | continuous, very slow (breath-paced) | — | linear |
| Breathing orb | 4s in / 6s out (box/4-7-8 presets) | configurable | `easeInOut` |
| State change (loading→content) | cross-fade | 180 ms | `easeInOut` |

**Forbidden:** bouncing icons, spring overshoot on every tap, parallax, shake,
count-ups, confetti, auto-advancing carousels, pull-to-refresh spinner as a
reward. Motion must never imply urgency.

---

## 11. UX Principles

1. **Default to the calm path.** Onboarding offers launcher mode but doesn't
   demand permissions up front.
2. **Friction is intentional, not accidental.** Exiting a Focus Retreat asks
   "Return to the world?" — a single calm confirm, never a wall of warnings.
3. **Progress is private.** Reading journey progress is for the user, not a
   leaderboard. No sharing buttons by default.
4. **Recoverable.** Every destructive action (delete journal entry, end retreat)
   has an undo or a calm confirmation.
5. **Localized fully.** No hardcoded strings; everything via `intl` ARB.
6. **No dark patterns.** No pre-checked boxes, no "are you sure you want to leave"
   guilt loops beyond one confirm, no manipulative copy.

---

## 12. Empty States

Calm, never alarming. Pattern: **line-art illustration + one short sentence +
(optional) one primary action.** No "Nothing here yet 😢".

```
┌───────────────────────────────────────┐
│                                       │
│            ( simple line art:         │
│              an open book )           │
│                                       │
│        لا توجد تسجيلات بعد             │
│   ستظهر هنا رحلتك اليومية للقراءة      │
│                                       │
│          [ ابدأ رحلة اليوم ]           │
│                                       │
└───────────────────────────────────────┘
```

Every feature defines its empty state in advance (see component spec).

---

## 13. Error States

Errors are honest and calm — the app never feels broken.

- Use **muted clay** (`error` token), never alarm red flashing.
- Message: what happened + what the user can do. "تعذّر تحميل الترتيل. حاول مجددًا."
- Always offer **retry** where the action is repeatable; offer **graceful
  fallback** (e.g., if MediaStore scan fails, show "اختر مجلدًا يدويًا").
- **Never** crash to a red screen in release. Catch at the boundary, show state.
- Offline is **not an error** here — it is the normal mode.

---

## 14. Visual Examples (ASCII wireframes)

### Home — Spiritual Home (RTL)
```
═══════════════════════════════════════════════════════
  ٦:٣٠ ص   ·   الأربعاء                              ⚙
─────────────────────────────────────────────────────

   "طُوبَى لِلْمَسَاكِينِ بِالرُّوحِ،
     لِأَنَّ لَهُمْ مَلَكُوتَ السَّمَاوَاتِ"
                       — متى ٥:٣


  ┌─────────────────────────────────────────────┐
  │  أكمل القراءة                                │
  │  مزامير · ٢٣                            ▸   │
  │  آخر فتح: قبطي ريدر · أمس                   │
  └─────────────────────────────────────────────┘

  رحلة اليوم
  ┌──────────────┐ ┌──────────────┐
  │ قصة نبي       │ │ عهد قديم      │
  │ إيليا         │ │ إشعياء ٤٠     │
  ├──────────────┤ ├──────────────┤
  │ مزمور         │ │ عهد جديد      │
  │ مزامير ٩١     │ │ يوحنا ١٥      │
  └──────────────┘ └──────────────┘

  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
  │كتاب  │ │طرح   │ │ترتيل │ │خلوة  │
  │مقدس  │ │قبطي  │ │      │ │      │
  └──────┘ └──────┘ └──────┘ └──────┘
═══════════════════════════════════════════════════════
```

### Focus Retreat — active
```
═══════════════════════════════════════════════════════
                       خلوة

              ●━━━━━━━━━━○
            ٢٣ : ٤٣   المتبقّي

             ( breathing orb )

           [ إنهاء الخلوة بهدوء ]
═══════════════════════════════════════════════════════
```

### Hymns — list + mini player (RTL)
```
═══════════════════════════════════════════════════════
  التراتيل                              🔍   ⋮
─────────────────────────────────────────────────────
  ♪  إبؤرو                            ⋮
     مزمور الكنيسة · ٤:١٢
  ♪  أوونين أوosti                     ⋮
     القداس · ٦:٠٨
  ♪  تين أوين                         ⋮
     ...
─────────────────────────────────────────────────────
  ┌─────────────────────────────────────────────┐
  │ ▶  إبؤرو            ١:٢٤ / ٤:١٢   ⏸  ⋮      │
  └─────────────────────────────────────────────┘
═══════════════════════════════════════════════════════
```

---

## 15. Theming Implementation Notes (for implementation phase)

- One `AppTheme` provider returns `ThemeData(light)` / `ThemeData(dark)` /
  optional candlelight, all built from tokens in this file.
- Tokens live as `const` in `lib/core/theme/tokens.dart` (colors, type, spacing).
- No hardcoded colors/sizes anywhere in feature code — only tokens.
- `Material 3` `useMaterial3: true`, `ColorScheme.fromSeed` **not** used (we want
  exact control, not seed-derived surprises) — build `ColorScheme` explicitly.
- Fonts declared once in `pubspec.yaml`; weights mapped to the chosen families.

---

*End of design.md. Tokens here are the source of truth; code must match them exactly.*
