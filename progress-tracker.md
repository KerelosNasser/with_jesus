# Progress Tracker — مع يسوع (With Jesus)

> **Status:** Living document — updated after **every** development session.
> Last updated: 2026-06-25.
> **Convention:**
> - `[ ]` not started · `[~]` in progress · `[x]` done · `[!]` blocked
> - Each milestone has **Exit criteria** that must all be `[x]` before moving on.
> - Append a dated note under **Session Log** at the end of every session.

---

## Milestone Map

| # | Milestone | Status | Target |
|---|-----------|--------|--------|
| M0 | Foundation & Blueprint | `[x]` | project skeleton + docs approved |
| M1 | Core Architecture | `[x]` | runnable app shell, theme, router, DB, DI |
| M2 | Home Screen (Spiritual Home) | `[x]` | verse, time, journey, shortcuts |
| M3 | Bible Integration | `[ ]` | detect + launch Catena/Coptic Reader/Katamaras |
| M4 | Reading Journey | `[ ]` | daily generated plan, no recent repeats |
| M5 | Continue Reading | `[ ]` | remember last reading across apps |
| M6 | Hymns Player | `[ ]` | offline scan + play + background + queue |
| M7 | Focus Retreat | `[ ]` | launcher + gentle redirect + timer |
| M8 | Phone Detox | `[ ]` | reflection, friction, science-cited |
| M9 | Stress Relief | `[ ]` | breathing, prayer timer, ambience |
| M10 | Spiritual Journal | `[ ]` | encrypted, local-only composer |
| M11 | Emergency Contacts | `[ ]` | allowlist callable during retreat |
| M12 | Settings & Onboarding | `[~]` | theme/locale/permissions/candlelight |
| M13 | Testing & Hardening | `[ ]` | coverage, goldens, perf, migration tests |
| M14 | Optimization | `[ ]` | startup, RAM, APK size, battery |
| M15 | Play Store Release | `[ ]` | signed AAB, listing, privacy policy |

---

## M0 — Foundation & Blueprint  `[~]`

**Goal:** Agree on the engineering foundation before any feature code.

- [x] Read existing scaffold (pubspec, main.dart, analysis_options, android build)
- [x] `docs/architecture.md`
- [x] `docs/design.md`
- [x] `docs/context.md`
- [x] `docs/progress-tracker.md`
- [x] `docs/agents.md`
- [x] **User approval** of all five documents
- [ ] Lock font pairing (Amiri/Noto Naskh Arabic + Cormorant/Inter) — decision recorded

**Exit criteria:** all docs `[x]`, user sign-off, font decision logged in `context.md`.

---

## M1 — Core Architecture  `[ ]`

**Goal:** A runnable, tested app shell that future features plug into.

- [ ] `pubspec.yaml`: add deps (riverpod + codegen, go_router, drift + codegen,
      shared_preferences, flutter_secure_storage, cryptography, just_audio,
      audio_service, path_provider, file_picker, permission_handler, intl,
      flutter_localizations, freezed, mocktail, patrol) — pinned versions
- [ ] `analysis_options.yaml`: strict rules (prefer_const, require_trailing_commas,
      avoid_print, public_member_api_docs on lib/)
- [~] `lib/core/`: theme tokens, `Result<T>`, `AppFailure`, extensions, platform_info
- [ ] `lib/app/bootstrap.dart`: init Drift, secure storage, prefs, audio handler
- [ ] `lib/app/app.dart`: `MaterialApp.router`, RTL default, theme provider
- [x] `lib/core/router/app_router.dart`: GoRouter with onboarding + retreat guards
- [ ] `lib/data/database/app_database.dart`: empty schema v1, `MigrationStrategy`
- [ ] `lib/native/` + Kotlin `PlatformChannelRegistry` skeleton (no real channels yet)
- [ ] Localization: ARB scaffolding (`ar` default, `en`), `AppLocalizations`
- [ ] CI: GitHub Actions — `analyze` + `test` + codegen-staleness check
- [ ] Tests: bootstrap + router guard unit tests

**Exit criteria:** `flutter analyze` clean · `flutter test` green · app launches to
a blank themed RTL screen · CI green.

---

## M2 — Home Screen (Spiritual Home)  `[x]`

**Goal:** The calm daily landing screen.

- [x] `VerseCard` (hero) from bundled daily-verse data (deterministic by date)
- [x] Current time + Hijri/Coptic date (optional) display
- [x] `ContinueReadingCard` (reads from M5 data; placeholder until then)
- [x] `ReadingJourneyCard` 4-slot (reads from M4; placeholder until then)
- [x] Shortcut tiles: Bible / Hymns / Katamaras / Focus (wired in their milestones)
- [x] Empty/loading/error states (calm)
- [x] Golden tests: RTL + LTR + dark
- [x] Accessibility pass: semantics, 200% font scale, TalkBack order

**Exit criteria:** Home renders fully in Arabic RTL with placeholders · goldens pass.

---

## M3 — Bible Integration  `[ ]`

