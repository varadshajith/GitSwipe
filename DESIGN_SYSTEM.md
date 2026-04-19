# GitSwipe Design System Specification

## Design Philosophy

The GitSwipe user interface is built on a "Premium Minimalist" foundation, drawing inspiration from high-end fintech applications and modern desktop operating systems. The objective is to provide a high-signal discovery experience that feels sophisticated, authoritative, and frictionless. The system avoids vibrant or high-contrast color palettes in favor of a muted, glassmorphic aesthetic.

---

## Color Systems

The palette is derived from HSL values to ensure visual consistency and ease of programmatic manipulation across themes.

| Token | HSL Value | Application |
| :--- | :--- | :--- |
| **Surface-Background** | `220, 15%, 5%` | Primary background color for high-depth focus. |
| **Surface-Glass** | `220, 10%, 15%, 0.5` | Background color for elevated interface components. |
| **Interactive-Primary** | `210, 100%, 65%` | Primary action color (Interactive elements). |
| **Foreground-Primary** | `0, 0%, 95%` | High-contrast text and primary iconography. |
| **Foreground-Secondary**| `220, 10%, 65%` | Supportive text, metadata, and muted labels. |
| **Boundary-Muted** | `220, 10%, 25%, 0.3` | Low-impact decorative lines and separators. |

---

## Interface Effects (Glassmorphism)

To maintain a professional aesthetic, glassmorphic effects must adhere to strict visual constraints:

1.  **Backdrop Attenuation**: Use a Gaussian blur filter on underlying content.
    - Standard Deviation (Sigma): `15.0`.
2.  **Border Integrity**: Components should feature a 1px solid border with a linear gradient.
    - Gradient Direction: `Top-Left to Bottom-Right`.
    - Opacity Variance: `20% to 0%`.
3.  **Reflection Layer**: A 5% opacity white overlay on the upper 15% of the component to simulate a surface reflection.

---

## Typography and Font Selection

**Primary Typeface**: `Inter` (Variable Font).

-   **Level 1 Headline**: `32px / 1.2 Line Height / SemiBold`. Letter-spacing: `-0.02em`.
-   **Level 2 Headline**: `20px / 1.4 Line Height / Medium`.
-   **Body Standard**: `15px / 1.6 Line Height / Regular`.
-   **Mono-space Metadata**: `12px / 1.0 Line Height / Medium` (Used exclusively for code segments and technical tags).

---

## Component Architecture

### Repository Feed Card
- **Geometry**: `24px` border radius.
- **Elevation**: Multi-layered shadow system using `BoxShadow`.
    - Primary Blur: `40px`.
    - Offset: `(0, 20)`.
- **Navigation Controls**: Context-sensitive floating action buttons with integrated haptic feedback.

### Interaction Logic
- **Feedback**: Every primary interaction should trigger `HapticFeedback.lightImpact` at the hardware level.
- **Dynamics**: Button interactions utilize a `0.95` scale reduction on `PointerDown`.

### Layout Navigation
- **Docking**: A persistent, semi-transparent navigation bar anchored at the bottom of the viewport.
- **Active State**: Indicated by a high-clarity typeface weight change and a muted accent bar.

---

## Motion and Animation

Animations are designed to be subtle and non-intrusive, prioritizing speed and system responsiveness.

-   **Component Entrance**: Staggered vertical translation with an elastic spring curve.
    - Damping Ratio: `0.8`.
-   **State Transitions**: Cross-fades and translations should utilize a `0.3s` cubic-bezier easing (`0.2, 0.0, 0.0, 1.0`).
-   **Interaction Response**: All immediate UI responses must complete within `100ms` to maintain the perception of system fluidity.
