# Aegis Spec Localization Glossary

**Purpose**: Comprehensive mapping of Portuguese terms to English translations used throughout the Aegis Spec English localization project (Phase 1-3). This glossary serves as reference for future localization phases, code refactoring, and terminology consistency.

**Created**: 2026-08-31  
**Scope**: User-facing text, templates, documentation, and configuration  
**Code Identifiers**: Preserved in Portuguese (architectural markers, business rules, field names)  
**Status**: Complete for Phase 1-3 localization

---

## Core Terminology

### Migration & Architecture Concepts

| Portuguese | English | Context | Preserved As |
|---|---|---|---|
| legado | legacy | System/code being migrated | Field names, BR-MIGRAR-NNN rules |
| novo | new | Target system/code | Field names, paradigm names |
| alvo | target | Target state/architecture | Field names, section headers |
| paradigma | paradigm | Migration paradigm (monolith→microservices, etc.) | Code identifiers |
| migracao | migration | Migration effort/project | File names, section headers |
| passo | step | Migration step/phase | Template instruction text |
| fluxo | flow | Business/workflow flow | Section headers, descriptions |
| regra | rule | Business rule or architectural rule | Section headers |
| dominio | domain | Business domain/bounded context | Field names, section headers |
| contexto | context | Bounded context in DDD | Section headers, table labels |
| invariante | invariant | Domain invariant/constraint | Field names, descriptions |
| entidade | entity | Domain entity | Field names, section headers |
| agregado | aggregate | DDD aggregate root | Field names, descriptions |
| evento | event | Domain event | Field names, table labels |
| comando | command | Domain command | Field names, descriptions |

### Quality & Decision Tracking

| Portuguese | English | Context | Usage |
|---|---|---|---|
| confirmado | confirmed | Verified/approved decision state | Confidence labels (CONFIRMED) |
| inferido | inferred | Deduced from analysis | Confidence labels (INFERRED) |
| lacuna | gap | Missing information/decision | Confidence labels (GAP) |
| ambiguo | ambiguous | Unclear/needs clarification | Confidence labels (AMBIGUOUS) |
| duvida | doubt | Unresolved question/uncertainty | Agent name (doubt), task type |
| bloqueado | blocked | Work blocked by dependency/decision | Status labels |
| descartado | discarded | Explicitly rejected option | Log categories |
| pendente | pending | Awaiting decision/input | Status labels |
| critico | critical | High priority/impact item | Task/rule severity |
| opcional | optional | Not required/nice-to-have | Requirement priority |

### Execution & Workflow

| Portuguese | English | Context | Usage |
|---|---|---|---|
| executor | executor | Role executing tasks | Agent descriptions |
| revisor | reviewer | Role reviewing work | Agent name (reviewer) |
| descoberta | discovery | Discovery phase/activity | Template categories |
| planejamento | planning | Planning phase | Agent name (plan) |
| implementacao | implementation | Implementation phase | Phase names |
| teste | test/testing | Testing phase/activity | Phase names, section headers |
| validacao | validation | Validation/verification activity | Section headers |
| aceitacao | acceptance | Acceptance criteria/testing | Requirement labels |
| piloto | pilot | Pilot deployment/testing | Strategy labels |
| produccao | production | Production environment | Environment names |
| cutover | cutover | Production switchover/migration | Section headers, templates |
| rollback | rollback | Emergency rollback procedure | Section headers |

### Data & Integration

| Portuguese | English | Context | Usage |
|---|---|---|---|
| dados | data | Data/dataset | Field names, section headers |
| migracao-dados | data migration | Data migration process | Section headers, templates |
| mapeamento | mapping | Field/entity mapping | Section headers, tables |
| transformacao | transformation | Data transformation | Section headers, descriptions |
| etl | ETL | Extract-Transform-Load process | Section headers, procedure names |
| integracao | integration | System integration | Field names, descriptions |
| interface | interface | Integration interface/contract | Section headers, descriptions |
| contrato | contract | Interface contract/specification | Section headers, descriptions |
| compatibilidade | compatibility | Backward/forward compatibility | Requirement labels |
| parity | parity | Feature/data parity | Requirement labels, templates |

### Documentation & Artifacts

