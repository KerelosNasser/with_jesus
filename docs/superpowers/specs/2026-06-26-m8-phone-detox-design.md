# Phone Detox (M8) Design Specification

> **Status:** Approved design (brainstormed 2026-06-26). Pre-implementation.
> **Milestone:** M8 — Phone Detox · **Tracker exit criteria:** reflection + friction ·
> zero gamification · sources cited.
> **Companions:** `context.md` (P3/P4/P5/P8), `design.md` (tokens, wireframes),
> `architecture.md` (layering), `progress-tracker.md` (M7 built, M8 next).
> **Research basis:** `docs/An Evidence-Based Framework for Digital Wellbeing…`
> (Neuroscience, Breathwork, Orthodox Asceticism).

---

## 0. Problem & thesis

The research's central finding is that phone overuse is a behavioral addiction
sustained by variable-reward loops, and that effective intervention is **gradual,
nudge-based stimulus control** plus **reflection on the triggers** (boredom,
anxiety, escapism) — *not* the clinically-unvalidated "dopamine detox," and *not*
sudden total cessation (which provokes an acute withdrawal response).

مع يسوع is uniquely positioned to deliver this: **it is the home screen.** Detox
is therefore not an overlay that intercepts other apps (honest, P8) — it is
*being the home*. The calm path (Scripture, hymns, reflection) is one tap away;
everything else is simply not surfaced. We never block, never surveil (P3), never
gamify (P4). Friction is **intentional** (P5): a reflection pause before a detox
session, and the quiet of a curated surface always.

The core design tension — and how it is resolved:
- The research champions **multi-day gradual programs** and "celebrating progress."
- The philosophy (P4) **forbids** streaks/badges/counts.
- **Resolution (Approach A — Session-centric):** ship short timed sessions
  (15/30/60 min) + an always-on curated launcher home. The *gradual reduction*
  goal is delivered by the always-on curated home, not by a tracked program. The
  DB physically cannot answer "how many detoxes have I done" — by construction.

---

## 1. Architecture & the Flutter/Kotlin split

**One-sentence model:** Detox = being the home. مع يسوع is the launcher; it
surfaces a curated allowlist (the 4 Bible apps — Catena, Coptic Reader,
Orthodox Katamaras, YouVersion — plus internal tools) and never offers the rest.
Two entry modes: a **top-icon timed session** (15/30/60 min) and an **always-on
curated home** (Settings toggle). A guided reflection prompt opens each session;
answers are AES-256-GCM encrypted and privately stored.

### What's new (Flutter — the bulk of M8)
1. **`AppDock` + go_router `StatefulShellRoute`** — shared minimal One UI-style
   dock (Home / Hymns / Journal / Focus). State-preserving so the Hymns
   mini-player keeps playing across tab switches. Replaces the current flat
   per-screen scaffolds. This is the nav refactor folded into M8.
2. **`features/detox/`** feature module:
   - `DetoxSessionNotifier` (Riverpod `Notifier`) — reuses M7's timer pattern.
   - `DetoxReflectionRepository` — mirrors `JournalRepository`.
   - Reflection content (rotational prompts) in ARB.
3. **`features/detox/presentation/`** —
   - `DetoxSessionPage` (reflection gate + duration + active session).
   - `DetoxReflectionsPage` (private log of past reflections).
4. **Top-icon entry** in the shared app bar → `/detox/session`.
5. **Settings rows**: "Detox-curated launcher home" toggle; "Past reflections" link.

### What's reused (no new code)
- **M7 timer engine** — `FocusRetreatNotifier` pattern is the template for
  `DetoxSessionNotifier` (separate notifier, not a hack on the retreat one —
  distinct concerns).
- **`LauncherChannel`** — already exposes `isDefaultLauncher()` /
  `requestDefaultLauncher()`. **Zero new platform channels.**
- **`JournalCrypto`** — the AES-256-GCM envelope (ADR-003) reused as-is for
  reflections. No key-management duplication.
- **M2 Spiritual Home** — the curated allowlist lives on the existing home; the
  dock makes Hymns/Journal/Focus first-class tabs instead of home cards.
- **`SlowGestureDetector`** (M7) — for the calm 5s session-exit.
- **`app_intent_channel`** (M3) — to hand off to a chosen Bible app.

### Explicit non-goals (philosophy wins, documented)
| Rejected | Why |
|---|---|
| Accessibility overlay / app interception | Not needed — we *are* the launcher. Also avoids a sensitive permission + Play-review risk. |
| Multi-day programs (3-day / 1-week / 2-week) | Edges toward streak/tracking perception; fights P4. Gradual reduction delivered by the always-on curated home instead. |
| Streaks, badges, counts, "X reflections logged" | Forbidden by P4. The reflections log is a quiet dated list. |
| Any analytics on reflection content | P3 — privacy is sacred. |
| Reading `UsageStatsManager` / app-usage data | P3 — we never surveil other apps. Detox is about *our* surface. |

