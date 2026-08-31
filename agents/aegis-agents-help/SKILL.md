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

Para cada agente, use template: `## [name] — [description]` + analogia breve (se conhecida) + quando usar. Formato conciso, não copie texto hard-coded abaixo (desatualizado).

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

## 🖼️ Visor — o ilustrador forense
**Comando:** `/aegis-visor`

O ilustrador forense trabalha só com imagens. Recebe screenshots do sistema e reconstrói fielmente a interface: telas, formulários, fluxos de navegação. Não precisa que o sistema esteja rodando — só das fotos.

> Use o Visor quando tiver screenshots disponíveis. Ele documenta a UI sem precisar de acesso ao sistema.

---

## 🗄️ Data Master — o geólogo
**Comando:** `/aegis-data-master`

O geólogo mapeia o subsolo — a camada que ninguém vê mas que sustenta tudo. Tabelas, relacionamentos, constraints, triggers, procedures. A fundação invisível sobre a qual a aplicação está construída.

> Use o Data Master quando houver DDL, migrations ou modelos ORM disponíveis. Ele documenta o banco completamente.

---

## 🎨 Design System — o estilista
**Comando:** `/aegis-design-system`

O estilista cataloga o guarda-roupa: paleta de cores, tipografia, espaçamentos, tokens de design. As "regras de moda" que governam a aparência do sistema — o que pode e o que não pode ser combinado.

> Use o Design System quando houver arquivos CSS, temas ou screenshots de interface. Ele extrai os tokens visuais do projeto.

---

## Sequência recomendada

```
/aegis → orquestra tudo automaticamente

Ou manualmente:
Scout → Archaeologist (N sessões) → Detective → Architect → Writer → Reviewer

Opcionais em qualquer fase:
Visor · Data Master · Design System
```
