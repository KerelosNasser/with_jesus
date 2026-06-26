# Focus Retreat (M7) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a custom Android Launcher mode with a high-friction "slow touch" UI to enforce a distraction-free spiritual retreat.

**Architecture:** Kotlin platform channels for Android Launcher integration, a `SlowGestureDetector` for 2.5s interaction delays, and a dedicated `FocusRetreatPage` that hides normal navigation and only exposes Hymns/Journal.

**Tech Stack:** Flutter, Android (Kotlin), Riverpod for timer state.

---

### Task 1: Android Launcher Channel Setup

**Files:**
- Modify: `android/app/src/main/AndroidManifest.xml`
- Create: `android/app/src/main/kotlin/com/example/with_jesus/native/LauncherChannel.kt`
- Modify: `android/app/src/main/kotlin/com/example/with_jesus/native/PlatformChannelRegistry.kt`
- Create: `lib/native/channels/launcher_channel.dart`

- [ ] **Step 1: Update AndroidManifest.xml**
Add an `activity-alias` targeting `.MainActivity` with `CATEGORY_HOME` and `CATEGORY_DEFAULT`.

- [ ] **Step 2: Create LauncherChannel.kt**
Implement method `isDefaultLauncher` (using `RoleManager` or `PackageManager`) and `requestDefaultLauncher` (firing Intent to settings).

- [ ] **Step 3: Register in PlatformChannelRegistry**
Hook up the new `LauncherChannel`.

- [ ] **Step 4: Create Dart wrapper**
Implement `LauncherChannel` in `lib/native/channels/launcher_channel.dart`.

- [ ] **Step 5: Commit**
`git add android lib/native && git commit -m "feat(m7): setup android launcher channel"`

### Task 2: SlowGestureDetector Widget

**Files:**
- Create: `lib/features/focus_retreat/presentation/widgets/slow_gesture_detector.dart`

- [ ] **Step 1: Write SlowGestureDetector**
Create a `StatefulWidget` using `GestureDetector` (onTapDown, onTapUp, onTapCancel) and an `AnimationController` (duration configurable, default 2.5s). 
Draw a circular progress indicator or fading overlay around the child. If the user holds for the full duration, trigger the `onSlowTap` callback. If released early, reverse the animation and cancel.

- [ ] **Step 2: Commit**
`git add lib/features/focus_retreat && git commit -m "feat(m7): create slow touch gesture detector"`

### Task 3: Focus Retreat State & Timer

**Files:**
- Create: `lib/features/focus_retreat/presentation/providers/focus_retreat_provider.dart`

- [ ] **Step 1: Create Timer State**
Implement a Riverpod `Notifier` or `StateNotifier` that manages:
- Retreat status (inactive, active, completed)
- Remaining time (Duration)
- Timer ticking logic (Timer.periodic)

- [ ] **Step 2: Commit**
`git add lib/features/focus_retreat/presentation/providers && git commit -m "feat(m7): implement retreat timer state"`

### Task 4: Focus Retreat Shell UI

**Files:**
- Create: `lib/features/focus_retreat/presentation/focus_retreat_page.dart`
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Build FocusRetreatPage**
Create a highly minimalist UI. 
- Show the countdown timer.
- Use `SlowGestureDetector` on two main buttons: "الألحان" (Hymns) and "المذكرات" (Journal).
- Add a highly subtle "إنهاء" (End Retreat) button that requires a 5-second `SlowGestureDetector`.

- [ ] **Step 2: Update AppRouter**
Add `/focus-retreat` route. Ensure the retreat page does *not* display the standard bottom navigation bar (it should be a fullscreen route or a separate shell).

- [ ] **Step 3: Commit**
`git add lib && git commit -m "feat(m7): build focus retreat shell UI"`

### Task 5: Integration & Home Screen Entry

**Files:**
- Modify: `lib/features/home/home_page.dart`

- [ ] **Step 1: Add Entry Point**
In `home_page.dart`, add a card for "خلوة التركيز" (Focus Retreat). Tapping it pushes to a setup screen or directly to `/focus-retreat`.

- [ ] **Step 2: Commit**
`git add lib/features/home && git commit -m "feat(m7): integrate focus retreat into home screen"`