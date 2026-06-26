---
name: Quietude & Light
colors:
  surface: '#fcf9f2'
  surface-dim: '#dcdad3'
  surface-bright: '#fcf9f2'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3ec'
  surface-container: '#f0eee7'
  surface-container-high: '#ebe8e1'
  surface-container-highest: '#e5e2db'
  on-surface: '#1c1c18'
  on-surface-variant: '#414941'
  inverse-surface: '#31312c'
  inverse-on-surface: '#f3f0ea'
  outline: '#727970'
  outline-variant: '#c1c9be'
  surface-tint: '#3a6843'
  primary: '#204e2b'
  on-primary: '#ffffff'
  primary-container: '#386641'
  on-primary-container: '#afe2b3'
  inverse-primary: '#a0d3a5'
  secondary: '#645e4b'
  on-secondary: '#ffffff'
  secondary-container: '#ece2c9'
  on-secondary-container: '#6b6450'
  tertiary: '#6c3600'
  on-tertiary: '#ffffff'
  tertiary-container: '#8f4a00'
  on-tertiary-container: '#ffcba6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#bcefc0'
  primary-fixed-dim: '#a0d3a5'
  on-primary-fixed: '#00210a'
  on-primary-fixed-variant: '#22502d'
  secondary-fixed: '#ece2c9'
  secondary-fixed-dim: '#cfc6ae'
  on-secondary-fixed: '#201b0c'
  on-secondary-fixed-variant: '#4c4634'
  tertiary-fixed: '#ffdcc4'
  tertiary-fixed-dim: '#ffb781'
  on-tertiary-fixed: '#2f1400'
  on-tertiary-fixed-variant: '#6f3800'
  background: '#fcf9f2'
  on-background: '#1c1c18'
  surface-variant: '#e5e2db'
typography:
  display-lg:
    fontFamily: Noto Sans Arabic
    fontSize: 57px
    fontWeight: '400'
    lineHeight: 64px
    letterSpacing: '0'
  headline-lg:
    fontFamily: Noto Sans Arabic
    fontSize: 32px
    fontWeight: '500'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Noto Sans Arabic
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 36px
  title-lg:
    fontFamily: Noto Sans Arabic
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  body-lg:
    fontFamily: Noto Sans Arabic
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 30px
  body-md:
    fontFamily: Noto Sans Arabic
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  label-lg:
    fontFamily: Noto Sans Arabic
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 24px
  gutter: 16px
  component-gap: 12px
  section-margin: 40px
---

## Brand & Style
The design system is rooted in the "Monastery Minimalist" aesthetic—a digital interpretation of the peaceful, focused atmosphere of Orthodox monastic life. The target audience seeks a refuge from digital noise; therefore, the UI must feel like a quiet room. 

The style adheres to **Material 3 (M3)** principles but strips away modern vibrancy in favor of organic, earthy tones. It prioritizes "negative space" as a functional element to reduce cognitive load and encourage prayerful focus. Visuals are intentionally unrefined but high-quality, avoiding all trends like glassmorphism or gradients in favor of flat, tactile surfaces and crisp, meaningful outlines.

## Colors
This design system utilizes a palette inspired by natural pigments and ancient manuscripts.

*   **Primary (Dark Olive - #386641):** Used for key actions, active states, and branding elements. It represents life and growth.
*   **Secondary (Soft Beige - #F2E8CF):** Used for tonal layering and subtle containment. It provides a soft contrast to the white background.
*   **Neutral (Warm White - #FCF9F2):** The foundation of the UI. It is warmer than standard digital white to reduce eye strain during long reading sessions.
*   **Surface Text (Charcoal - #2B2D42):** Used for all body text and primary icons to ensure maximum readability and accessibility.
*   **Accent (Muted Gold - #BC6C25):** Reserved strictly for moments of significance—sacred feasts, highlighted verses, or "Saved" states.

## Typography
The typography is the core of the spiritual experience. Noto Sans Arabic is chosen for its clarity, modern feel, and exceptional legibility at all scales.

1.  **RTL Optimization:** All alignments are right-to-left by default.
2.  **Generous Leading:** Body text uses an increased line-height (1.6x) to ensure the eye can rest between lines of scripture or reflection.
3.  **Hierarchy:** Headlines use a Medium weight (500) to stand out without being aggressive. 
4.  **Scaling:** Large headlines scale down on mobile to prevent awkward word breaks in the Arabic script.

## Layout & Spacing
The layout follows a fluid 8px grid system, emphasizing a "breathable" interface.

*   **Margins:** A generous 24px side margin on mobile creates a sense of "inset" focus.
*   **Grouping:** Related content (e.g., morning prayers) should be grouped into cards or logical blocks with 12px internal gaps.
*   **Safe Areas:** Ensure content does not touch the edges of the screen, reinforcing the "framed" monastic feel.
*   **Transitions:** Layout shifts should be slow and deliberate, avoiding rapid or jarring motion.

## Elevation & Depth
In line with Material 3, depth is conveyed through **Tonal Layers** and extremely subtle shadows.

*   **Surface Level 0 (Base):** Warm White (#FCF9F2).
*   **Surface Level 1 (Cards/Inputs):** Soft Beige (#F2E8CF) with a 2px blur, 5% opacity Charcoal shadow. This creates a "resting" effect rather than a "floating" effect.
*   **Interaction:** When a user interacts with a card, elevation does not increase; instead, a 1px Dark Olive outline appears to indicate focus.
*   **No Glass:** Avoid all background blurs. Transparency is only used for disabled states (40% opacity).

## Shapes
Shapes are "Rounded" (0.5rem / 8px) to feel organic and approachable without being overly "bubbly" or juvenile.

*   **Small Components:** Buttons and chips use the standard 8px radius.
*   **Large Components:** Main content containers and prayer cards use `rounded-lg` (16px) to soften the layout.
*   **Icons:** Use "Outlined" M3 icons with a 1.5px or 2px stroke weight. Sharp corners in icons should be avoided.

## Components

*   **Buttons:** Primary buttons are filled with Dark Olive (#386641) and use White text. Secondary buttons are outlined in Charcoal with no fill.
*   **Cards:** Material 3 "Elevated" style, but using Soft Beige (#F2E8CF) as the card background to differentiate from the Warm White app background.
*   **Lists:** "Grouped" style with 16px vertical padding between items. Use subtle dividers in Soft Beige (#F2E8CF) only when necessary.
*   **Input Fields:** Outlined style only. The label should be Noto Sans Arabic, Medium weight. Focus state uses a 2px Dark Olive border.
*   **Chips:** Used for filtering topics (e.g., "Psalms", "Gospels"). Unselected chips have a Soft Beige background; selected chips use Dark Olive with White text.
*   **Progress Indicators:** Use a thin, Muted Gold (#BC6C25) horizontal line for reading progress. Avoid circular loaders; use a fading "shimmer" on Beige surfaces for loading states.