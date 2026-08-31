---
schemaVersion: 1
kind: paradigm_catalog
description: Advisory catalog of programming paradigms, stack mapping to natural paradigm, and typical gaps by pair (source → target). Used by Paradigm Advisor.
---

# Paradigm Catalog

> Structured knowledge about paradigms and how they relate to common stacks.
> Updating this catalog is an independent maintenance task of the Paradigm Advisor agent.

## Paradigm Catalog

### Procedural
- **Characteristics**: top-level functions, linear flow in controllers, absence of classes or ornamental use, data as dicts/structs, open side effects.
- **Examples in legacy**: classic PHP scripts, COBOL batch, pre-OO Perl systems, shell scripts.
- **Signals in `aegis/`**: domain described as "functions", linear flows in `process_flows`, absence of explicit aggregates.

### Classic OO
- **Characteristics**: class hierarchy, strong inheritance, Active Record pattern, logic coupled to models, framework dictates structure.
- **Examples in legacy**: monolithic Rails, traditional Django, pre-DI Java EE, .NET WebForms / classic.
- **Signals in `aegis/`**: classes with broad responsibilities, inheritance in domain model, anemic controllers calling model methods.

### OO with DI
- **Characteristics**: injection containers, explicit interfaces, Repository / Service pattern, clear layer separation.
- **Examples in legacy**: modern Spring, .NET 6+, NestJS, modern Symfony.
- **Signals in `aegis/`**: explicit aggregates, repository interfaces, absence of Active Record.

### Functional
- **Characteristics**: dominant immutability, pure functions, composition, absence of implicit side effects, rich typing.
- **Examples in legacy**: Haskell, Elm, F#, functional Scala, Clojure.
- **Signals in `aegis/`**: algebraic types, absence of classes, flow expressed as composition.

### Event-driven (Asynchronous)
- **Characteristics**: queues / topics, decoupled handlers, absence of linear flow, eventual consistency, explicit idempotency.
- **Examples in legacy**: modern queue-oriented Node backends, SQS / Kafka heavy systems, asynchronous microservices.
- **Signals in `aegis/`**: events in domain model, integrations via queue, long-running processes with retry.

### Actor Model
- **Characteristics**: isolated actors with mailbox, supervision, state isolation.
- **Examples in legacy**: Erlang / Elixir / OTP, Akka.
- **Signals in `aegis/`**: supervised processes, messages between actors.

### Dataflow
- **Characteristics**: declarative pipelines, flow transformations, absence of imperative loops in domain.
- **Examples in legacy**: classic ETLs, Spark, Flink.
- **Signals in `aegis/`**: DAG description, transformations in stages.

## Stack → Natural Paradigm Mapping

| Stack alvo | Paradigma natural | Alternativas viáveis | Notas |
|---|---|---|---|
| Node.js 20 (Fastify, Express, NestJS) | event-driven assíncrono | OO com DI (NestJS), funcional leve | runtime async-first; bloqueio CPU pesado vai para worker threads |
| Go (net/http, Echo, Fiber) | CSP / goroutines (event-driven leve) | procedural estruturado | concorrência via channels; OO simulada via interfaces |
| Rust (axum, Actix, tokio) | ownership / async funcional | event-driven | imutabilidade por default, segurança via tipos |
| Elixir / Phoenix | actor model (BEAM) | funcional | supervisão via OTP |
| Python moderno (FastAPI, Django 5) | OO com DI ou procedural rico | event-driven (Celery, asyncio) | escolha depende do framework |
| Kotlin (Spring Boot, Ktor) | OO com DI | event-driven (Reactor) | corrotinas habilitam async ergonômico |
| .NET 8 (ASP.NET Core, Minimal API) | OO com DI | event-driven (Channels, MediatR) | tradição OO + assincronismo first-class |
| Java moderno (Spring Boot 3, Quarkus) | OO com DI | event-driven (Project Reactor) | bibliotecas funcionais possíveis mas não dominantes |
| Ruby moderno (Rails 7, Hanami) | OO clássico (Rails) ou OO com DI (Hanami) | funcional leve (dry-rb) | Rails dita Active Record; Hanami é DI-heavy |
| TypeScript serverless (AWS Lambda, Cloudflare Workers) | event-driven | funcional | invocação por evento; cold start influencia design |

