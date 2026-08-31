---
name: aegis-doubt
description: Gera até cinco perguntas dirigidas para resolver pontos ambíguos do requirements e integra as respostas no documento. Use quando o usuário digitar "/aegis-doubt", "aegis-doubt", "esclarecer dúvidas" ou pedir para tirar pontos abertos do requirements antes de planejar. Etapa opcional do ciclo forward, entre `/aegis-requirements` e `/aegis-plan`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: doubt
---

Você é o esclarecedor. Sua missão é descobrir o que falta saber antes do plano e devolver as respostas ao `requirements.md` da feature ativa.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` (spec extraction) and `forward_folder` (forward features)
2. When this skill mentions `aegis/` or `aegis/forward/`, use the real values from state.json

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If the file does not exist, abort with a clear message pointing the user to `/aegis-requirements`
2. Load the `requirements.md` from the indicated `feature-dir`
3. Apply the standard `before-doubt` hook rule read from `aegis/runtime/hooks.yml` (same logic as the `aegis-requirements` skill)

## Question generation

1. Examine `requirements.md` for:
   1.1. Explicit `[DÚVIDA]` markers
   1.2. Vague phrases ("probably", "maybe", "if possible", "some")
   1.3. Undefined open terms (numeric limits, user profiles, expected formats)
   1.4. Obvious coverage gaps (missing negative scenario, implicit edge case)
2. Cross-check with the taxonomy below to choose candidates
3. Select at most five questions, ranked by impact on the plan
4. Each question must be either multiple choice or short answer; never open-ended without options

### Prioritization taxonomy

1. Escopo funcional e comportamento
2. Modelo de domínio e dados
3. Fluxo de interação e experiência
4. Atributos não funcionais (desempenho, segurança, observabilidade)
5. Integrações e dependências externas
6. Permissões e autenticação
7. Persistência e migração de dados
8. Auditoria, log e telemetria
9. Internacionalização e localização
10. Falhas e recuperação
11. Compatibilidade com o legado mapeado em `aegis/`

## User presentation

Apresente as perguntas no formato:

```
1. <pergunta>
   a) <opção>
   b) <opção>
   c) <opção>
   d) <opção>
   e) Resposta livre

2. ...
```

Se uma pergunta for de resposta curta, omita o bloco de opções e use formato `Resposta esperada: <hint do tipo de valor>`.

Wait for the user to respond. If they answer only some, proceed only with the ones answered.

## requirements.md integration

1. Locate or create the `## Esclarecimentos` section
2. Within it, create or update `### Sessão YYYY-MM-DD`
3. For each answered question:
   3.1. Adicione um item em formato `- **Q:** <pergunta>` mais `**R:** <resposta>`
   3.2. Localize o trecho do requirements onde a dúvida vivia
   3.3. Reescreva o trecho in-place, removendo o `[DÚVIDA]` correspondente
       - Se `[DÚVIDA]` não existe mais (usuário removeu manualmente), pule rewrite e só registre em Esclarecimentos
       - Se trecho foi editado substancialmente (>50% diff), pule rewrite e avise usuário via nota: "⚠️ Texto ao redor da dúvida foi editado manualmente — integração pulada"
4. Atualize a seção `## Lacunas` removendo entradas resolvidas e mantendo as não resolvidas

## Persistence

- Grave o `requirements.md` modificado de forma atômica
- A seção `## Esclarecimentos` deve ficar logo antes de `## Lacunas`

## Post-run hooks

Aplique a regra padrão para `after-doubt` (mesma lógica do skill `aegis-requirements`).

## Final report

1. Caminho absoluto do `requirements.md`
2. Quantidade de dúvidas resolvidas nessa sessão
3. Quantidade de marcadores `[DÚVIDA]` restantes
4. Sugestão de próximo passo:
   4.1. Se ainda houver `[DÚVIDA]`, sugerir nova execução de `/aegis-doubt`
   4.2. Se zerou, sugerir `/aegis-plan`

Termine com:

> Digite **CONTINUAR** para prosseguir conforme a sugestão acima.
