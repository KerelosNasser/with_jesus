# Agents — Multi-Agent Workflow for مع يسوع (With Jesus)

> **Status:** Blueprint / pre-implementation. Last updated: 2026-06-25.
> **Purpose:** Define a roster of specialized AI agents and the protocol they use to
> collaborate on this project. Each agent is a *role*, not a person — a human contributor
> or an AI assistant adopts a role for a given task.
> **Source of truth:** `context.md` (philosophy/stack), `architecture.md` (how),
> `design.md` (look/feel), `progress-tracker.md` (where we are).

---

## 0. Why a multi-agent workflow

This is a long-term, open-source, philosophy-driven project. No single prompt does
justice to "Flutter architecture + native Android + UX + security + docs." By
splitting work into **specialized roles with strict scope and handoffs**, we get:

- **Depth** — each agent applies its discipline's best practices.
- **Accountability** — every agent owns specific quality checks.
- **Consistency** — all agents obey the same philosophy and docs.
- **Reviewable handoffs** — output of one agent is the input of another.

Every agent below shares one ultimate loyalty: **the product philosophy in
`context.md §3`.** If an agent's "best practice" conflicts with that philosophy
(e.g., adding analytics, a streak counter, or a dark pattern), the philosophy wins.

---

## 1. Universal Rules (apply to ALL agents)

1. **Read before you write.** Always load `context.md`, the relevant section of
   `architecture.md`/`design.md`, and the current milestone in `progress-tracker.md`
   before producing anything.
2. **No code without a milestone.** Implementation only happens inside an active
   milestone with approved docs.
3. **Incremental only.** Never dump a huge amount of code. One feature/layer at a time.
4. **Obey the layer rules.** `presentation → domain → data`. Domain stays pure.
   Features don't import each other's data/domain.
5. **No dark patterns, no telemetry, no gamification** — ever (see `context.md §3, §5`).
6. **Localization mandatory.** No hardcoded strings; ARB keys follow `context.md §10`.
7. **RTL-first.** Arabic default; mirror/test LTR.
8. **Tests ship with the feature.** No "I'll add tests later."
9. **Document decisions.** Architectural changes → new ADR in `context.md`; update
   `progress-tracker.md` Session Log every session.
10. **Honesty.** Report failures, unknowns, and capability limits plainly. Never
    claim a feature works when it wasn't verified.
11. **Use RTK.** Use RTK when running commands.

---

## 2. Agent Roster

Each agent definition has: **Role · Scope · Rules · Inputs · Outputs · Quality
checklist · When to invoke · Communication.**

---

### 2.1 Flutter Architect

- **Role:** Owns the global structure, layering, dependencies, and cross-cutting
  decisions. The "guardian of `architecture.md`."
- **Scope:** `lib/` folder structure, `core/`, `data/`, `app/`, feature contracts,
  ADRs, dependency choices, migration strategy.
- **Rules:** Feature-modular monolith; Riverpod as DI; domain purity; wrap every
  3rd-party package behind an interface; no speculative generics.
- **Inputs:** feature request, `architecture.md`, `context.md` ADRs.
- **Outputs:** design notes, interface/contract sketches, ADR proposals, folder
  layout for a new feature.
- **Quality checklist:**
  - [ ] Layer boundaries respected (no upward imports)
  - [ ] New dependency justified + license-compatible + wrapped behind interface
  - [ ] No cross-feature `data`/`domain` imports
  - [ ] ADR written for any architectural change
  - [ ] Scalability impact considered
- **When to invoke:** starting a milestone, adding a feature, choosing/changing a
  dependency, any structural refactor.
- **Communication:** hands contracts to **Flutter UI Engineer** & **Android Native
  Engineer**; proposes ADRs to **Code Reviewer**.

---

### 2.2 Flutter UI Engineer

- **Role:** Builds presentation-layer widgets, screens, Riverpod providers,
  animations — strictly from `design.md` tokens.
- **Scope:** `features/*/presentation/`, `shared/widgets/`, `core/theme/`,
  Riverpod providers/controllers.
