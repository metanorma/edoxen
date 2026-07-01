# Phase 5 — Fixtures

Priority: **P0** for canonical, **P1** for richer ones.

## Goal

Real-world fixture YAMLs in `spec/fixtures/meetings/` that exercise
every shape the model supports.

## Deliverables

### P0 — required for canonical

- `spec/fixtures/meetings/simple-meeting.yaml` — minimal valid
  Meeting (identifier, type, date_range, one venue, one localization,
  one agenda item).
- `spec/fixtures/meetings/ciml-56-meeting.yaml` — OIML CIML 56th
  meeting: bilingual (EN/FR), structured identifier, source URLs with
  kind, resolution_ref URN linking to a ResolutionCollection.
- `spec/fixtures/meetings/isotc154-plenary-42-meeting.yaml` — ISO/TC
  154 42nd plenary: multi-day date_range, multi-venue, typed hosts,
  full schedule with 9 entries, deadlines, chair/secretary.

### P1 — useful coverage

- `spec/fixtures/meetings/virtual-meeting.yaml` — virtual meeting
  (no venues, country_code empty).
- `spec/fixtures/meetings/multi-collection.yaml` — a
  MeetingCollection wrapping multiple meetings.

## Fixture invariants

- All fixtures MUST validate against `schema/meeting.yaml`.
- All fixtures MUST round-trip through the Ruby model
  (`Meeting.from_yaml(...).to_yaml` re-parses identically).
- Real-world fixtures (ciml-56, isotc154-42) MUST reflect actual
  published data — no fabricated committee names or dates.

## Acceptance criteria

- [ ] At least the three P0 fixtures exist.
- [ ] `bundle exec exe/edoxen validate-meetings "spec/fixtures/meetings/*.yaml"` passes on all of them.
- [ ] Each fixture is referenced by at least one round-trip spec.