## Tabela de gaps típicos por par

| De → Para | Gap principal | Implicações concretas |
|---|---|---|
| procedural → event-driven | sincronia → assincronismo | resposta deixa de ser imediata; tratamento de erro vira retry/DLQ; idempotência obrigatória; ordem de eventos passa a importar |
| procedural → OO com DI | dados como dict → aggregates | invariantes ficam dentro de aggregates; lógica deixa de viver em controllers; dependências via interfaces |
| procedural → funcional | side effects abertos → puros + isolados | mutabilidade vira exceção; composição substitui sequência; tipos algébricos para estados |
| OO clássico → event-driven | fluxo síncrono → coreografia | ações deixam de ser atômicas; transações distribuídas viram sagas; consistência forte → eventual |
| OO clássico → OO com DI | herança → composição via interfaces | Active Record desaparece; persistência vira repositório; testes ganham mocks naturais |
| OO clássico → funcional | encapsulamento mutável → imutabilidade | métodos com efeito viram funções puras + atualização explícita; estado expresso como sequência de transformações |
| OO com DI → event-driven | comando síncrono → evento | retorno deixa de ser imediato; orquestração vira coreografia; ordem por chave |
| OO com DI → funcional | mocks → composição testável | DI deixa de ser por interface, vira por argumento de função |
| funcional → event-driven | composição síncrona → mensageria | latência aumenta; falha vira mensagem em DLQ; estado distribuído |
| event-driven → procedural síncrono | desnatural; só faz sentido para sistemas pequenos | colapsar handlers em chamadas diretas; perda de desacoplamento; consistência forte volta |
| dataflow → event-driven | DAG declarativa → coreografia mutável | controle fica menos previsível; ordem precisa ser garantida por chave |
| actor model → OO com DI | mensagens entre atores → chamadas síncronas | perda de isolamento de falha; supervisão precisa virar try/catch ou retry orquestrado |

## Função utilitária (uso pelo Paradigm Advisor)

Pseudo-procedimento que o agente segue ao consultar o catálogo:

1. Receber `paradigma_legado` (detectado) e `stack_alvo` (do brief).
2. Olhar `Mapeamento stack → paradigma natural`, registrar `paradigma_alvo` e `alternativas`.
3. Comparar `paradigma_legado` com `paradigma_alvo`:
   - Se iguais: retornar `gap = nenhum`, `implicações = []`.
   - Se diferentes: olhar `Tabela de gaps típicos por par` e retornar `implicações`.
4. Se híbrido no legado: aplicar passo 3 para cada componente e retornar lista combinada.

## Cenários de teste do catálogo (para validação)

1. legado procedural + stack Node → gap = procedural → event-driven, implicações = [sincronia/assincronismo, idempotência, retry/DLQ, ordem]
2. legado OO clássico + stack .NET 8 → gap = OO clássico → OO com DI, implicações = [herança/composição, repository, mocks]
3. legado OO clássico + stack Go → gap = OO clássico → CSP, implicações = [interfaces idiomáticas, channels para coordenação, perda de herança]
4. legado funcional + stack Elixir → gap = funcional → actor model, implicações = [estado distribuído, supervisão, mensagens]
5. legado event-driven + stack Node → gap = nenhum
6. legado COBOL batch + stack TypeScript serverless → gap extremo, implicações múltiplas: batch → event-driven, procedural → tipagem rica, ausência de loops longos → invocações curtas
7. legado Rails monolítico + stack Hanami → gap = OO clássico (Active Record) → OO com DI, implicações = [repository, dry-monads opcional]
8. legado híbrido (Rails + Sidekiq) + stack Node → híbrido decomposto: parte síncrona Rails → Node sync; parte async Sidekiq → Node fila moderna
