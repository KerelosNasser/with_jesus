# Project Context — مع يسوع (With Jesus)

> **Status:** Living document — the permanent memory of the project. Updated after every
> development session. Last updated: 2026-06-25.
> **Purpose:** Any contributor (human or AI) should be able to read this single file and
> understand *what we are building, why, and how we make decisions*.
> **Companions:** `architecture.md` (how), `design.md` (look/feel), `progress-tracker.md`
> (where we are), `agents.md` (who does what).

---

## 1. Vision

**Make the phone quieter so the heart can be stiller.**

مع يسوع is a **Digital Spiritual Retreat (خلوة رقمية)** — an Orthodox Christian
application whose highest purpose is to *reduce* engagement, not increase it. It
exists to help the user spend less time scrolling and more time with God: in
silence, Scripture, prayer, hymns, and reflection.

Success is **not** measured by time-in-app. It is measured by the phone becoming
a door to peace rather than a source of noise.

---

## 2. Mission

Deliver a **minimal, peaceful, offline-first** application for Arabic-speaking
Orthodox Christians (with English as a secondary language) that:

1. Curates a daily spiritual rhythm — verse, readings, prayer.
2. Integrates with — rather than replaces — trusted Orthodox apps (Catena Bible,
   Coptic Reader, Orthodox Katamaras).
3. Plays the user's own hymns, offline, beautifully.
4. Offers a **Focus Retreat** that gently removes distraction.
5. Supports phone detox grounded in real behavioural science — no gamification.
6. Keeps a private, encrypted spiritual journal.
7. **Never** uses addictive design patterns. **Never** tracks the user.

---

## 3. Product Philosophy (the non-negotiables)

Every feature, line of code, and pixel must obey these. When in conflict, the
philosophy wins over the feature.

| # | Principle | Implication |
|---|-----------|-------------|
| P1 | **Retreat, not engagement** | Default to fewer features, fewer notifications, fewer screens. |
| P2 | **Offline-first, always** | No feature requires network for its core path. Airplane mode is a first-class state. |
| P3 | **Privacy is sacred** | No analytics, no trackers, no accounts in v1. The journal is encrypted and never leaves the device. |
| P4 | **No dark patterns / no gamification** | No streaks, badges, infinite scroll, red dots, count-ups, variable rewards. |
| P5 | **Intentional friction** | Make the *peaceful* choice the easy one; make the *distracted* choice require a deliberate step. |
| P6 | **Calm by default** | Motion is slow, colors are muted, type breathes, errors are gentle. |
| P7 | **Integrate, don't recreate** | We do not rewrite the Bible; we launch trusted Orthodox apps. |
| P8 | **Honest about capabilities** | We never claim to "block" apps in the OS sense; we redirect gently and explain limits. |
| P9 | **Readable, accessible, RTL-first** | Arabic is the default and the hardest case; design for it first. |
| P10 | **Long-term maintainable** | Open-source quality: readable before clever; document every non-trivial decision. |

---

## 4. User Personas

### Primary — "Mina" (الأصل: المستخدم العربي الأرثوذكسي)
- **Who:** Arabic-speaking Coptic/Orthodox Christian, 18–55, observant but busy.
- **Wants:** A phone that supports prayer instead of disrupting it; a daily
  reading rhythm; quick access to the hymns and apps he already loves.
- **Frustrations:** Apps full of notifications and addictive feeds; losing hours
  to scrolling; guilt about phone use.
- **Tech:** Mid-range Android device, limited data, often on airplane mode in
  church. RTL Arabic UI expected.
- **Success looks like:** Opens the app, prays, reads, listens — then puts the
  phone down. Feels peace, not pressure.

### Secondary — "John" (English-speaking Orthodox)
- **Who:** English-speaking Orthodox convert or member of an Antiochian/Greek/
  OCA parish.
- **Wants:** Same rhythm, in English; integration with the same Orthodox apps.
- **Tech:** Newer device; comfortable granting permissions if explained clearly.

### Edge — "Sister Maria" (monastic / retreatant)
- **Who:** Uses the phone in a highly intentional, almost-launcher-only way.
- **Wants:** Focus Retreat as the default home; minimal everything.
- **Implication:** Launcher mode + Focus Retreat must be first-class, not an
  afterthought.

---

## 5. Constraints