| Portuguese | English | Context | Usage |
|---|---|---|---|
| artefato | artifact | Migration artifact (output document) | Category names, section headers |
| handoff | handoff | Delivery/handoff document | Template name |
| resumo | summary | Executive summary | Section headers |
| visao-geral | overview | Overview section | Section headers |
| contexto | context | Context/background section | Section headers |
| problema | problem | Problem statement | Section headers |
| solucao | solution | Proposed solution | Section headers |
| alternativa | alternative | Alternative approach/option | Section headers, table labels |
| decisao | decision | Design/architecture decision | Template names, section headers |
| risco | risk | Risk/threat | Section headers, table labels |
| impacto | impact | Impact analysis | Section headers, table labels |
| dependencia | dependency | Work/artifact dependency | Section headers, table labels |
| prerequisito | prerequisite | Prerequisite/precondition | Section headers |
| saida | output | Output/deliverable | Section headers |
| entrada | input | Input/requirement | Section headers |

### Agent/Skill Names (Preserved Code Identifiers)

All agent names kept in English as architectural markers:

| Agent Folder | English Name | Primary Role |
|---|---|---|
| agents-help | Agents Help | Reference/guidance agent |
| archaeologist | Archaeologist | Legacy system analysis |
| architect | Architect | Architecture design & review |
| audit | Audit | Compliance & audit verification |
| coding | Coding | Code implementation |
| curator | Curator | Knowledge curation & synthesis |
| data-master | Data Master | Data mapping & transformation |
| design-system | Design System | Design consistency/governance |
| designer | Designer | User experience design |
| detective | Detective | Anomaly detection & investigation |
| doubt | Doubt | Issue/uncertainty tracking |
| inspector | Inspector | Quality inspection & validation |
| keeper | Keeper | Configuration management & policy |
| migrate | Migrate | Migration execution & tracking |
| n8n | n8n | Workflow automation |
| paradigm-advisor | Paradigm Advisor | Paradigm selection & guidance |
| plan | Plan | Project planning & scheduling |
| principles | Principles | Design principles enforcement |
| quality | Quality | Quality assurance & metrics |
| reconstructor | Reconstructor | System reconstruction |
| requirements | Requirements | Requirements gathering & analysis |
| resume | Resume | Work resumption & recovery |
| reviewer | Reviewer | Code/design review |
| scout | Scout | Exploration & discovery |
| strategist | Strategist | Strategy development & planning |
| tech-brief | Tech Brief | Technical briefing |
| to-do | To-Do | Task management |
| visor | Visor | Visibility & monitoring |
| writer | Writer | Documentation & writing |

---

## Template & Document Sections

### Migration Artifact Templates (Phase 2)

#### Paradigm Decision (paradigm_decision.md)

| Portuguese | English |
|---|---|
| decisao-paradigma | paradigm decision |
| comparacao-paradigmas | paradigm comparison |
| criterios-selecao | selection criteria |
| paradigma-recomendado | recommended paradigm |
| risco-paradigma | paradigm risk |
| custo-transicao | transition cost |

#### Target Architecture (target_architecture.md)

| Portuguese | English |
|---|---|
| arquitetura-alvo | target architecture |
| componentes | components |
| contexto-limitado | bounded context |
| dependencias-contexto | context dependencies |
| decisao-arquitetura | architecture decision |
| honrar-paradigma | paradigm honor |

#### Data Migration Plan (data_migration_plan.md)

| Portuguese | English |
|---|---|
| plano-migracao-dados | data migration plan |
| mapeamento-campos | field mapping |
| transformacao-dados | data transformation |
| estrategia-etl | ETL strategy |
| cutover-dados | data cutover |
| validacao-dados | data validation |

#### Handoff (handoff.md)

| Portuguese | English |
|---|---|
| ordem-leitura | reading order |
| artefatos | artifacts |
| bloqueadores | blockers |
| proximos-passos | next steps |
| decisoes-automaticas | auto-decided items |

#### Migration Brief (migration_brief.md)

| Portuguese | English |
|---|---|
| breve-migracao | migration brief |
| contexto-negocios | business context |
| objetivos | objectives |
| restricoes | constraints |

#### Target Business Rules (target_business_rules.md)

| Portuguese | English |
|---|---|
| regras-negocio-alvo | target business rules |
| invariantes | invariants |
| restricoes | constraints |

#### Migration Strategy (migration_strategy.md)

| Portuguese | English |
|---|---|
| estrategia-migracao | migration strategy |
| fases | phases |
| marcos | milestones |
| abordagem | approach |

#### Cutover Plan (cutover_plan.md)

| Portuguese | English |
|---|---|
| plano-cutover | cutover plan |
| preparacao | preparation |
| execucao-cutover | cutover execution |
| validacao-producao | production validation |

#### Target Domain Model (target_domain_model.md)

| Portuguese | English |
|---|---|
| modelo-dominio-alvo | target domain model |
| entidades | entities |
| agregados | aggregates |
| relacoes | relationships |
| eventos | events |

#### Parity Specs (parity_specs.md)

