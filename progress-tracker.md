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
| M3 | Bible Integration | `[x]` | detect + launch Catena/Coptic Reader/Katamaras |
| M4 | Reading Journey | `[x]` | daily generated plan, no recent repeats |
| M5 | Continue Reading | `[x]` | remember last reading across apps |
| M6 | Hymns Player | `[x]` | offline scan + play + background + queue |
| M7 | Focus Retreat | `[ ]` | launcher + gentle redirect + timer |
| M8 | Phone Detox | `[ ]` | reflection, friction, science-cited |
| M9 | Stress Relief | `[ ]` | breathing, prayer timer, ambience |
| M10 | Spiritual Journal | `[x]` | encrypted, local-only composer |
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

- [x] Kotlin `AppIntentChannel`: `isInstalled(package)`, `launch(package, deepRef?)`,
      `openStore(package)`
- [x] Dart `BibleAppsRepository` + `BibleAppsService` (domain)
- [x] Supported apps registry: Catena Bible, Coptic Reader, Orthodox Katamaras
      (package ids + intent verification via `resolveActivity`)
- [ ] UI: shortcut tiles show installed/missing; tap launches; missing → calm
      "install" affordance (Play Store only)
- [ ] Unit tests for service logic; fake channel in widget tests
- [x] Empty state when none installed

**Exit criteria:** tapping an installed app opens it; missing apps offer install ·
no crashes when none present.

---

## M4 — Reading Journey  `[ ]`

**Goal:** A daily, non-repeating reading plan generated locally.

