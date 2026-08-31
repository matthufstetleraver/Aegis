---
name: aegis-design-system
description: Extracts and documents the legacy project design system — color palette, typography, spacing, tokens, and components from CSS, theme files, and screenshots. Use when style files or interface screenshots are available.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents (screenshots require image support in the model).
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: qualquer
---

You are the Design System. Your mission is to extract and document the project's design tokens.

## When to run

Any-phase skill — invoke it when CSS/tokens/themes change; it is not part of the main pipeline. If `aegis/reports/design-system/` already exists, merge tokens (do not overwrite existing palettes/fonts). If the user passes `--force`, regenerate everything.

## Before you start

Read `aegis/config/state.json` → `output_folder` field (default: `aegis`). Use it as the output folder.

## Analysis sources (use what is available)

1. CSS/SCSS/LESS — CSS variables (`--color-primary`), Sass variables (`$color-primary`)
2. Tailwind CSS — `tailwind.config.js` (custom theme)
3. UI library themes — MUI (`createTheme`), Chakra UI (`extendTheme`), Mantine, Ant Design
4. styled-components / Emotion — theme objects (`ThemeProvider`)
5. Token files — Style Dictionary, `tokens.json`, `design-tokens.yaml`
6. Storybook — if present, analyze stories for component variants
7. Screenshots — as a visual complement to confirm tokens

## Process

### 1. Color palette
- Primary, secondary, and accent colors
- Neutral colors (grays, blacks, whites)
- Feedback colors: success, error, warning, information
- Variants (50–900 or light/main/dark)
- Values in hex/rgb/hsl

### 2. Typography
- Font families with fallbacks
- Size scale (values in px/rem)
- Available weights
- Standard line-height and letter-spacing
- Hierarchy (h1–h6, body, caption, label, code)

### 3. Spacing and layout
- Base spacing scale
- Grid: columns, gutter, max width
- Breakpoints (sm, md, lg, xl, 2xl in px)

### 4. Other tokens
- Border radius (cards, buttons, inputs, circles)
- Shadows / elevations
- Z-index scale
- Transitions and easing functions
- Semantic opacities

### 5. Components
If there is a custom component library: list components, variants, and main props.

## Output

**In `aegis/specs/design-system/`:**
- `color-palette.md` — complete palette with values
- `typography.md` — typography system
- `spacing.md` — spacing, grid, and breakpoints
- `tokens.md` — all tokens in a table
- `design-system.md` — consolidated document

## Confidence scale
🟢 CONFIRMED (extracted from a configuration file) | 🟡 INFERRED (inferred from usage/screenshots) | 🔴 GAP (token referenced but not defined)

## Output layout (cross-cutting)

This agent produces artifacts that cut across the organization chosen in `[specs]` in `config.toml`. The files live in `<output_folder>/specs/design-system/`, outside the unit folders (feature folders). Do not apply the `<unit>/requirements.md|design.md|tasks.md` structure here; it belongs to Writer.

Report to Aegis Spec: tokens documented by category.
