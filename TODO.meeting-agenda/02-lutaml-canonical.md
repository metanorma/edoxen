# Phase 2 — Canonical LUTAML in edoxen-model

Priority: **P0**

## Goal

Land the canonical LutaML UML definitions in
`/Users/mulgogi/src/mn/edoxen-model/models/`. The Ruby gem mirrors
these files 1:1.

## Deliverables — one `.lutaml` per concept

### Top-level

- `meeting_collection.lutaml` — top-level wrapper.
- `meeting.lutaml` — the event class.
- `meeting_localization.lutaml` — per-language content.
- `meeting_relation.lutaml` — cross-meeting link.

### Sub-structures

- `agenda.lutaml`
- `agenda_item.lutaml`
- `schedule_item.lutaml`
- `deadline.lutaml`
- `date_range.lutaml`
- `location.lutaml`
- `person.lutaml`
- `host_ref.lutaml`
- `reference.lutaml`

### Enums (one per file, mirroring existing convention)

- `meeting_type.lutaml`
- `meeting_status.lutaml`
- `agenda_status.lutaml`
- `agenda_item_kind.lutaml`
- `agenda_item_outcome.lutaml`
- `host_type.lutaml`
- `meeting_relation_type.lutaml`
- `source_url_kind.lutaml`

### Removed

- `meeting-model.adoc` — superseded; the LUTAML files are now
  authoritative. Move to `meeting-model.adoc.deprecated` rather than
  delete (history preservation).

## Attribute shape per class

(See Phase 1 for the canonical field list. Each `.lutaml` declares
attributes exactly matching the Ruby model in Phase 3 — types are
LUTAML notation, wire names are snake_case per D7.)

## Acceptance criteria

- [ ] 21 new `.lutaml` files in `models/`.
- [ ] `README.adoc` updated: new "Meeting model" section, file index
      extended.
- [ ] Old `meeting-model.adoc` renamed to `.deprecated`.
- [ ] Commit + PR to `edoxen/edoxen-model`.