| Portuguese | English |
|---|---|
| especificacoes-paridade | parity specifications |
| recursos-igualdade | feature parity |
| dados-igualdade | data parity |
| comportamento-igualdade | behavior parity |

#### Target Data Model (target_data_model.md)

| Portuguese | English |
|---|---|
| modelo-dados-alvo | target data model |
| tabelas | tables |
| campos | fields |
| relacionamentos | relationships |
| indices | indexes |

#### Risk Register (risk_register.md)

| Portuguese | English |
|---|---|
| registro-riscos | risk register |
| risco | risk |
| probabilidade | probability |
| impacto | impact |
| mitigacao | mitigation |

#### Ambiguity Log (ambiguity_log.md)

| Portuguese | English |
|---|---|
| registro-ambiguidades | ambiguity log |
| ambiguidade | ambiguity |
| impacto-bloqueio | blocking impact |
| decisao-necessaria | decision needed |

#### Pending Decisions (pending_decisions.md)

| Portuguese | English |
|---|---|
| decisoes-pendentes | pending decisions |
| questao | question |
| opcoes | options |
| impacto | impact |

#### Discard Log (discard_log.md)

| Portuguese | English |
|---|---|
| registro-descarte | discard log |
| descartado | discarded |
| motivo-descarte | discard reason |
| impacto | impact |

### Discovery Team Templates (Phase 2)

| Template | Portuguese → English Sections |
|---|---|
| requirements-template.md | Requisitos → Requirements, Criterios de Aceitacao → Acceptance Criteria, Prioridade → Priority |
| principles-template.md | Principios → Principles, Racionalizacao → Rationale, Implicacoes → Implications |
| roadmap-template.md | Mapa de Estradas → Roadmap, Fases → Phases, Marcos → Milestones, Dependencias → Dependencies |
| quality-template.md | Qualidade → Quality, Metricas → Metrics, Limites Aceitaveis → Acceptable Limits, Validacao → Validation |
| actions-template.md | Acoes → Actions, Proprietario → Owner, Prazo → Due Date, Prioridade → Priority |

### Documentation Files (Phase 3)

| File | Key Portuguese → English Changes |
|---|---|
| escala-confianca.md | Escala de confiança → Confidence Scale, Niveis → Levels |
| keeper-auto.md | Modo Automatico → Auto Mode, Politica → Policy, Resolucao Automatica → Auto Resolution |
| pipeline.md | Pipeline, Fases, Transformacoes → Phases, Transformations |
| engines.md | Motores → Engines, Capacidades → Capabilities, Integracoes → Integrations |
| localization-glossary.md | Glossario de Localizacao → Localization Glossary (this file) |
| keeper-graph-integration.md | Integracao Grafo → Graph Integration, Vertices → Vertices, Arestas → Edges |
| drift-check.md | Verificacao Desvio → Drift Check, Desvios → Deviations |
| por-que-aegis.md | Por Que → Why, Filosofia → Philosophy, Principios → Principles |
| hooks.md | Ganchos → Hooks, Ciclo de Vida → Lifecycle, Eventos → Events |
| desenvolvendo-com-specs.md | Desenvolvendo → Developing, Especificacoes → Specifications |

---

## Business Rule Identifiers (Structural - Preserved in Portuguese)

Business rule identifiers throughout the repository follow patterns and are **intentionally preserved** as structural markers:

| Pattern | Example | Usage |
|---|---|---|
| BR-MIGRAR-NNN | BR-MIGRAR-001, BR-MIGRAR-042 | Migration business rules |
| BR-DESCARTAR-NNN | BR-DESCARTAR-005 | Discard/rejection rules |
| BR-VALIDAR-NNN | BR-VALIDAR-010 | Validation rules |
| BR-INTEGRAR-NNN | BR-INTEGRAR-003 | Integration rules |

These identifiers appear in:
- Target domain model specs
- Risk registers
- Business rule mappings
- Migration strategy documents
- Validation matrices

---

## Confidence Labels (Standardized to English)

All confidence/certainty indicators in user-facing text use English labels:

| Label | Usage | Context |
|---|---|---|
| **CONFIRMED** | Decision verified and locked | Architecture decisions, validated requirements |
| **INFERRED** | Deduced from analysis | Derived business rules, inferred constraints |
| **GAP** | Missing information | Unresolved requirements, information gaps |
| **AMBIGUOUS** | Requires clarification | Unclear specifications, decision ambiguity |

Previously Portuguese equivalents (CONFIRMADO, INFERIDO, LACUNA, AMBÍGUO) are now fully English.

---

## Code Identifiers (Field Names, Preserved)

The following code identifiers appear in templates and documentation and are **preserved in Portuguese** as architectural/structural markers:

