# Phase 8 — Documentation

Priority: **P1**

## Goal

README + CLAUDE.md reflect the Meeting/Agenda model. The canonical
edoxen-model README documents the new LUTAML files.

## Deliverables — edoxen gem

- `README.adoc`:
  - New "Meeting & Agenda model" section with ASCII tree.
  - Quick-start example showing both Resolution and Meeting parsing.
  - Cross-link to the canonical LUTAML files.
- `CLAUDE.md`:
  - Architecture section mentions `Meeting`, `Agenda`, the meeting
    schema, and the separate CLI subcommands.
  - Audit checklist extended: schema_model_sync_spec covers both
    `schema/edoxen.yaml` and `schema/meeting.yaml`.

## Deliverables — edoxen-model

- `README.adoc`:
  - File index extended with all new `.lutaml` files.
  - New "Meeting model" section explaining the Meeting/Agenda split,
    URN linking to Resolutions, and the localization pattern.
  - Sample meeting YAML mirroring one of the gem's fixtures.

## Acceptance criteria

- [ ] Both READMEs updated.
- [ ] edoxen CLAUDE.md updated.
- [ ] Sample YAML in edoxen-model README would pass
      `edoxen validate-meetings`.
