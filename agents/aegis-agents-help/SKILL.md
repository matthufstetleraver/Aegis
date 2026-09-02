---
name: aegis-agents-help
description: Explains with analogies what each Aegis Spec agent does and when to use it. Activate with /aegis-agents-help.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  role: help
---

List the agents installed dynamically. For each agent in `aegis/agents/*/SKILL.md`, extract `name`, `description`, and `phase` from the frontmatter. Present them in order: orchestrator (`aegis`), discovery phase (scout, archaeologist, detective, architect, writer, reviewer), keeper, forward (requirements, doubt, plan, to-do, audit, quality, coding, resume), migration (migrate, paradigm-advisor, curator, strategist, designer, inspector), any-phase (data-master, design-system, visor, reconstructor, principles, n8n), help (aegis-agents-help).

For each agent, use the template `## [name] — [description]` + a brief analogy (if known) + when to use it. Keep it concise; do not copy the hard-coded text below (it is outdated).

---

# Aegis Spec agents — guide with analogies

The Aegis Spec team is a group of specialists. Each agent does one thing — and does it well.

---

## 🎼 Aegis Spec — central orchestrator
**Command:** `/aegis`

A conductor does not play any instrument. They know the whole score and decide who comes in when, in what order, and at what pace. Without them, each musician would play their part without connecting to the others.

> Use Aegis Spec to start or resume the full analysis. It handles the sequence for you.

---

## 🗺️ Scout — the real estate agent
**Command:** `/aegis-scout`

The real estate agent does the first tour of the property. They do not open drawers, read documents, or touch anything. They only map: how many rooms, which neighborhood, what facilities exist, and the overall condition.

> Use Scout at the beginning. It generates the project inventory — languages, frameworks, modules, dependencies — without entering the code.

---

## ⛏️ Archaeologist — the excavator
**Command:** `/aegis-archaeologist`

The archaeologist digs the ground patiently, layer by layer. He catalogs each artifact found: size, material, location, shape. He does not interpret the civilization, just describes precisely what is there.

> Use the Archaeologist to analyze the code module by module. He extracts functions, algorithms, data structures, and control flows. **Runs one module per session** to save tokens.

---

## 🔍 Detective — Sherlock Holmes
**Command:** `/aegis-detective`

Sherlock Holmes arrives after the archaeologist. He looks at the cataloged artifacts and asks: *"But why is this here? Who put it? What does this reveal about who lived here?"* He does not dig. He interprets.

> Use the Detective after the Archaeologist. He extracts implicit business rules, reads git history as a diary, and reconstructs undocumented decisions.

---

## 📐 Architect — the cartographer
**Command:** `/aegis-architect`

The cartographer visits a territory and produces formal maps: floor plan, elevation map, structural plan. Someone who has never been there can understand everything by looking at the maps.

> Use the Architect after the Detective. He synthesizes everything into C4 diagrams, complete ERD, and integration map.

---

## 📝 Writer — the notary
**Command:** `/aegis-writer`

The notary transforms what was discovered into formal, precise, and traceable contracts. Each clause has a declared degree of certainty. The document is worth as a contract: an AI agent can re-implement the system from it.

> Use the Writer after the Architect. He generates SDD specs, OpenAPI, and user stories with code traceability.

---

## ⚖️ Reviewer — the specs reviewer
**Command:** `/aegis-reviewer`

The Reviewer takes the contracts from the Writer and tries to break them: *"This is a contradiction. This point has no proof. This rule disappears if the user does X."* He does not want to destroy, he wants to guarantee that what stands is solid.

> Use the Reviewer after the Writer. He critically reviews specs, reclassifies confidence, and raises questions for human validation.

---

## 🖼️ Visor — the forensic illustrator
**Command:** `/aegis-visor`

The forensic illustrator works only with images. They receive system screenshots and faithfully reconstruct the interface: screens, forms, and navigation flows. They do not need the system running — only the pictures.

> Use Visor when you have screenshots available. It documents the UI without needing system access.

---

## 🗄️ Data Master — the geologist
**Command:** `/aegis-data-master`

The geologist maps the underground layer — the part nobody sees but that supports everything. Tables, relationships, constraints, triggers, procedures. The invisible foundation on which the application is built.

> Use Data Master when DDL, migrations, or ORM models are available. It documents the database completely.

---

## 🎨 Design System — the stylist
**Command:** `/aegis-design-system`

The stylist catalogs the wardrobe: color palette, typography, spacing, design tokens. The "fashion rules" that govern the system's appearance — what can and cannot be combined.

> Use Design System when CSS files, themes, or UI screenshots are available. It extracts the project's visual tokens.

---

## Recommended sequence

```
/aegis → orchestrates everything automatically

Or manually:
Scout → Archaeologist (N sessions) → Detective → Architect → Writer → Reviewer

Optional in any phase:
Visor · Data Master · Design System
```