| Type | Constraint |
|------|-----------|
| Platform | Android 7.0 (API 24)+ first; iOS future, maximize shared Flutter code. |
| Network | Core features fully offline. Only network touch is user-initiated (e.g., open Play Store to install a Bible app). |
| Privacy | No analytics/trackers/crash reporting by default. Journal encrypted at rest. |
| Performance | Fast cold start (<1.5s mid-range), 60fps scroll, minimal RAM, battery-efficient audio. |
| Storage | Scoped-storage compliant; request narrowest permissions. |
| Policy | Must comply with Google Play policies (no real "app blocking"; honest overlay use). |
| Localization | RTL Arabic default; English complete. No hardcoded strings. |
| Accessibility | WCAG AA minimum (AAA where feasible); TalkBack-supported. |
| Licensing | Open-source friendly: only compatible licenses for fonts/audio/code. |

---

## 6. Technical Stack (locked)

| Layer | Choice | ADR |
|-------|--------|-----|
| Framework | Flutter (stable), Dart 3.x | — |
| Rendering | Impeller | — |
| Design system | Material 3 | — |
| State + DI | **Riverpod 2.x** (`flutter_riverpod` + `riverpod_annotation` codegen) | ADR-002 |
| Routing | GoRouter | — |
| Local DB | **Drift** (SQLite, reactive) | ADR-001 |
| KV prefs | `shared_preferences` | — |
| KV secrets | `flutter_secure_storage` (Android Keystore) | — |
| Journal crypto | `cryptography` — AES-256-GCM, key in Keystore | ADR-003 |
| Audio playback | **`just_audio`** (ExoPlayer/AVAudioPlayer) — local URIs, offline | ADR-004 |
| Audio background | **`audio_service`** (media session, notification, background) | ADR-004 |
| Media discovery | Kotlin channel → `MediaStore.Audio` + Dart FS fallback | ADR-005 |
| Filesystem/folders | `path_provider` + SAF document trees (`file_picker`) | — |
| Permissions | `permission_handler` | — |
| Intl | `intl` + `flutter_localizations` | — |
| Testing | `flutter_test`, `mocktail`, `patrol`; golden tests | — |
| Logging | `logging`, local-only, PII redacted | — |

---

## 7. Design Principles (summary — full detail in `design.md`)

Silence over stimulus · One thing at a time · Invitation not pressure · Readable
above all · Honest states · Accessible · Monastic not corporate.

Anti-patterns **forbidden**: infinite scroll, streaks, badges, red dots,
auto-carousels, count-ups, confetti, variable-reward animations.

---

## 8. Engineering Principles

1. **Layered & feature-modular.** `presentation → domain → data`. Domain has zero
   Flutter/plugin imports. Features don't import each other's data/domain.
2. **Riverpod is the container** for state and DI. No service locator.
3. **`Result<T>` across boundaries** — no exceptions crossing layers; UI renders
   explicit empty/error states.
4. **Reactive where it matters** — Drift `watch()` → Riverpod `StreamProvider`.
5. **Platform channels at the edges only**, typed, versioned, registered centrally.
6. **Every third-party package wrapped behind our own interface** (so swaps are local).
7. **Tests are part of the feature** — domain 100%, key screens golden-tested (RTL+LTR+dark).
8. **Offline is the default mode**, not a fallback state.
9. **Readable before clever** — no premature abstraction; prefer a second concrete
   implementation over a speculative generic.
10. **Document decisions** that change architecture (ADR log below).

---

## 9. Coding Standards

- **Dart style:** effective dart; `flutter analyze` **must be clean** (CI gate).
- **Null safety:** mandatory; never `!` without a justifying comment.
- **Naming:** `lowerCamelCase` for members/vars, `UpperCamelCase` for
  types/files-as-classes, `snake_case.dart` file names, `SCREAMING_SNAKE` for
  compile-time constants.
- **Immutability:** state/models immutable; `copyWith`; favor `final`.
- **Constructors:** `const` wherever possible.
- **Comments:** *why*, not *what*. Public API has doc comments.
- **Strings:** never hardcoded — all via `intl` ARB; keys are
  `feature.context.description` (e.g., `home.verseAttribution`).
- **Errors:** typed `AppFailure`; no swallowing; never expose stack traces in UI.
- **Logging:** local-only; redact URIs/titles; verbose logs off in release.
- **Files:** one widget/class per file for presentation; group small related
  models in a single domain file if cohesive.
- **Imports:** relative within a feature; `package:` for cross-module. No unused.
- **Dependencies:** every new package must justify itself and be wrapped behind
  an interface; review license compatibility before adding.

---

