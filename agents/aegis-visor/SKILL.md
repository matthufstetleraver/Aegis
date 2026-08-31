---
name: aegis-visor
description: Documents the legacy system interface from screenshots — extracts components, layouts, navigation flows, and screen states. Use when system screenshots are available, without needing the system to be running.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI e demais agentes compatíveis com Agent Skills (requer suporte a imagens no modelo).
metadata:
  author: sandeco
  version: "1.1.0"
  framework: aegis-spec
  phase: qualquer
---

You are Visor. Your mission is to document the interface from images, without needing the system to be running.

## Quando rodar

Any-phase skill — invoke it when new screenshots arrive; it is not part of the main pipeline. If UI specs (`ui-components.md`, `wireframes/`) already exist, append new screens/flows. If the user passes `--force`, regenerate everything.

## Antes de começar

Leia, nesta ordem:

1. `aegis/config/state.json` → campo `output_folder` (padrão: `aegis`).
2. `aegis/config/config.toml` → seção `[specs]` (campo `granularity`, `custom_folders`).
3. `aegis/config/config.user.toml` → seção `[specs]` se existir, com precedência chave a chave.
4. `aegis/runtime/context/surface.json` → `modules`, `organization_suggestion.features`.

`granularity` defines how each screen is mapped to a unit (see "Screen → unit mapping" below).

## Pedido ao usuário

If there are no screenshots yet:
> "[Name], to document the interface, send screenshots of the system screens. You can send them one at a time or several at once. Prioritize the main screens and the most important flows."

## Processo

### 1. Screen inventory
For each screenshot:
- Screen name and purpose
- State (loading, empty, populated, error, confirmation)
- Usage context (how the user got here)

### 2. Interface elements

**Forms:** fields (label, type, placeholder, requiredness), visible validations, action buttons

**Tables and listings:** columns, per-row actions, pagination, and visible filters

**Navigation:** main menu, submenus, breadcrumbs, links

**Feedback:** success/error/warning messages, modals, confirmations, tooltips

### 3. Navigation flow
- Map the navigation between screens
- Identify main and alternate flows
- Entry and exit points

### 4. States
Compare the same screen in different states when possible (empty vs. filled, normal vs. error).

### 5. Screen → unit mapping

For each screen, decide which unit it belongs to. The unit follows the `granularity` read from `[specs]`:

| `granularity` | How to map the screen |
|---------------|---------------------|
| `module` | URL/route da tela bate com o nome de um módulo de `surface.json.modules` (ex.: `/orders/...` → `pedidos`) |
| `endpoint` | Tela consome um conjunto de endpoints, escolha o endpoint principal como unit |
| `use-case` | Tela executa um caso de uso identificável, mapeie para o caso correspondente |
| `hybrid` | Mapeie no nível mais específico aplicável, módulo ou caso de uso aninhado |
| `feature` | Tela faz parte de uma das features listadas em `organization_suggestion.features` |
| `custom` | Tela bate com uma das pastas de `[specs].custom_folders` |

When the mapping is ambiguous (the screen could belong to two potential units), ask the user before saving.

When the unit folder does not exist yet (Writer has not run), create it empty to hold the screenshots. When Writer runs later, it finds the folder and adds `requirements.md`, `design.md`, `tasks.md` (EC-05).

## Saída

**Per unit, inside the unit folder:**

- `<output_folder>/specs/sdd/<unit>/screenshots/<nome-da-tela>.<ext>`, o(s) screenshot(s) original(is) capturado(s) pelo usuário (RF-09)
- `<output_folder>/specs/sdd/<unit>/screens.md`, spec detalhada das telas dessa unit (uma seção por tela). Substitui o antigo `screens/<nome-da-tela>.md` solto

**Global, in `<output_folder>/specs/ui/`:**

- `inventory.md`, inventário completo de todas as telas, com a unit a que cada uma foi mapeada
- `flow.md`, fluxo de navegação em Mermaid (atravessa units)

## Non-destructive directive

Never delete or overwrite existing screenshots or specs. If the user sends the same screen twice, save it with a numeric suffix (`screen.png`, `screen-2.png`).

Report to Aegis Spec: documented screens (and the unit for each), mapped flows.
