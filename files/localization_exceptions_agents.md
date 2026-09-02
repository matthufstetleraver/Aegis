# Agents Scan Exceptions

These items were encountered during the agents-only scan but are **intentional** and not untranslated Portuguese prose.

| Path | Reason |
|---|---|
| `agents/aegis-designer/references/templates/data_migration_plan.md` | Remaining scanner match is the legacy token `legado` inside a preserved schema example. Visible content is English. |
| `agents/aegis-designer/references/templates/target_data_model.md` | Remaining scanner match is the legacy token `legado` inside a preserved schema example. Visible content is English. |
| `test/smoke.sh` | Intentional Portuguese fixture inputs used to validate localized install behavior. |
| `docs/migracao/index.md` | Re-scanned and verified clean; no remaining translation work. |
| `lib/commands/install.js` | Re-scanned and verified clean; no remaining translation work. |
| `lib/commands/drift-check.js` | Re-scanned and verified clean; no remaining translation work. |

## Outcome

The remaining agents-scope hits are scanner noise from preserved legacy tokens. No user-facing Portuguese prose remains in the checked agents files.