- **Rules:** Use design tokens only (no magic colors/sizes); `Result<T>` → empty/
  error states; `autoDispose` default; semantics on every interactive widget;
  motion per `design.md §10`; no forbidden animations.
- **Inputs:** `design.md`, Architect's contracts, `AppLocalizations` keys.
- **Outputs:** widgets, pages, providers, golden tests (RTL+LTR+dark).
- **Quality checklist:**
  - [ ] Uses tokens only (colors/type/spacing/motion)
  - [ ] Empty + loading + error states implemented (calm)
  - [ ] RTL correct; `Start/End`/`Directional` APIs used (no hardcoded L/R)
  - [ ] Semantics labels present; 200% font scale doesn't break layout
  - [ ] Golden tests added & passing
  - [ ] No gamification/dark-pattern UI
- **When to invoke:** any screen/component/animation work.
- **Communication:** consumes Architect's contracts; requests design tokens from
  **UX Designer**; hands off to **Accessibility Reviewer** & **Testing Engineer**.

---

### 2.3 Android Native Engineer

- **Role:** Owns the Kotlin/Android side: platform channels, intents, MediaStore,
  launcher, usage-stats, overlay, permissions, build config.
- **Scope:** `android/app/src/main/kotlin/.../native/`, `lib/native/` Dart wrappers,
  `AndroidManifest.xml`, Gradle config, minSdk 24.
- **Rules:** One channel per capability, registered in `PlatformChannelRegistry`;
  typed (use `pigeon` past ~3 methods); no business logic in Kotlin; fail
  gracefully → `Result.failure`; Play-policy compliant; scoped-storage compliant.
- **Inputs:** Architect's channel list (`architecture.md §6`), feature needs.
- **Outputs:** Kotlin handlers, Dart wrappers, manifest entries, permission
  rationale strings, native unit/integration checks.
- **Quality checklist:**
  - [ ] Channel registered centrally; typed both sides
  - [ ] Errors returned as `Result.failure`, never crash
  - [ ] Permissions use narrowest scope; rationale provided
  - [ ] `resolveActivity` validation before launching intents
  - [ ] No Play-policy violations (esp. overlay/usage-stats are opt-in)
  - [ ] minSdk 24 maintained; no vendor-specific APIs
- **When to invoke:** any feature needing an Android capability Flutter can't reach.
- **Communication:** implements interfaces the Architect defined; coordinates with
  **Security Reviewer** on permissions/overlay; **Testing Engineer** fakes the channels.

---

### 2.4 Backend Engineer (future)

- **Role:** Reserved for v2.x optional cloud sync. Out of scope for v1.
- **Scope:** `data/remote/` (when it exists), E2EE sync design.
- **Rules:** Sync is **opt-in only**, end-to-end-encrypted, behind existing
  repository ports (presentation untouched). Requires a new ADR before any work.
- **When to invoke:** only when the project decides to add optional sync.
- **Communication:** coordinates with Architect + Security Reviewer; must not break
  offline-first guarantees.

---

### 2.5 UX Designer

- **Role:** Owns `design.md`, user flows, wireframes, copy tone, component specs,
  empty/error states.
- **Scope:** `docs/design.md`, wireframes, copy direction (with **Documentation
  Writer** for tone), component behavioral specs.
- **Rules:** Calm-first; one hero per screen; invitation not pressure; finite lists;
  monastery aesthetic; document every state; cite psychology where relevant.
- **Inputs:** feature requirements, personas (`context.md §4`), feedback.
- **Outputs:** updated `design.md` sections, ASCII/figma wireframes, state specs,
  copy guidance.
- **Quality checklist:**
  - [ ] Every screen has empty/loading/error states designed
  - [ ] No addictive/dark patterns
  - [ ] RTL wireframe provided alongside LTR
  - [ ] Motion described with duration/curve
  - [ ] Copy is calm, honest, localized-aware
- **When to invoke:** new screen/flow, copy decisions, state design, pre-implementation.
- **Communication:** feeds specs/tokens to **Flutter UI Engineer**; reviews goldens.

---

### 2.6 Accessibility Reviewer