### Why the split is correct
- **Flutter-expert view:** `StatefulShellRoute` is the idiomatic go_router
  primitive for a persistent dock with preserved branch state; `Result<T>` flows
  from the (crypto+DB) repository to the UI's empty/error states; `autoDispose` +
  Drift `watch()` power the reflections list reactively.
- **Kotlin-specialist view:** no native surface = no new channel, no permission,
  no `Result.failure` mapping, no Play-review exposure. The M7 `LauncherChannel`
  Kotlin already satisfies the launcher need.

### Layering (context.md §8)
```
presentation (features/detox/presentation)
        │  Result<T>
domain    (features/detox/... OR domain/detox/)  — pure Dart
        │  ports
data      (data/detox/detox_reflection_repository.dart)
        │  Drift + JournalCrypto
```
Detox does not import any other feature's `data`/`domain`. It *consumes* the
shared `JournalCrypto` (core, not a feature) and the M7 `LauncherChannel`/M3
`app_intent_channel` via their public Dart wrappers.

---

## 2. Data model, crypto & migrations

### Domain model — `lib/domain/detox/detox_reflection.dart`
Pure-Dart value type (mirrors `JournalEntry`):

```dart
class DetoxReflection {
  final int? id;
  final String promptKey;   // ARB key of the prompt shown (e.g. 'detox.prompt.whyNow')
  final String? answer;     // user free-text; null when skipped ("just breathe")
  final DateTime createdAt;
}
```
- Pure Dart, zero Flutter/plugin imports (architecture rule).
- `promptKey` stores *which* prompt was shown, so the log re-renders the original
  question in the active locale without persisting localized strings (i18n-stable).
- **No `mode`/source field.** Reflections are only ever born from a *session*
  (the always-on mode never opens a reflection gate), so there is no meaningful
  discriminator to store. Adding one would imply a code path that doesn't exist.

### Drift table — `app_database.dart` (schema 4 → 5)
Ciphertext-only at rest (ADR-003), exactly like `JournalEntries`:

```dart
class DetoxReflections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get promptKey => text()();
  BlobColumn get answerNonce => blob().nullable()();        // null when skipped
  BlobColumn get answerCiphertext => blob().nullable()();
  BlobColumn get answerMac => blob().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```
Registered in `@DriftDatabase(tables: [...])`; `schemaVersion => 5`; migration:
```dart
if (from < 5) {
  await m.createTable(detoxReflections);
}
```

### Crypto — reuse, don't fork
`DetoxReflectionRepository` depends on the existing `JournalCrypto` (same master
key, same Keystore backing). The answer blob trio (nonce/ciphertext/mac) is
encrypted **only when non-empty**; a skipped reflection stores `null` blobs (so
"I just breathed" is a valid record — only promptKey + mode + timestamp persist).

- **Shared master key** because reflections and journal are equally private, and
  one Keystore key is simpler + harder to lose (ADR-003 weighs key-loss risk).
- **Tamper/decryption-fail handling** mirrors journal — a row that fails to
  decrypt is silently omitted (one corrupt entry never breaks the log).
- Repository methods return `Result<T>`; UI renders a calm empty/error state.

### Repository API (port-style, mirrors `JournalRepository`)
```dart
class DetoxReflectionRepository {
  DetoxReflectionRepository(this._db, this._crypto);

  Future<Result<List<DetoxReflection>>> getAll();   // newest-first; skips undecryptable
  Future<Result<DetoxReflection>> save({
    required String promptKey,
    String? answer,                                 // null → skipped ("just breathe")
  });
  Future<Result<void>> delete(int id);
}
```
Riverpod providers (`autoDispose` default) expose `getAll()` as a
`StreamProvider` over a Drift `watch()` so the list updates reactively.

### Reflection prompts (ARB content) — gain-framed, research-grounded
The research names the rumination-drivers: boredom, anxiety, escapism. Prompts
are calm and **gain-framed** ("Gain time for prayer," not "reduce screen time"):

| promptKey | Intent | Research basis |
|---|---|---|
| `detox.prompt.whyNow` | Surface the trigger | "compulsive use driven by escaping internal states" |
| `detox.prompt.whatInstead` | Stimulus-control replacement | "replace habit loop with a rewarding alternative" |
| `detox.prompt.oneThingForGod` | Faith-friendly positive frame | "create space for God / deeper communion" |
| `detox.prompt.justBreathe` | Closes the breath-rumination loop | breathwork vagal-tone evidence |

**Prompt selection: rotational, not random** — deterministic by date, consistent
with the project's seeded-by-date pattern (`BibleRandomizerService`, reading
journey). No "daily challenge" framing.

