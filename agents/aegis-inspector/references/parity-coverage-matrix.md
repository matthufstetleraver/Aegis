# Parity coverage matrix

Reference table for defining the minimum set of `.feature` scenarios per flow, according to the paradigm transition.

## Coverage by transition

| Transition | Minimum scenarios per flow |
|---|---|
| no change | `@paridade` (input → expected output) |
| procedural → OO | `@paridade` + `@invariante` (aggregate invariant validated) |
| procedural → event-driven | `@paridade` + `@idempotencia` + `@ordem` + `@dlq` (behavior under queue failure) |
| classic OO → OO with DI | `@paridade` + `@composicao` (no Active Record dependency) |
| classic OO → event-driven | `@paridade` + `@idempotencia` + `@ordem` + `@saga` (compensation on failure) |
| classic OO → functional | `@paridade` + `@imutabilidade` + `@composicao` |
| OO with DI → event-driven | `@paridade` + `@idempotencia` + `@ordem` |
| functional → event-driven | `@paridade` + `@idempotencia` + `@ordem` |
| any → actor model | `@paridade` + `@supervisao` (recovery after failure) |

## Standard tags

- `@paridade`: always present; main equivalence.
- `@critico`: critical flow (regulatory, financial, sensitive data).
- `@regulatorio`: when there is a formal external requirement.
- `@idempotencia`: reprocessing does not duplicate the effect.
- `@ordem`: order by key is respected.
- `@dlq`: behavior when it reaches the dead letter queue.
- `@saga`: compensation in a distributed transaction.
- `@invariante`: aggregate invariant validated.
- `@composicao`: equivalent behavior under functional composition.
- `@imutabilidade`: there is no shared mutation.
- `@supervisao`: supervisor recovers failed actor.

## Typical "accepted parity" criteria

| System type | Primary metric |
|---|---|
| Web app without strong regulation | functional divergence < 1% for 7 days |
| Public API | functional divergence < 0.1% for 30 days + zero divergence in public contracts |
| Tax / regulatory system | functional divergence < 0.01% for 60 days + zero divergence in regulated fields |
| Financial system | financial divergence by monetary value < 0.001% + zero divergence in totals |
| Internal low-criticality system | functional divergence < 5% for 7 days |

## Reuse of characterization_specs

When `aegis/characterization_specs/` exists:

1. For each spec → derive the corresponding `.feature`, adapting inputs/outputs to the new system.
2. Keep the original `spec-id` in traceability.
3. Add extra scenarios according to the "Minimum scenarios per flow" table.

When it does not exist:

1. Infer critical flows from `code-analysis.md` + `sequences/` + `BR-MIGRAR` rules marked as critical.
2. Document the gap in `parity_specs.md § Reuse of characterization_specs`.