- **Role:** Enforces WCAG AA (AAA where feasible), TalkBack support, contrast,
  dynamic type, motion-sensitive handling, RTL correctness.
- **Scope:** all presentation code + semantics + contrast + animations.
- **Rules:** ≥4.5:1 contrast (≥7:1 body target); 48dp targets; no color-only
  meaning; semantics on all interactive widgets; honor `disableAnimations`.
- **Inputs:** UI code, goldens, design tokens.
- **Outputs:** a11y findings report (critical/important/nice), remediation tasks.
- **Quality checklist:**
  - [ ] Contrast verified per token combination
  - [ ] All interactive widgets have semantic labels
  - [ ] Reading order logical under TalkBack
  - [ ] 200% font scale doesn't clip/break
  - [ ] Motion collapses when OS disables animations
  - [ ] RTL mirrored correctly (no hardcoded direction)
- **When to invoke:** before merging any screen; during M13 hardening.
- **Communication:** files tasks to **Flutter UI Engineer**; blocks release on criticals.

---

### 2.7 Performance Engineer

- **Role:** Enforces non-functional budgets: startup <1.5s, 60fps scroll, minimal
  RAM, small APK, battery-efficient audio.
- **Scope:** build config (R8, shrinking), startup path, rebuild analysis, isolate
  usage, memory leaks, audio drain.
- **Rules:** `const` everywhere; `autoDispose`; streams over polls; Isolate for
  heavy scans; defer non-critical init; profile on real mid-range devices.
- **Inputs:** DevTools traces, build artifacts, feature code.
- **Outputs:** perf report, budgets status, optimization PRs.
- **Quality checklist:**
  - [ ] Cold start under budget on mid-range device
  - [ ] Scroll 60fps (no janky frames in profile)
  - [ ] No provider/widget leaks (DevTools)
  - [ ] APK/AAB size minimized (R8, shrinking, font subsetting)
  - [ ] Background audio drain acceptable
  - [ ] Heavy work off main isolate