### Deliberately absent from the data model
- **No duration/streak/count columns.** Session length lives only in ephemeral
  `DetoxSessionNotifier` state, never persisted. The DB cannot answer "how many
  detoxes have I done." (P4, by construction.)
- **No app-usage data.** We never read `UsageStatsManager`. (P3.)

---

## 3. UX, screens & navigation

### Nav refactor — `AppDock` + `StatefulShellRoute`
```
StatefulShellRoute (preserves each branch's state + navigator)
 ├─ branch home    → /home           (M2 Spiritual Home)
 ├─ branch hymns   → /hymns          (M6 player; mini-player persists across tabs)
 ├─ branch journal → /journal        (M10)
 └─ branch focus   → /focus-retreat  (M7)

Detox is NOT a branch. Entered two ways:
  • top-icon (in AppDock's app bar) → /detox/session   (timed, ad-hoc)
  • Settings toggle → always-on curated launcher home  (no route; a behavior)
```
- **`StatefulShellRoute`:** idiomatic go_router primitive for a persistent dock;
  each branch keeps its own `NavigatorKey`, so Home↔Hymns switches don't rebuild
  Hymns (mini-player keeps playing).
- **`AppDock`** (`lib/shared/widgets/app_dock.dart`): minimal One UI-style
  floating pill, **not** a Material `NavigationBar`. Design tokens only; 4 items;
  ≥48dp targets; active state by shape/position + `primary` tint, never color
  alone (design §4).
- **Detox top icon:** a single calm icon in the shared app bar (e.g.
  `Icons.self_improvement` or a custom dove/leaf), present on all docked screens.
  Semantics-labeled (`detox.startA11y`).

### Screen 1 — Reflection Gate + duration (`/detox/session`, entry)
One calm screen, one thing at a time (design §6):
```
═══════════════════════════════════════════
                   خلوة

        ما الذي تبحث عنه الآن؟
          (today's rotational prompt)

        ┌─────────────────────────┐
        │  (optional free-text)    │
        └─────────────────────────┘

        المدة:  ١٥ · ٣٠ · ٦٠   (SegmentedChoice)

   [ فقط تنفّس ]      [ ابدأ الخلوة ]
═══════════════════════════════════════════
```
- Prompt rotational-by-date (§2). Free-text optional; "just breathe" (`فقط تنفّس`)
  skips capture (stores null blobs).
- Duration presets reuse design's `SegmentedChoice` + `FocusTimerDial` concept.
- On "ابدأ": save reflection (if any) → start `DetoxSessionNotifier` → Screen 2.

### Screen 2 — Active Detox Session (reuses M7 visuals)
```
═══════════════════════════════════════════
                   خلوة

              ●━━━━━━━━━━○
            ٢٣ : ٤٣   المتبقّي

             ( breathing orb )      ← design.md §7

   allowlist visible: [Catena][Coptic][Katamaras][YouVersion]
   internal tools:    journal · hymns

           [ إنهاء الخلوة بهدوء ]    ← SlowGestureDetector 5s
═══════════════════════════════════════════
```
- Reuses M7 `FocusRetreatNotifier`'s pattern as a template (a **separate**
  `DetoxSessionNotifier` — distinct concern, not a hack on the retreat notifier) +
  `SlowGestureDetector` for the calm exit. Breathing orb honors `disableAnimations`.
- **Key difference vs M7 retreat:** the allowlist (4 Bible apps) stays *visible
  and tappable*, because detox is about *replacing*, not removing. Internal
  Journal/Hymns reachable too. Honest (P8): tapping a Bible app hands off via the
  existing `app_intent_channel`; if the user then leaves that app to the system,
  we can't follow — and we don't claim to.
- **End:** natural completion → gentle notification (no count-up, no "well done 🔥");
  early exit → one calm confirm, never a guilt loop (design §11.6).

### Screen 3 — Past Reflections (private log, from Settings)
```
═══════════════════════════════════════════
   التأملات السابقة              (no count shown)

   «ما الذي تبحث عنه الآن؟»
   (your encrypted answer…)          ٢٠٢٦/٠٦/٢٦
   ───────────────────────────────────────
   «شيء واحد لله»
   (skipped — just breathed)          ٢٠٢٦/٠٦/٢٥
═══════════════════════════════════════════
```
- Reuses design's `EmptyState` (calm line-art + one sentence) when none.
- **No totals, no "X reflections", no streak.** Newest-first. Each entry
  deletable with one calm confirm. (P4 hard line.)
- Reached from Settings, not the dock — keeps detox unobtrusive.

### Settings additions (M8 adds two rows; M12 owns broader settings)
1. **"وضع الخلوة المستمر"** — toggle. On → explains it makes مع يسوع the
   detox-curated home; calls `LauncherChannel.requestDefaultLauncher()` if not
   already the launcher; P8-honest copy.
2. **"التأملات السابقة"** → `/detox/reflections`.

