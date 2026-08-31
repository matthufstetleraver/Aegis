> Local copy of the advisory catalog. The canonical source is in `templates/migration/catalogs/paradigm_catalog.md`.
> This copy is installed together with the agent so it has access to the catalog inside the user's project, without depending on the npm package location.

# Paradigm Catalog (local copy)

## Paradigm catalog

### Procedural
- **Characteristics**: top-level functions, linear flow in controllers, no classes or only ornamental usage, data as dicts/structs, open side effects.
- **Examples in the legacy system**: classic PHP scripts, COBOL batch, pre-OO Perl systems, shell scripts.
- **Signals in `aegis/`**: domain described as "functions", linear flows in `process_flows`, absence of explicit aggregates.

### Classic OO
- **Characteristics**: class hierarchy, strong inheritance, Active Record pattern, logic coupled to models.
- **Examples in the legacy system**: monolithic Rails, traditional Django, pre-DI Java EE, .NET WebForms / classic.
- **Signals in `aegis/`**: classes with broad responsibilities, inheritance in domain model, anemic controllers calling model methods.

### OO with DI
- **Characteristics**: injection containers, explicit interfaces, Repository / Service pattern, clear separation between layers.
- **Examples in the legacy system**: modern Spring, .NET 6+, NestJS, modern Symfony.
- **Signals in `aegis/`**: explicit aggregates, repository interfaces, absence of Active Record.

### Functional
- **Characteristics**: dominant immutability, pure functions, composition, absence of implicit side effects, rich typing.
- **Examples in the legacy system**: Haskell, Elm, F#, functional Scala, Clojure.
- **Signals in `aegis/`**: algebraic types, absence of classes, flow expressed as composition.

### Event-driven (asynchronous)
- **Characteristics**: queues / topics, decoupled handlers, absence of linear flow, eventual consistency, explicit idempotency.
- **Examples in the legacy system**: modern queue-oriented Node backends, SQS / Kafka-heavy systems, asynchronous microservices.
- **Signals in `aegis/`**: events in domain model, queue-based integrations, long-running processes with retry.

### Actor model
- **Characteristics**: isolated actors with mailbox, supervision, state isolation.
- **Examples in the legacy system**: Erlang / Elixir / OTP, Akka.
- **Signals in `aegis/`**: supervised processes, messages between actors.

### Dataflow
- **Characteristics**: declarative pipelines, transformations in flow, absence of imperative loops in the domain.
- **Examples in the legacy system**: classic ETLs, Spark, Flink.
- **Signals in `aegis/`**: DAG description, staged transformations.

## Stack → natural paradigm mapping

| Target stack | Natural paradigm | Viable alternatives | Notes |
|---|---|---|---|
| Node.js 20 (Fastify, Express, NestJS) | asynchronous event-driven | OO with DI (NestJS), light functional | async-first runtime; heavy CPU blocking goes to worker threads |
| Go (net/http, Echo, Fiber) | CSP / goroutines (light event-driven) | structured procedural | concurrency via channels; OO simulated via interfaces |
| Rust (axum, Actix, tokio) | ownership / functional async | event-driven | immutability by default, safety through types |
| Elixir / Phoenix | actor model (BEAM) | functional | supervision via OTP |
| Python modern (FastAPI, Django 5) | OO with DI or rich procedural | event-driven (Celery, asyncio) | choice depends on the framework |
| Kotlin (Spring Boot, Ktor) | OO with DI | event-driven (Reactor) | coroutines enable ergonomic async |
| .NET 8 (ASP.NET Core, Minimal API) | OO with DI | event-driven (Channels, MediatR) | OO tradition + first-class async |
| Java modern (Spring Boot 3, Quarkus) | OO with DI | event-driven (Project Reactor) | functional libraries possible but not dominant |
| Ruby modern (Rails 7, Hanami) | classic OO (Rails) or OO with DI (Hanami) | light functional (dry-rb) | Rails dictates Active Record; Hanami is DI-heavy |
| TypeScript serverless (AWS Lambda, Cloudflare Workers) | event-driven | functional | event invocation; cold start influences design |

## Typical gap table by pair

| From → To | Main gap | Concrete implications |
|---|---|---|
| procedural → event-driven | synchrony → asynchrony | response is no longer immediate; error handling becomes retry/DLQ; idempotency becomes mandatory; event order starts to matter |
| procedural → OO with DI | data as dict → aggregates | invariants move inside aggregates; logic stops living in controllers; dependencies go through interfaces |
| procedural → functional | open side effects → pure + isolated | mutability becomes the exception; composition replaces sequence; algebraic types for states |
| classic OO → event-driven | synchronous flow → choreography | actions stop being atomic; distributed transactions become sagas; strong consistency → eventual |
| classic OO → OO with DI | inheritance → composition via interfaces | Active Record disappears; persistence becomes repository-based; tests gain natural mocks |
| classic OO → functional | mutable encapsulation → immutability | effectful methods become pure functions + explicit updates; state expressed as a sequence of transformations |
| OO with DI → event-driven | synchronous command → event | return is no longer immediate; orchestration becomes choreography; order by key |
| OO with DI → functional | mocks → testable composition | DI stops being interface-based and becomes function-argument-based |
| functional → event-driven | synchronous composition → messaging | latency increases; failure becomes a message in DLQ; distributed state |
| event-driven → synchronous procedural | unnatural; only makes sense for small systems | collapse handlers into direct calls; loss of decoupling; strong consistency returns |
| dataflow → event-driven | declarative DAG → mutable choreography | control becomes less predictable; order must be guaranteed by key |
| actor model → OO with DI | actor messages → synchronous calls | loss of failure isolation; supervision must become try/catch or orchestrated retry |
