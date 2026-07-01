# Phase 6 — Specs

Priority: **P0**

## Goal

Comprehensive spec coverage. One spec file per new model class, plus
CLI and schema-sync coverage. Real model instances only — no
`double()`.

## Deliverables — `spec/edoxen/meeting_*_spec.rb` (one per class)

For each of the 13 new classes:

- Construction with explicit attrs.
- Round-trip YAML serialization.
- Enum coverage where applicable (one example per enum value).
- Real-instance types (e.g., `Meeting#agenda` returns an `Edoxen::Agenda`).

## Deliverables — additional specs

- `spec/edoxen/meeting_collection_spec.rb` — top-level container,
  round-trips, lookup helpers (`find_by_urn`, `find_by_identifier`).
- `spec/edoxen/meeting_lookup_spec.rb` — `Meeting#in_language`,
  `Meeting#primary_localization`, `Meeting#find_agenda_item`.
- `spec/edoxen/schema_meeting_enum_sync_spec.rb` — every enum in
  `schema/meeting.yaml` `$defs` matches the corresponding
  `Edoxen::Enums::*` frozen array.
- `spec/edoxen/schema_meeting_model_sync_spec.rb` — every Ruby
  Meeting-related class has matching properties/collection flags in
  `schema/meeting.yaml` `$defs`.
- `spec/edoxen/cli_meetings_spec.rb` — `validate-meetings` and
  `normalize-meetings` subcommands, spawned via `Open3.capture3`
  against the new fixtures.
- `spec/edoxen/schema_validator_meeting_spec.rb` — SchemaValidator
  constructed with the meeting schema path; happy path + each error
  type (additionalProperties, required, enum, pattern, type).

## Style rules

- Real model instances only — no `double()`.
- Each example ≤ 10 lines.
- Round-trip examples cover every fixture.

## Acceptance criteria

- [ ] One spec file per new class (13 files).
- [ ] +5 additional specs (collection, lookup, schema enum sync,
      schema model sync, CLI).
- [ ] +1 schema_validator spec for the meeting schema path.
- [ ] `bundle exec rspec` — 0 failures (existing 197 + new ≈ 80+).
- [ ] `bundle exec rubocop` clean.