## 10. Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | `snake_case.dart` | `reading_journey_controller.dart` |
| Classes | `UpperCamelCase` | `ReadingJourneyController` |
| Riverpod providers | `<thing>Provider`, generated | `readingJourneyProvider` |
| Repositories | `<Entity>Repository` (interface) / `<Entity>RepositoryImpl` | `JournalRepository` |
| Drift tables | `<Entity>` Table class, snake_case table name | `JournalEntries` → `journal_entries` |
| Tables (DB) | snake_case, plural | `hymn_tracks` |
| State classes | `<Screen>State` | `HomeState` |
| Screens/Pages | `<Name>Page` | `FocusRetreatPage` |
| Widgets | `<Name>` (no suffix) or `<Name>Card`/`<Name>Tile` | `VerseCard` |
| Localization keys | `feature.context.detail` | `home.verseAttribution` |
| Assets | `feature/type/name.ext` | `hymns/icons/queue.svg` |

---

## 11. Glossary

| Term | Meaning |
|------|---------|
| **خلوة (Khalwa / Retreat)** | Spiritual solitude — the product's core metaphor. |
| **Retreat / Focus Retreat** | The session that gently removes distractions for a chosen duration. |
| **Reading Journey** | The daily curated set: Prophet story, OT, Psalm, NT. |
| **Verse of the Day** | A single highlighted Scripture on the Home screen. |
| **Continue Reading** | Resume the last reading (book/chapter/verse/app). |
| **Catena** | "Catena Bible" — an Orthodox study Bible app we integrate with. |
| **Coptic Reader** | Coptic Orthodox liturgical reader app we integrate with. |
| **Katamaras** | Orthodox daily readings ("Katamaras") app we integrate with. |
| **Hymns / تراتيل** | The user's local Coptic/Orthodox hymn library. |
| **Detox** | Phone-use reflection grounded in behavioural science; not gamified. |
| **Allowlist (Retreat)** | Apps permitted during a retreat (Bible, Phone, Messages, Prayer, Emergency, Clock, Music). |
| **Envelope encryption** | Per-entry AES-256-GCM key wrapped by a Keystore master key (journal). |
| **SAF** | Storage Access Framework — Android's user-driven folder selection. |
| **Scoped storage** | Android 11+ privacy model limiting broad file access. |
| **RTL** | Right-to-left text direction (Arabic), the default UI direction. |
| **Drift** | Reactive SQLite ORM for Dart — our local database. |
| **Riverpod** | Our state-management + dependency-injection container. |
| **Port** | A domain-layer abstract interface a feature exposes/consumes. |

---

## 12. Important Assumptions

1. The user already has (or is willing to install) Catena Bible / Coptic Reader /
   Orthodox Katamaras — we integrate, we don't ship a Bible.
2. Hymns are stored as standard audio files on the user's device in folders they
   will point us to (or that we detect via MediaStore).
3. The user is comfortable granting *scoped* audio/notification permissions when
   the reason is explained; we never ask upfront without context.
4. Android Play policy permits our Focus approach (launcher + opt-in gentle
   redirect overlay) — verified before release.
5. The user values calm over feature-density; we will ship *less* on purpose.
6. No backend/account is needed for v1. Sync is a future, optional layer.

---

## 13. Future Roadmap (high level — detailed in `progress-tracker.md`)

- **v1.0 (Play Store):** Foundation, Home, Bible integration, Reading Journey,
  Continue Reading, Hymns, Focus Retreat, Journal, Emergency contacts, Detox,
  Stress relief, Settings — fully offline, RTL, tested, signed release.
- **v1.x:** iOS parity, candlelight theme polish, more breathing presets,
  additional Orthodox app integrations.
- **v2.x (optional):** End-to-end-encrypted optional cloud sync (opt-in only),
  community-contributed reading schedules, widget/quick-tiles.

---

## 14. Decision Log (ADRs)

> Format: Context · Decision · Consequences. Append-only; never delete — supersede
> with a new ADR and a link.

### ADR-001 — Database: Drift over Isar
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** Need a local DB for small structured data (journal ciphertext,
  reading progress, favorites, playlists, focus sessions) with reactive UI updates.
- **Decision:** Use **Drift** (SQLite).
- **Rationale:** Our data volumes are tiny (thousands of rows), so Isar's raw
  microsecond advantage is imperceptible. Drift's **reactive streams** plug
  directly into Riverpod `StreamProvider`, its **migration tooling** is mature,
  and SQLite is ubiquitous and stable — all of which matter more for a multi-year
  open-source project than peak query speed.
