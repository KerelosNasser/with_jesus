# Focus Retreat (M7) Design Specification

## Overview
A custom Android Launcher mode (`CATEGORY_HOME`) that acts as a spiritual shell to protect focus. During the retreat, the app restricts access to the rest of the phone, providing only minimal, intentional tools (Journal and Hymns).

## Architecture
1. **Android Launcher Integration:**
   - Add `android.intent.category.HOME` and `DEFAULT` to an `activity-alias` in `AndroidManifest.xml`.
   - `LauncherChannel` (Kotlin/Dart) to check default launcher status and prompt the OS settings to toggle it.
2. **Retreat Shell UI (Flutter):**
   - A minimalist, distraction-free screen (`FocusRetreatPage`).
   - Only provides access to the "Journal / Notes" and "Hymns Player" screens.
   - Hides standard app navigation.
3. **Slow Touch Mechanism:**
   - A custom `SlowGestureDetector` widget enforcing a 2.5-second hold for non-typing actions.
   - Prevents mindless tapping. A visual progress ring/fade indicates the hold duration.
4. **Timer & Early Exit:**
   - Configuration screen to set the retreat duration (e.g., 15, 30, 60 minutes).
   - "End Retreat" button requires a 5-second long press + calm confirmation.
   - Gentle notification upon natural completion.