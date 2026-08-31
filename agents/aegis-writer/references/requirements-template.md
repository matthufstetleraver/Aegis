# [Unit Name]

> Template for the `requirements.md` file. Focuses on WHAT the unit does, not how.

## Overview
[What it is, what problem it solves, 2 to 3 lines]

## Responsibilities
- [Responsibility 1]
- [Responsibility 2]

## Business Rules
- [Rule 1] 🟢
- [Rule 2] 🟡
- [Unknown behavior] 🔴

## Functional Requirements

| ID | Requirement | Priority | Acceptance Criterion |
|----|-----------|-----------|-------------------|
| RF-01 | [Description] | Must | [How to validate] |
| RF-02 | [Description] | Should | [How to validate] |

## Non-Functional Requirements

| Type | Inferred requirement | Code evidence | Confidence |
|------|--------------------|---------------------|-----------|
| Performance | [e.g. 30s timeout on external calls] | `caminho/arquivo.ext:linha` | 🟢 |
| Security | [e.g. authentication required on the route] | `caminho/arquivo.ext:linha` | 🟡 |
| Scalability | [e.g. Redis cache usage] | `caminho/arquivo.ext:linha` | 🟢 |
| Availability | [e.g. automatic retry on failure] | `caminho/arquivo.ext:linha` | 🟡 |

> Inferred from the code. Validate with the operations team.

## Acceptance Criteria

```gherkin
Given [precondition]
When [action]
Then [expected result]

Given [error condition]
When [invalid action]
Then [expected failure behavior]
```

## Priority (MoSCoW)

| Requirement | MoSCoW | Justification |
|-----------|--------|---------------|
| [Main responsibility] | Must | Critical path, called in every flow |
| [Core business rule] | Must | Business rule with no fallback |
| [Secondary functionality] | Should | Important but with alternative |
| [Edge case] | Could | Rarely triggered |

> Priority inferred from call frequency and position in the dependency chain.

## Code Traceability

| File | Function / Class | Coverage |
|---------|-----------------|-----------|
| `caminho/arquivo.ext` | `NomeDaClasse` | 🟢 |