### Always-on mode — the launcher behavior
When the toggle is ON **and** مع يسوع is the default launcher (existing
`LauncherChannel.isDefaultLauncher()`), the home *is* the curated detox home (the
M2 Spiritual Home, unchanged). We don't hide anything extra or run a timer — the
detox *is* the curated home. If the user later sets a different launcher, the
toggle reads OFF (re-check `isDefaultLauncher()` on home resume) — no orphaned state.

### ARB keys (new — `feature.context.detail` convention)
```
detox.title                     detox.sessionRemaining
detox.prompt.whyNow             detox.prompt.whatInstead
detox.prompt.oneThingForGod     detox.prompt.justBreathe
detox.startSession              detox.justBreatheSkip
detox.duration.label            detox.duration.quarter
detox.duration.half             detox.duration.hour
detox.endCalm                   detox.endConfirm
detox.reflections.title         detox.reflections.empty
detox.reflections.skipped       detox.deleteReflection
detox.settings.alwaysOnTitle    detox.settings.alwaysOnBody
detox.settings.launcherNotSet   detox.settings.reflectionsLink
detox.startA11y                 detox.breathingOrbA11y
```
Both `ar` (default) and `en` complete. No hardcoded strings (context §9).

### Philosophy checkpoint (these screens)
- No red dots, count-ups, or "session #3 today" — anywhere. ✅
- Every interactive widget has semantics; 200% font scale won't clip. ✅
- RTL-first; directional APIs only. ✅

---

## 4. Tests, citations & exit-criteria mapping

### Tests (ship with the feature — testing-agent rule)
| Layer | Test | Coverage |
|---|---|---|
| **Domain** | `DetoxReflection` value-type; prompt-rotation determinism by date | 100% of domain logic |
| **Repository (data)** | encrypt → store → read-back round-trip; **skipped (null) reflection** stores/reads as skipped; tampered MAC → row silently omitted; delete | round-trip + tamper |
| **Provider** | `DetoxReflectionListProvider` reactive on Drift `watch()` via `ProviderContainer` overrides | state transitions |
| **Session** | `DetoxSessionNotifier` start/tick/end mirrors M7 timer tests; session length never persisted (assert no column written) | ephemeral-only |
| **Widget** | Reflection gate (capture + skip paths); session screen; reflections list empty + populated; settings rows | golden RTL + LTR + dark |
| **Goldens** | `DetoxSessionPage`, `DetoxReflectionsPage` | RTL + LTR + candlelight where relevant |
| **Launcher truth** | Always-on toggle ↔ `isDefaultLauncher()` read on home resume; toggle reads OFF when launcher unset | no orphaned state |

Fakes: a fake `JournalCrypto` (deterministic nonce) for repo tests; a fake
`LauncherChannel` for the toggle tests. (No real channels in unit/widget tests.)

### Philosophy guardrails (verify in review)
- [ ] **P4** — no streaks/badges/counts/count-ups/red dots anywhere in code or ARB.
- [ ] **P3** — reflections ciphertext-only in DB; no analytics; no usage-stats read.
- [ ] **P5** — friction is intentional (reflection pause; slow-touch exit), not accidental.
- [ ] **P8** — copy never claims to "block" apps; states limits plainly.
- [ ] **P9** — Arabic default; all keys present in `ar` + `en`; RTL goldens mirrored.
- [ ] Tokens-only UI; `flutter analyze` clean; `const` used.

### Citations (research-agent deliverable, stored in `docs/research/`)
A short `docs/research/detox-evidence.md` recording the key claims this feature
rests on, with the sources already in the research doc:
- "dopamine detox" lacks clinical validation; **gradual screen-time reduction** is
  the evidence-based model (multiple RCTs: mood, attention, sleep).
- Sudden complete cessation provokes an acute withdrawal-like sympathetic
  response → **justify gradual/nudge approach**.
- Compulsive use is driven by escaping internal states (boredom/anxiety) →
  **justify reflection prompts**.
- Nudge/stimulus-control bundle reduces problematic use without drastic change →
  **justify the curated launcher home**.
Each claim links + dates its source from the existing research doc.

### Exit-criteria mapping (progress-tracker.md M8)
| Tracker criterion | Satisfied by |
|---|---|
| Detox content model: reflection prompts, friction settings (cited) | §2 prompts; §1 friction; §4 citations |
| Drift: `detox_reflections` (encrypted like journal) | §2 Drift table + `JournalCrypto` reuse |
| Features: intentional friction, reflection prompts, **no streaks/badges** | §3 screens; §4 P4 guardrail |
| Documentation: citations to peer-reviewed sources in `docs/research/` | §4 citations deliverable |
| Tests: logic + encryption | §4 tests |

---

*End of spec. Next step: `writing-plans` → checkbox task plan → subagent execution.*
