# Aegis Spec

> Aegis Spec engineering framework installed in this project.

## How to use

Type `/aegis` to activate Aegis Spec and start or resume the project analysis.

## Activation behavior

When the user types `/aegis` or the word `aegis` by itself in a message:

1. Activate the `aegis` skill available in `aegis/skills/aegis/SKILL.md`
2. If it is not found in `aegis/skills/`, try `aegis/skills/aegis/SKILL.md`
3. Read the SKILL.md in full and follow the Aegis Spec instructions exactly

## Non-negotiable rule

Never delete, modify, or overwrite pre-existing files from the legacy project.
Aegis Spec writes **only** in `aegis/` and `aegis/`.
