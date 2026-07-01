# Phase 3 — Ruby model mirror in edoxen

Priority: **P0**

## Goal

One Ruby class per LUTAML file. autoload entries in `lib/edoxen.rb`.
No `require_relative` in library code. No `send` to private, no
`instance_variable_set`/`get`, no `respond_to?` for typing.

## Deliverables — `lib/edoxen/*.rb`

### New files

- `meeting_collection.rb` — top-level wrapper.
- `meeting.rb` — the event class.
- `meeting_localization.rb`
- `meeting_relation.rb`
- `agenda.rb`
- `agenda_item.rb`
- `schedule_item.rb`
- `deadline.rb`
- `date_range.rb`
- `location.rb`
- `person.rb`
- `host_ref.rb`
- `reference.rb`

### Modified files

- `lib/edoxen.rb` — add 13 autoload entries.
- `lib/edoxen/enums.rb` — add 8 new enum constants.
- `lib/edoxen/resolution_metadata.rb` — add `meeting_urn: String`
  field (back-reference to a Meeting).
- `lib/edoxen/source_url.rb` — add optional `kind: String, values:
  Enums::SOURCE_URL_KIND` field (orthogonal addition; existing
  fixtures without it still parse).

### Class shape

Each class is `Lutaml::Model::Serializable` with:

- `attribute :name, Type, **opts` declarations only.
- No explicit `key_value do; map ...; end` block — lutaml-model
  auto-emits identity maps (established in v0.3.1 refactor).
- Enum-typed attributes use `values: Enums::FOO`.
- Convenience accessors added where the lookup is non-trivial
  (parallel to `Resolution#in_language`).

### Convenience accessors

- `Meeting#in_language(code, fallback: false)` — exact-match lookup
  on `localizations`.
- `Meeting#primary_localization` — English-or-first.
- `Meeting#find_agenda_item(label)` — by label string.
- `MeetingCollection#find_by_urn(urn)` — URN lookup.
- `MeetingCollection#find_by_identifier(prefix:, number:)` —
  structured-identifier lookup.

### Invariants

- `Meeting.identifier` is `StructuredIdentifier[1..*]` (required by
  schema; permissive in model).
- `Meeting.localizations[*].language_code` matches `^[a-z]{3}$`
  (schema-enforced).
- `Meeting.date_range` is a `DateRange` with optional `start`/`end`.

## Acceptance criteria

- [ ] 13 new Ruby files, each ≤40 lines.
- [ ] No `require_relative` in any new file.
- [ ] `bundle exec rspec` passes (existing 197 examples).
- [ ] `bundle exec rubocop` clean.