**Goal:** Detect and launch trusted Orthodox apps; offer install if missing.

- [ ] Kotlin `AppIntentChannel`: `isInstalled(package)`, `launch(package, deepRef?)`,
      `openStore(package)`
- [ ] Dart `BibleAppsRepository` + `BibleAppsService` (domain)
- [ ] Supported apps registry: Catena Bible, Coptic Reader, Orthodox Katamaras
      (package ids + intent verification via `resolveActivity`)
- [ ] UI: shortcut tiles show installed/missing; tap launches; missing → calm
      "install" affordance (Play Store only)
- [ ] Unit tests for service logic; fake channel in widget tests
- [ ] Empty state when none installed

**Exit criteria:** tapping an installed app opens it; missing apps offer install ·
no crashes when none present.

---

## M4 — Reading Journey  `[ ]`

**Goal:** A daily, non-repeating reading plan generated locally.

- [ ] Seed data (assets): Prophet stories list, OT books/chapters, Psalms, NT
- [ ] `ReadingJourneyGenerator`: deterministic-by-date + recent-history avoidance
      (weighted exclusion of last N days' picks, seeded PRNG)
- [ ] Drift tables: `reading_journey_days`, history
- [ ] `ReadingJourneyRepository` (port + impl), `StreamProvider`
- [ ] UI: today's 4 slots; tap → launches the relevant app (M3) with reference
- [ ] Mark-as-read (private progress, no streak/gamification)
- [ ] Tests: generator determinism + no-repeat within window; repository tests

**Exit criteria:** same day → same plan; consecutive days don't repeat recent picks ·
opens correct app with reference.

---

## M5 — Continue Reading  `[ ]`

**Goal:** Remember where the user left off, across apps.

- [ ] Drift table: `continue_reading` (book, chapter, verse, app_used, updated_at)
- [ ] `ContinueReadingRepository`; updated on app launch (M3) + manual edit
- [ ] UI: Home card + dedicated page; "open in <app>" resume
- [ ] Tests: repository + provider

**Exit criteria:** opening a Bible app then returning shows the right resume card.

---

## M6 — Hymns Player  `[ ]`

**Goal:** Offline hymns: scan, play, queue, background.

- [ ] Kotlin `MediaStoreChannel`: scan configured folders → track list w/ metadata
- [ ] Dart FS fallback for SAF document trees
- [ ] Drift: `hymn_folders`, `hymn_tracks`, `playlists`, `playlist_items`, `favorites`
- [ ] `AudioEngine` interface → `just_audio` impl; `audio_service` `AudioHandler`
- [ ] Features: queue, shuffle, repeat, favorites, **sleep timer** (Dart deadline),
      playlists, background playback + media notification
- [ ] Permissions flow: `READ_MEDIA_AUDIO` (13+) / `READ_EXTERNAL_STORAGE` (≤12),
      notification, with calm explanations
- [ ] UI: list, mini-player, now-playing, queue sheet, folder picker
- [ ] Tests: repository with fake audio engine; widget tests; integration (patrol)
      for scan→play on an emulator with sample audio

**Exit criteria:** play a local track offline in background · sleep timer stops it ·
queue/shuffle/repeat work.

---

## M7 — Focus Retreat  `[ ]`

**Goal:** A gentle, honest distraction-reduction session.

- [ ] Kotlin `LauncherChannel` (home registration status) + `UsageStatsChannel`
      (opt-in, last-app-opened) + `OverlayChannel` (opt-in gentle redirect)
- [ ] Drift: `focus_sessions`; allowlist model
- [ ] Timer: presets 15/30/60/120 + custom; survives background; calm end
- [ ] Retreat shell: only allowlisted shortcuts (Bible/Phone/Messages/Prayer/
      Emergency/Clock/Music); exits with one calm confirm
- [ ] Opt-in launcher mode (retreat shell as home)
- [ ] Opt-in redirect overlay (clearly explained, off by default)
- [ ] Tests: timer logic, allowlist, redirect-decision logic (fakes)

**Exit criteria:** start 15-min retreat → only allowed apps reachable; ending asks
one calm confirm; overlay is opt-in and explained.

---

## M8 — Phone Detox  `[ ]`

**Goal:** Reflection-based, science-grounded, non-gamified.

- [ ] Detox content model: reflection prompts, friction settings (cited)
- [ ] Drift: `detox_reflections` (encrypted like journal)
- [ ] Features: intentional friction (e.g., a breath before opening a chosen app),
      reflection prompts, **no streaks/badges**
- [ ] Documentation: citations to peer-reviewed HCI/psychology (Lembke *Dopamine
      Nation*, Alter *Irresistible*, Eyal *Indistractable*; peer-reviewed sources
      added in `docs/detox-research.md`)
- [ ] Tests: logic + encryption

**Exit criteria:** detox offers reflection + friction · zero gamification elements ·
sources cited.

---

## M9 — Stress Relief  `[ ]`

**Goal:** Calm, offline tools for grounding.

- [ ] Breathing exercises (4-7-8, box) via `BreathingOrb`; honor disable-animations
- [ ] Prayer timer (silent countdown)
- [ ] Silence timer
- [ ] Nature / church ambience loops (bundled assets, `just_audio`)
- [ ] Optional haptics on breathing (opt-in)
- [ ] Tests: timer logic, breathing cycle math

**Exit criteria:** each tool runs offline · animations collapse when OS disables motion.

---

## M10 — Spiritual Journal  `[ ]`

**Goal:** Encrypted, local-only, distraction-free writing.

- [ ] `JournalCrypto` (ADR-003): AES-256-GCM envelope; Keystore master key
- [ ] Drift: `journal_entries` (title/body as iv+ciphertext); migrations safe
- [ ] `JournalComposer`: full-screen, calm, autosave (encrypted)
- [ ] List + search (search over decrypted titles in-memory; never index plaintext)
- [ ] Explicit plaintext export-to-file (user-initiated only)
- [ ] Tests: crypto round-trip, repository, migration integrity

**Exit criteria:** entries stored as ciphertext · key in Keystore · export works ·
loss-of-key path documented.

---

## M11 — Emergency Contacts  `[ ]`

**Goal:** Trusted contacts stay callable during a retreat.

- [ ] Contact picker (`contact_picker` or SAF-style) → Drift `emergency_contacts`
- [ ] Allowlist integration with M7 (Phone shortcut dialable during retreat)
- [ ] Tests: repository + allowlist decision

**Exit criteria:** chosen contacts reachable during retreat · others not surfaced.

---

## M12 — Settings & Onboarding  `[ ]`

**Goal:** First-run calm + full settings.

- [ ] Onboarding: philosophy intro, permissions explained (never demanded upfront),
      optional launcher mode
- [ ] Settings: theme (light/dark/candlelight), locale, font scale, digit shaping,
      audio folders, detox friction, emergency contacts, export/backup, about
- [ ] All strings localized; RTL/LTR goldens
- [ ] Tests: onboarding guard, settings persistence

**Exit criteria:** first run → onboarding → home; all settings persist · goldens pass.

---

## M13 — Testing & Hardening  `[ ]`

- [ ] Domain unit coverage 100%
- [ ] Goldens for every key screen (RTL + LTR + dark + candlelight)
- [ ] Integration (patrol): one happy path per feature
- [ ] Drift migration tests for every step
- [ ] Accessibility audit (TalkBack, contrast, 200% scale)
- [ ] Security review: journal crypto, permissions, no trackers, dependency audit

**Exit criteria:** coverage thresholds met · no a11y critical issues · security review signed off.

---

## M14 — Optimization  `[ ]`

- [ ] Cold start < 1.5s on mid-range device (profile, defer init)
- [ ] 60fps scroll (DevTools, fix jank)
- [ ] APK/AAB size minimized (R8, resource shrinking, font subsetting)
- [ ] Audio battery profile (background play drain acceptable)
- [ ] Memory: no leaks (DevTools); `autoDispose` discipline verified

**Exit criteria:** perf budgets met on a real mid-range device.

---

## M15 — Play Store Release  `[ ]`

- [ ] Signing keystore created (secured, not in repo)
- [ ] Signed AAB build
- [ ] Store listing (AR + EN): screenshots (RTL), description, privacy policy URL
- [ ] Privacy policy document (no analytics, journal local-only, permissions justified)
- [ ] Data safety form filled truthfully
- [ ] Final smoke test on a clean device

**Exit criteria:** AAB uploaded · listing complete · internal test closed → production.

---

## Session Log

> Append a short dated entry after every session: what changed, what's next,
> any decisions (link the ADR in `context.md`).

- **2026-06-25** — M0: Generated the engineering blueprint (`architecture.md`,
  `design.md`, `context.md`, `progress-tracker.md`, `agents.md`). Stack locked via
  ADRs 001–008. Awaiting user approval of docs before starting M1. Open decision:
  final font pairing (Amiri/Noto Naskh + Cormorant/Inter).

- **2026-06-26** � User approved blueprint (M0 complete). Advanced M1, M2, and M12: Created core shared widgets (AppButton, SurfaceCard, AppTextField, EmptyState) matching the "Quietude & Light" Material 3 design spec. Polished onboarding screens with RTL fixes, exact animations, and ambient blurs. Configured basic GoRouter and implemented the initial HomePage shell with feature cards.

---

*End of progress-tracker.md. Update the milestone statuses and Session Log every session.*



- **2026-06-26** � M1: Completed Core Architecture setup. Extracted app shell and bootstrap, configured localization with ARB files and flutter_localizations, added Drift AppDatabase skeleton, and set up Native Platform Channel Registry.


- **2026-06-26** � M2: Designed and implemented the M2 Home Screen UI following the stitch-ui visual spec. Assembled the VerseCard hero, ShortcutsRow, ContinueReadingBanner, and the Randomized JourneyGrid with its ReadingSuggestionDialog.