- **When to invoke:** M14, and any feature touching audio/scanning/large lists.
- **Communication:** files tasks to **Flutter UI Engineer**/**Android Native Engineer**.

---

### 2.8 Security Reviewer

- **Role:** Owns privacy & security posture: encryption, permissions, secret
  storage, dependency audit, no-telemetry guarantee, Play data-safety truthfulness.
- **Scope:** `data/secure/`, journal crypto, manifest permissions, dependency
  graph, logging redaction.
- **Rules:** AES-256-GCM + Keystore (ADR-003); ciphertext-only in DB; no
  plaintext logging; narrowest permissions; no trackers; verify on dependency bumps.
- **Inputs:** crypto code, manifest, `flutter pub deps`, feature designs.
- **Outputs:** security review report, threat-model updates, required fixes.
- **Quality checklist:**
  - [ ] Journal encryption correct (round-trip + tamper detection)
  - [ ] Master key in Keystore, never in prefs/logs
  - [ ] Permissions minimal & justified
  - [ ] No analytics/trackers in dependency graph
  - [ ] Logs redacted; verbose off in release
  - [ ] Overlay/usage-stats opt-in and explained
- **When to invoke:** journal (M10), permissions, dependency adds, pre-release.
- **Communication:** blocks release on criticals; coordinates with **Android Native
  Engineer** & **Documentation Writer** (privacy policy).

---

### 2.9 Testing Engineer

- **Role:** Owns test strategy, coverage, fakes/mocks, goldens, integration,
  migration tests, CI gates.
- **Scope:** `test/`, CI workflow, golden files, patrol integration specs, Drift
  migration tests.
- **Rules:** domain 100% unit coverage; goldens per key screen (RTL+LTR+dark);
  one integration happy path per feature; fakes for every channel; CI fails on
  stale codegen / analyze errors / missing ARB keys.
- **Inputs:** feature code, contracts, channel definitions.
- **Outputs:** test plans, test code, coverage reports, CI config.
- **Quality checklist:**
  - [ ] Domain layer fully unit-tested (pure Dart)
  - [ ] Riverpod providers tested via `ProviderContainer` overrides
  - [ ] Goldens present & passing (RTL+LTR+dark, candlelight where relevant)
  - [ ] Integration test per feature
  - [ ] Migration tests cover every `onUpgrade` step
  - [ ] CI green; codegen-staleness check passes
- **When to invoke:** every feature; M13.
- **Communication:** files failing tests as blockers to the implementing agent.

---

### 2.10 Documentation Writer

- **Role:** Keeps all `docs/` accurate, clear, and bilingual-aware; writes the
  privacy policy, README, contributor guide, in-app help.
- **Scope:** `docs/*`, `README.md`, privacy policy, in-app copy direction,
  ADR readability.
- **Rules:** docs are the source of truth; update after every decision; no
  marketing fluff; honest about limitations; AR/EN-aware.
- **Inputs:** ADRs, session logs, feature summaries.
- **Outputs:** updated docs, README, privacy policy, contributor guide.
- **Quality checklist:**
  - [ ] `progress-tracker.md` Session Log updated this session
  - [ ] New ADRs recorded in `context.md`
  - [ ] Privacy policy matches actual data practices
  - [ ] README has setup/run/test instructions
  - [ ] No undocumented public API/feature
- **When to invoke:** every session end; pre-release; after any ADR.
- **Communication:** pulls from all agents; publishes to **Release Manager**.

---

### 2.11 Research Agent

- **Role:** Gathers evidence — Orthodox liturgical references, Bible app package
  ids/intents, behavioural-science citations for detox, accessibility standards,
  Play policy details.
- **Scope:** `docs/research/`, citations in feature docs.
- **Rules:** cite primary/peer-reviewed sources where possible; verify app
  package ids and intent schemes empirically; flag uncertainty.
- **Inputs:** feature questions, detox claims, integration targets.
- **Outputs:** research notes, citation lists, verified package/intent tables.
- **Quality checklist:**
  - [ ] Claims backed by cited sources
  - [ ] Package ids/intents verified against current app versions
  - [ ] Uncertainty explicitly flagged
  - [ ] Sources linked & dated
- **When to invoke:** detox (M8), Bible integration (M3), any factual claim needing proof.
- **Communication:** feeds **UX Designer** (detox), **Android Native Engineer**
  (intents), **Documentation Writer** (citations).

---

### 2.12 Code Reviewer

- **Role:** Final quality gate before merge. Checks architecture, style, tests,
  philosophy adherence, docs updated.
- **Scope:** all code + docs in a PR/changeset.
- **Rules:** `flutter analyze` clean; layer rules respected; tests present;
  no dark patterns; docs updated; ADR if structural.
- **Inputs:** changeset, docs, ADRs.
- **Outputs:** review comments, approve/request-changes.
- **Quality checklist:**
  - [ ] Analyze clean; trailing commas; const used
  - [ ] Layer boundaries intact; no cross-feature data/domain imports
  - [ ] Tests added & relevant; goldens updated
  - [ ] Tokens-only UI; RTL correct
  - [ ] No telemetry/gamification/dark patterns
  - [ ] `progress-tracker.md` + `context.md` updated if needed
- **When to invoke:** before any merge; end of each milestone.
- **Communication:** can request changes from any agent; escalates to Architect
  for structural disputes.

---

### 2.13 Refactoring Agent

- **Role:** Improves existing code without changing behavior — readability, dedup,
  naming, extracting tokens, simplifying providers.
- **Scope:** any `lib/` code, strictly behavior-preserving.
- **Rules:** no behavior change; tests must stay green before & after; one
  refactor per PR; document the "why" in the commit.
- **Inputs:** code smells, review feedback, perf reports.
- **Outputs:** refactored code + green tests + commit rationale.
- **Quality checklist:**
  - [ ] Tests green before and after (no behavior change)
  - [ ] Analyze clean
  - [ ] Improvement explained in commit/PR
  - [ ] No scope creep (one concern per change)
- **When to invoke:** after feature delivery, during M14, or on review feedback.
- **Communication:** coordinates with Architect; reviewed by Code Reviewer.

---

### 2.14 Release Manager

- **Role:** Owns versioning, signing, build flavors, store listing, data-safety
  form, rollout.
- **Scope:** `pubspec.yaml` version, Gradle signing, AAB builds, Play Console
  listing, release checklist.
- **Rules:** signed builds only; keystore secured (never in repo); data-safety
  form truthful; release checklist (M15) fully green.
- **Inputs:** green CI, signed-off security/a11y reviews, finalized docs.
- **Outputs:** release artifacts, store listing, release notes.
- **Quality checklist:**
  - [ ] Version bumped; CHANGELOG/release notes written
  - [ ] Keystore secured & not committed
  - [ ] AAB signed & uploaded
  - [ ] Privacy policy + data-safety form accurate
  - [ ] Smoke test passed on clean device
  - [ ] All M15 items green
- **When to invoke:** M15 and any release.
- **Communication:** pulls sign-off from Security, A11y, Testing, Docs; owns rollout.

---

## 3. Communication Protocol

### 3.1 Handoff format
Every handoff between agents is a short structured note:

```
FROM:    <agent>
TO:      <agent>
RE:      <feature/milestone>
STATUS:  draft | ready | blocked
CONTEXT: <links to docs/ADRs>
ARTIFACTS: <files/contracts produced>
DECISIONS: <choices made + ADR links>
CHECKS:  <which quality checklist items passed>
NEXT:    <what the receiver should do>
OPEN:    <unresolved questions>
```

### 3.2 Decision escalation
- **Style/naming** → Code Reviewer decides.
- **Structural / dependency** → Architect proposes ADR → Code Reviewer approves.
- **Philosophy conflict** (e.g., "should we add a streak?") → **philosophy wins,
  no escalation needed** — refuse and document why.
- **Security/privacy** → Security Reviewer has veto.
- **Release-blocking** → Release Manager owns the final go/no-go from the sign-offs.

### 3.3 Per-session rhythm
1. **Documentation Writer** opens the session by reading `progress-tracker.md`
   and stating the active milestone + exit criteria.
2. The responsible **implementation agent** does the work, one layer at a time
   (feature → architecture → trade-offs → code → tests).
3. **Testing Engineer** runs the suite; **Accessibility/Security** review as needed.
4. **Code Reviewer** gates the merge.
5. **Documentation Writer** updates `progress-tracker.md` (Session Log) and, if
   needed, `context.md` (ADR) and `architecture.md`/`design.md`.

### 3.4 Shared artifacts (always-current)
- `context.md` — why (philosophy, ADRs)
- `architecture.md` — how (structure)
- `design.md` — look/feel (tokens)
- `progress-tracker.md` — where we are (milestones + session log)
- `docs/research/` — evidence & citations (created as needed)

---

## 4. Agent → Milestone matrix (who leads where)

| Milestone | Lead | Supporting |
|-----------|------|------------|
| M0 Foundation | Architect | Docs, all reviewers (doc approval) |
| M1 Core Architecture | Architect | UI, Native, Testing, Security |
| M2 Home | UI Engineer | UX, A11y, Testing |
| M3 Bible Integration | Native Engineer | Architect, Research, Testing |
| M4 Reading Journey | UI/Architect | Research, Testing |
| M5 Continue Reading | UI Engineer | Testing |
| M6 Hymns | Native + UI | Architect, Perf, Security, Testing |
| M7 Focus Retreat | Native + Architect | UX, Security, Testing |
| M8 Phone Detox | UX + Research | Architect, Security, Testing |
| M9 Stress Relief | UI Engineer | UX, A11y, Testing |
| M10 Journal | Architect + Security | UI, Testing |
| M11 Emergency Contacts | Native + UI | Testing |
| M12 Settings/Onboarding | UI + UX | A11y, Testing |
| M13 Testing & Hardening | Testing | A11y, Security, Perf |
| M14 Optimization | Performance | UI, Native, Refactoring |
| M15 Release | Release Manager | Docs, Security, Testing |

---

*End of agents.md. Roles are adopted per-task; the philosophy in `context.md` is
the one thing every agent obeys without exception.*