### Domain Model Fields
- `nome_legado` → legacy_name (field name preserved as Portuguese)
- `nome_alvo` → target_name (field name preserved as Portuguese)
- `tipo_paradigma` → paradigm_type (field name preserved as Portuguese)
- `regra_negocio` → business_rule (field name preserved as Portuguese)

### Task/Workflow Types
- `tarefa_descoberta` → discovery_task (internal identifier)
- `tarefa_validacao` → validation_task (internal identifier)
- `decisao_bloqueadora` → blocking_decision (internal identifier)

### Configuration Keys
- `modo_automatico` → auto_mode (internal config key)
- `nivel_confianca` → confidence_level (internal field name)

These are intentionally NOT renamed in this phase; they are marked for future refactoring phase (Phase 4+).

---

## Multi-Phase Localization Roadmap

### Completed Phases

**Phase 1: Agent Skills** ✅
- 30+ SKILL.md files (frontmatter, missions, procedures, edge cases, confidence labels)
- Confidence labels standardized to English (CONFIRMED, INFERRED, GAP, AMBIGUOUS)

**Phase 2: Templates** ✅
- 13 migration artifact templates (all user-facing text)
- 5 discovery/forward team templates (all instruction text, table labels)
- All section headers, descriptions, table labels translated

**Phase 3: Documentation & Configuration** ✅
- 10 English documentation files (residual Portuguese removed)
- mkdocs.yml configuration (theme language and toggle labels translated)
- i18n configuration preserved for language switcher functionality

### Future Phases (Out of Scope - Current)

**Phase 4: Internal Code Comments** (Future)
- `lib/` directory Python/JavaScript comments
- `agents/` directory docstrings
- Configuration parsing logic comments
- Utility function documentation

**Phase 5: Docstrings & API Documentation** (Future)
- API endpoint documentation
- Function/method docstrings
- Type annotations comments
- Internal utility documentation

**Phase 6: Code Identifier Refactoring** (Future)
- Rename field names (nome_legado → legacy_name)
- Rename task types (tarefa_descoberta → discovery_task)
- Rename config keys (modo_automatico → auto_mode)
- Update all references systematically

---

## Usage Guidelines

### For Developers

1. **Code Identifiers**: Use this glossary to understand Portuguese field names and task types when working with internal code.
2. **Future Refactoring**: Reference this glossary when planning Phase 4-6 localization work.
3. **Terminology Consistency**: Use the terminology mappings to maintain consistent naming across new code and documentation.

### For Documentation Writers

1. **Agent Documentation**: When creating new agent SKILL.md files, use English terminology from this glossary.
2. **Template Creation**: New templates should use English section headers and table labels from Phase 2-3 patterns.
3. **Terminology**: Use standardized terms (legacy, target, paradigm, domain, etc.) for consistency.

### For Translation/Localization Teams

1. **Reference**: This glossary is the source of truth for Portuguese → English mappings used in this project.
2. **Future Languages**: When expanding to other languages, use this English version as the source, not Portuguese.
3. **Structural Preservation**: Note which terms are intentionally preserved (business rule IDs, code identifiers) to avoid over-translating.

---

## FAQ

**Q: Why are some Portuguese terms preserved (code identifiers, business rules)?**  
A: Architectural markers and structural identifiers remain in Portuguese to maintain traceability, maintain existing system references, and allow gradual migration. Phase 6 (future) will address code identifier refactoring.

**Q: Can I use this glossary for other localization projects?**  
A: Yes. This glossary is reusable for Portuguese → English localization of similar domain-driven design and migration workflow projects.

**Q: What about Portuguese (.pt.md) and Spanish (.es.md) documentation?**  
A: These are intentional language variant versions and are NOT localization targets. The main English versions (.md files) are the source.

**Q: Are there any unresolved or ambiguous terms?**  
A: No. All Phase 1-3 terms are confirmed and standardized. See AEGIS_LOCALIZATION_COMPLETE.md for verification results.

---

## Maintenance

**Last Updated**: 2026-08-31  
**Status**: Complete for Phase 1-3  
**Next Review**: After Phase 4 (Internal Code Comments)  
**Owner**: Localization Team

---

## Related Artifacts

- **AEGIS_LOCALIZATION_COMPLETE.md** — Master project summary
- **PHASE_1_COMPLETION_SUMMARY.md** — Agent skills phase details
- **PHASE_2_COMPLETION_SUMMARY.md** — Templates phase details
- **PHASE_3_COMPLETION_SUMMARY.md** — Documentation phase details
- **SKILL_LOCALIZATION_COMPLETE.md** — Agent skills reference
