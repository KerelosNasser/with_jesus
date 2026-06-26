# M2 - Home Screen (Spiritual Home) Design Spec

## Overview
The Spiritual Home (M2) is the calm, daily landing screen for the "With Jesus" app. It provides an immersive daily verse, quick access to app features, a resume-reading banner, and a dynamic randomized reading journey that integrates directly with external Bible apps.

## Architecture & Layout Hierarchy

### 1. Top Section: Hero & Shortcuts
* **AppBar**: A clean, zero-elevation `SliverAppBar` with the "مع يسوع" title centered, an options/menu icon on the leading edge, and a user profile icon on the trailing edge.
* **VerseCard (Hero)**: A visually immersive, full-width (or near full-width with safe margins) card designed to replicate the aesthetic of the YouVersion daily verse component.
  * **Features**: Beautiful Arabic typography, calm background aesthetic (color/gradient or subtle image), and clear attribution.
  * **Data**: Deterministic daily verse data (eventually fetched/bundled).
* **Shortcuts Row**: A horizontally scrolling `ListView` placed immediately below the VerseCard.
  * **Items**: Small, elegant pill-shaped buttons or circular icon buttons for: Hymns (الألحان), Focus Retreat (خلوة التركيز), Katamaras (القطمارس), and Journal (المذكرات).

### 2. Middle Section: Continue Reading
* **ContinueReadingCard**: A sleek, slim horizontal banner.
  * **Layout**: Book and Chapter title on one side (e.g., "Gospel of Mark, Chapter 3"), and a "Resume" action button on the other.
  * **Action**: Tapping it launches the preferred external Bible app to the exact saved location. (For M2, this relies on a placeholder function until M5 is fully built).

### 3. Bottom Section: The Randomized Journey (2x2 Grid)
* **The Grid**: A 2x2 `SliverGrid` serving as the "What to read?" feature.
* **Cards**: Four prominent square/rectangular surface cards:
  1. Old Testament (العهد القديم)
  2. New Testament (العهد الجديد)
  3. Psalms of David (مزامير داود)
  4. Prophets (الأنبياء)
* **Interaction Flow**:
  * **Tap**: Tapping a card opens a modal dialog (`ReadingSuggestionDialog`).
  * **Dialog Content**: Presents a randomly selected chapter from the chosen category (e.g., "Read Romans 8?").
  * **Accept Action**: Tapping "Accept" (موافق) closes the dialog and delegates to the M3 Bible integration layer to launch the external Bible app to that specific chapter.
  * **Reroll Action**: Tapping "Reroll" (تغيير) instantly updates the dialog with a new randomized chapter from the same category.

## State Management & Data Flow
* **Randomizer Logic**: A local service or utility function that maps the 4 categories to their respective biblical books and generates a random chapter number based on the maximum chapters of the randomly selected book.
* **Placeholder States**: For M2, the external app launching will simply print to the console or show a `SnackBar` stating "Launching [App] to [Reference]", until the actual M3 Android Intents are wired up.

## Accessibility & Localization
* **RTL-First**: The entire layout is designed for Arabic RTL. LTR is supported and mirrored correctly using `Directionality` and `Start/End` padding over `Left/Right`.
* **Semantics**: Every interactive element (Cards, Dialog buttons, Shortcuts) must have clear `Semantics` labels.
* **Scaling**: Layouts must use flexible sizing (`Expanded`, `Wrap`, or unconstrained heights) to accommodate 200% font scaling without overflowing.

## Testing Strategy
* **Widget Tests**: Verify the `ReadingSuggestionDialog` opens on grid tap and updates its text when "Reroll" is pressed.
* **Golden Tests**: Render the `HomePage` in RTL, LTR, and Dark Mode to verify the YouVersion-style VerseCard and layout integrity.