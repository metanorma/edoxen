# TODO.meeting-agenda — index

The work to land a canonical Meeting + Agenda + AgendaItem model
linkable to Resolutions/Decisions across `edoxen` and `edoxen-model`.

## Phases

| # | File | Priority | Status |
|---|---|---|---|
| 1 | [01-design-decisions.md](01-design-decisions.md) | P0 | done |
| 2 | [02-lutaml-canonical.md](02-lutaml-canonical.md) | P0 | pending |
| 3 | [03-ruby-models.md](03-ruby-models.md) | P0 | pending |
| 4 | [04-schema.md](04-schema.md) | P0 | pending |
| 5 | [05-fixtures.md](05-fixtures.md) | P0 | pending |
| 6 | [06-specs.md](06-specs.md) | P0 | pending |
| 7 | [07-cli.md](07-cli.md) | P1 | pending |
| 8 | [08-docs.md](08-docs.md) | P1 | pending |
| 9 | [09-verify-and-release.md](09-verify-and-release.md) | P0 | pending |
| 10 | [10-future-enhancements.md](10-future-enhancements.md) | P2 | documented |

## Execution order

Phases 2 → 9 are executed in order. Phase 10 documents known-future-
work only.

## Branches

- `edoxen/edoxen-model` ← `feat/meeting-agenda-model` (Phase 2)
- `edoxen/edoxen` ← `feat/meeting-agenda-model` (Phases 3–8)
- Phase 9 merges both, then releases `edoxen` as a minor bump.