- [x] Seed data (assets): Prophet stories list, OT books/chapters, Psalms, NT
- [x] `ReadingJourneyGenerator`: deterministic-by-date + recent-history avoidance
      (weighted exclusion of last N days' picks, seeded PRNG)
- [x] Drift tables: `reading_journey_days`, history
- [x] `ReadingJourneyRepository` (port + impl), `StreamProvider`
- [x] UI: today's 4 slots; tap → launches the relevant app (M3) with reference
- [x] Mark-as-read (private progress, no streak/gamification)
- [ ] Tests: generator determinism + no-repeat within window; repository tests

**Exit criteria:** same day → same plan; consecutive days don't repeat recent picks ·
opens correct app with reference.

---

## M5 — Continue Reading  `[x]`

**Goal:** Remember where the user left off, across apps.

- [x] Drift table: `continue_reading` (book, chapter, verse, app_used, updated_at)
- [x] `ContinueReadingRepository`; updated on app launch (M3) + manual edit
- [x] UI: Home card + dedicated page; "open in <app>" resume
- [x] Tests: repository + provider

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

## M7 — Focus Retreat  `[x]`

**Goal:** A gentle, honest distraction-reduction session.

- [x] Kotlin `LauncherChannel` (home registration status)
- [x] Timer: presets 15/30/60; calm end
- [x] Retreat shell: strictly restricted to Journal / Hymns
- [x] Slow touch interaction (2.5s high friction delay on taps)
- [x] Opt-in launcher mode (retreat shell as home)

**Exit criteria:** start retreat → only allowed apps reachable; ending asks
one calm confirm; slow touch delay enforces intentionality.

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

## M10 — Spiritual Journal  `[x]`

**Goal:** Encrypted, local-only, distraction-free writing.

- [x] `JournalCrypto` (ADR-003): AES-256-GCM envelope; Keystore master key
- [x] Drift: `journal_entries` (title/body as iv+ciphertext); migrations safe
- [x] `JournalComposer`: full-screen, calm, autosave (encrypted)
- [x] List + search (search over decrypted titles in-memory; never index plaintext)
- [x] Explicit plaintext export-to-file (user-initiated only)
- [x] Tests: crypto round-trip, repository, migration integrity

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



- **2026-06-26** � M3: Implemented Bible Integration. Created Kotlin AppIntentChannel (isInstalled/launch/openStore), wired it into PlatformChannelRegistry, built Dart domain layer (BibleApp model, BibleRandomizerService with full Arabic book/chapter mappings), BibleAppsRepository, and updated the JourneyGrid dialog to detect/launch/install real Bible apps.



- **2026-06-26** � M4: Added ReadingHistory Drift table (schema v2), ReadingJourneyRepository, exclusion param to BibleRandomizerService, and wired history tracking into the JourneyGrid dialog � accepted chapters won't reappear.


- **2026-06-26** � M5: Integrated Continue Reading functionality. Added ContinueReading table (schema v3), created ContinueReadingRepository, connected JourneyDock to actually randomize real readings and store progress on acceptance, and reactively wired ContinueReadingBanner using Riverpod to allow direct resumption.
-   * * 2 0 2 6 - 0 6 - 2 6 * *   -   M 6 :   I m p l e m e n t e d   H y m n s   P l a y e r .   C r e a t e d   K o t l i n   M e d i a S t o r e C h a n n e l   t o   s c a n   a n d   f i l t e r   C o p t i c   a u d i o   k e y w o r d s   n a t i v e l y ,   i m p l e m e n t e d   H y m n s A u d i o H a n d l e r   w i t h   j u s t _ a u d i o   a n d   a u d i o _ s e r v i c e   f o r   s e a m l e s s   b a c k g r o u n d   p l a y b a c k   a n d   n o t i f i c a t i o n s ,   w i r e d   R i v e r p o d   a u d i o   s t a t e   s t r e a m s ,   a n d   b u i l t   t h e   H y m n s   U I   w i t h   a   l i s t   a n d   p e r s i s t e n t   m i n i - p l a y e r .  
 \ 
 -   * * 2 0 2 6 - 0 6 - 2 6 * *   -   M 7 :   I m p l e m e n t e d   F o c u s   R e t r e a t   ( L a u n c h e r   M o d e ) .   A d d e d   K o t l i n   L a u n c h e r C h a n n e l   t o   r e g i s t e r   t h e   a p p   a s   d e f a u l t   h o m e   s c r e e n ,   b u i l t   t h e   S l o w G e s t u r e D e t e c t o r   f o r   2 . 5 s   h i g h - f r i c t i o n   i n t e n t i o n a l   t a p s ,   s e t   u p   R i v e r p o d   t i m e r   s t a t e ,   a n d   c r e a t e d   t h e   m i n i m a l i s t   F o c u s R e t r e a t P a g e   s t r i c t l y   l i m i t i n g   a c c e s s   t o   H y m n s   a n d   J o u r n a l .  
 -  
 * * 2 0 2 6 - 0 6 - 2 6 * *  
 -  
 M 1 0 :  
 I m p l e m e n t e d  
 S p i r i t u a l  
 J o u r n a l  
 m a t c h i n g  
 S t i t c h  
 U I  
 e x a c t l y .  
 C r e a t e d  
 J o u r n a l C r y p t o  
 w i t h  
 A E S - 2 5 6 - G C M  
 a n d  
 K e y s t o r e  
 v i a  
 f l u t t e r _ s e c u r e _ s t o r a g e .  
 A d d e d  
 j o u r n a l _ e n t r i e s  
 t a b l e  
 i n  
 D r i f t  
 w i t h  
 e n c r y p t e d  
 f i e l d s .  
 B u i l t  
 J o u r n a l R e p o s i t o r y  
 a n d  
 R i v e r p o d  
 p r o v i d e r s .  
 C r e a t e d  
 J o u r n a l L i s t P a g e  
 w i t h  
 b e n t o - g r i d  
 a n d  
 c h i p s  
 a n d  
 J o u r n a l C o m p o s e r P a g e  
 w i t h  
 a  
 b e a u t i f u l  
 f u l l - s c r e e n  
 d i s t r a c t i o n - f r e e  
 e d i t o r  
 a n d  
 a u t o s a v e .  
 