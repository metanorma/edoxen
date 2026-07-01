# Phase 4 — JSON-Schema

Priority: **P0**

## Goal

A separate `schema/meeting.yaml` for Meeting/Agenda validation. The
existing `schema/edoxen.yaml` (Resolutions) is untouched.

## Why a separate schema file

- Resolutions and Meetings are different document types with
  different lifecycles.
- Different CLI subcommands validate each.
- Avoids touching the existing schema (which is referenced by 1,241
  OIML fixtures via `yaml-language-server: $schema=`).

## Deliverables

- `schema/meeting.yaml` — full JSON-Schema (draft-07).
  - Root: `oneOf` — `MeetingCollection` OR `Meeting`.
  - `$defs` for every class + every enum.
  - `additionalProperties: false` everywhere.
  - `required` on identifier + type for Meeting.
  - `pattern` on `language_code` (`^[a-z]{3}$`), `script`
    (`^[A-Z][a-z]{3}$`), `country_code` (`^[A-Z]{2}$`).
  - `minItems: 1` on `Meeting.identifier`.

## Acceptance criteria

- [ ] `schema/meeting.yaml` exists and is valid JSON-Schema draft-07.
- [ ] `Edoxen::SchemaValidator.new("path/to/meeting.yaml")` loads it.
- [ ] All Phase 5 fixtures validate cleanly.
- [ ] All Phase 6 specs (including schema enum sync) pass.