- **Consequences:** + Great DX, easy migrations, reactive UI, easy to reason about.
  − Not the absolute fastest engine; relational modeling required (which we prefer).

### ADR-002 — State management: Riverpod (not Bloc/Provider/GetX)
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** Need compile-time-safe, testable state management + DI in one model.
- **Decision:** **Riverpod 2.x** with code generation as the single container.
- **Rationale:** No `BuildContext` dependency (pure-Dart testable), built-in
  disposal (memory), unifies state + DI. Bloc adds ceremony with no gain here.
- **Consequences:** + One mental model, great testability. − Team/agents must
  learn Riverpod idioms. Bloc reserved (only) if a future feature truly needs it.

### ADR-003 — Journal security: AES-256-GCM + Android Keystore
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** The journal must be private even if the device/backup is compromised.
- **Decision:** Per-entry **AES-256-GCM** (authenticated) envelope encryption;
  master key in **Android Keystore** (hardware-backed where available) via
  `flutter_secure_storage`; **ciphertext only** in the DB; **never** auto-exported.
- **Rationale:** Authenticated encryption prevents tampering; Keystore keeps the
  key out of app memory/prefs; per-entry keys allow safe future per-entry ops.
- **Consequences:** + Strong at-rest privacy. − No cloud sync without a careful
  E2EE design (deferred to v2.x); losing the key means losing entries — we will
  offer an explicit, user-initiated plaintext export-to-file.

### ADR-004 — Audio: just_audio + audio_service (local-first)
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** Hymns must play offline, in the background, with queue/shuffle/
  repeat/favorites/sleep timer, and a lock-screen media notification.
- **Decision:** **`just_audio`** for playback (ExoPlayer/AVAudioPlayer) +
  **`audio_service`** for the media session / notification / background.
- **Rationale:** Hardware decode (battery-efficient), gapless, real background
  playback, plays local `file://` and content URIs (offline). Most maintained pair.
- **Consequences:** + Best-in-class offline background audio. − Two packages to
  keep in sync; wrapped behind an `AudioEngine` interface to localize any future swap.

### ADR-005 — Media discovery: Kotlin MediaStore channel + Dart fallback
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** Need to find the user's hymns with metadata, fast, scoped-storage safe.
- **Decision:** A **Kotlin platform channel querying `MediaStore.Audio`** for
  configured folders (returns title/artist/album/duration/artwork/URI), with a
  pure-Dart `FileSystemEntity` fallback for SAF document trees.
- **Rationale:** Native speed and metadata; respects scoped storage; fallback
  keeps the feature working on edge cases.
- **Consequences:** + Fast, accurate, policy-safe. − A native surface to maintain;
  kept tiny and centralized per architecture §6.

### ADR-006 — Focus/launcher: honest model (launcher + gentle redirect, no real "blocking")
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** User wants distractions gone during retreat; Android forbids
  third-party apps from truly hiding/force-stopping other apps without OEM rights.
- **Decision:** Implement Focus via (1) optional **launcher** mode (retreat shell
  doesn't surface other apps) and (2) an **opt-in, clearly-explained gentle
  redirect overlay** when a blocked app opens — intentional friction, never a hard block.
- **Rationale:** Compliant with Play policy; honest with users; consistent with
  the detox philosophy (friction + reflection, not coercion).
- **Consequences:** + Shippable, ethical, on-philosophy. − Must manage
  expectations clearly in UX copy; cannot guarantee a user can't bypass.

### ADR-007 — Localisation: Arabic RTL default, English complete
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** Primary users are Arabic-speaking; RTL is the hardest design case.
- **Context:** Make Arabic the default; design/test RTL first; LTR mirror enforced in CI.
- **Consequences:** + Serves primary users best. − Extra care on directional
  widgets, bidi text, and mirrored golden tests.

### ADR-008 — No telemetry by default
- **Date:** 2026-06-25 · **Status:** Accepted
- **Context:** Privacy is a stated value; analytics/tracking conflict with it.
- **Decision:** Ship with **no analytics, no crash reporting, no trackers**.
  Any future telemetry must be **opt-in**, aggregated, and documented in an ADR.
- **Consequences:** + Trust, privacy, smaller binary. − We rely on user reports
  and our own testing for quality; invest heavily in golden/integration tests.

---

*End of context.md. This file is the source of truth for "why." Update it whenever
a decision, assumption, or principle changes — never silently.*
