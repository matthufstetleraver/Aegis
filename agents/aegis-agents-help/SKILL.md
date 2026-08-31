---
name: aegis-agents-help
description: Explica com analogias o que cada agente do Aegis Spec faz e quando usá-lo. Ative com /aegis-agents-help.
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
**Comando:** `/aegis`

A conductor does not play any instrument. They know the whole score and decide who comes in when, in what order, and at what pace. Without them, each musician would play their part without connecting to the others.

> Use Aegis Spec to start or resume the full analysis. It handles the sequence for you.

---

## 🗺️ Scout — the real estate agent
**Comando:** `/aegis-scout`

The real estate agent does the first tour of the property. They do not open drawers, read documents, or touch anything. They only map: how many rooms, which neighborhood, what facilities exist, and the overall condition.

> Use Scout at the beginning. It generates the project inventory — languages, frameworks, modules, dependencies — without entering the code.

---

## ⛏️ Archaeologist — o escavador
**Comando:** `/aegis-archaeologist`

O arqueólogo escava o terreno com paciência, camada por camada. Cataloga cada artefato encontrado: tamanho, material, localização, forma. Ele não interpreta a civilização, só descreve com precisão o que está lá.

> Use o Archaeologist para analisar o código módulo a módulo. Ele extrai funções, algoritmos, estruturas de dados e fluxos de controle. **Roda um módulo por sessão** para economizar tokens.

---

## 🔍 Detective — o Sherlock Holmes
**Comando:** `/aegis-detective`

Sherlock Holmes chega depois do arqueólogo. Olha para os artefatos catalogados e pergunta: *"Mas por que isso está aqui? Quem colocou? O que isso revela sobre quem viveu aqui?"* Ele não escava. Ele interpreta.

> Use o Detective após o Archaeologist. Ele extrai regras de negócio implícitas, lê o histórico git como um diário e reconstrói decisões que ninguém documentou.

---

## 📐 Architect — o cartógrafo
**Comando:** `/aegis-architect`

O cartógrafo visita um território e produz mapas formais: planta baixa, mapa de elevação, planta estrutural. Alguém que nunca pisou lá consegue entender tudo olhando para os mapas.

> Use o Architect após o Detective. Ele sintetiza tudo em diagramas C4, ERD completo e mapa de integrações.

---

## 📝 Writer — o tabelião
**Comando:** `/aegis-writer`

O tabelião transforma o que foi descoberto em contratos formais, precisos e rastreáveis. Cada cláusula tem grau de certeza declarado. O documento vale como contrato: um agente de IA pode reimplementar o sistema a partir dele.

> Use o Writer após o Architect. Ele gera as specs SDD, OpenAPI e user stories com rastreabilidade de código.

---

## ⚖️ Reviewer — o revisor de specs
**Comando:** `/aegis-reviewer`

O Reviewer pega os contratos do Writer e tenta furar: *"Isso é contradição. Esse ponto não tem prova. Essa regra some se o usuário fizer X."* Ele não quer destruir, quer garantir que o que ficou de pé seja sólido.

> Use o Reviewer após o Writer. Ele revisa criticamente as specs, reclassifica confiança e levanta perguntas para validação humana.

---

## 🖼️ Visor — the forensic illustrator
**Comando:** `/aegis-visor`

The forensic illustrator works only with images. They receive system screenshots and faithfully reconstruct the interface: screens, forms, and navigation flows. They do not need the system running — only the pictures.

> Use Visor when you have screenshots available. It documents the UI without needing system access.

---

## 🗄️ Data Master — the geologist
**Comando:** `/aegis-data-master`

The geologist maps the underground layer — the part nobody sees but that supports everything. Tables, relationships, constraints, triggers, procedures. The invisible foundation on which the application is built.

> Use Data Master when DDL, migrations, or ORM models are available. It documents the database completely.

---

## 🎨 Design System — the stylist
**Comando:** `/aegis-design-system`

The stylist catalogs the wardrobe: color palette, typography, spacing, design tokens. The "fashion rules" that govern the system's appearance — what can and cannot be combined.

> Use Design System when CSS files, themes, or UI screenshots are available. It extracts the project's visual tokens.

---

## Sequência recomendada

```
/aegis → orquestra tudo automaticamente

Ou manualmente:
Scout → Archaeologist (N sessões) → Detective → Architect → Writer → Reviewer

Optional in any phase:
Visor · Data Master · Design System
```
