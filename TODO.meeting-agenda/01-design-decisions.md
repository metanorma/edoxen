# Phase 1 — Design decisions

Priority: **P0** (canonical — blocks every later phase)

## Goal

Lock down the conceptual model before any code lands. Every later
phase references these decisions; if they shift, downstream work
reopens.

## Decisions

### D1 — Meeting is the event; Agenda is a document

The previous draft conflated these. Split:

- **Meeting** — the event itself. Identity, time, venue, officers,
  schedule, deadlines, links to Resolutions.
- **Agenda** — the business order document produced for the Meeting.
  Carries items, opening/closing sessions, status (draft/final), and a
  pointer to the source PDF.

A Meeting *has* an Agenda (`Meeting.agenda: Agenda`). An Agenda is
meaningless without a Meeting but may be versioned independently
(draft → final → amended).

### D2 — Schedule ≠ Agenda

- **Schedule** — the time-bound timetable: date, time slot, room,
  event title. Lives on `Meeting.schedule: ScheduleItem[]`.
- **Agenda** — the topic-bound business order: numbered/unnumbered
  items, opening session, closing session. Lives on `Meeting.agenda`.

ISO/TC 154's data already separates these (`schedule[]` and
`agenda.{opening_session, closing_session, wg_meetings}`). Don't
collapse them.

### D3 — Linking to Resolutions is by URN, not embedding

- `Meeting.resolution_refs: String[]` — URNs of resolution
  collections produced by this meeting.
- `ResolutionCollection.metadata.meeting_urn: String` — back-reference.

Rationale: meetings and resolutions have different lifetimes (an
agenda exists weeks before the meeting; resolutions exist only after
adoption). Embedding forces re-serialization of the whole meeting when
one resolution is amended. URN linking matches how both repos already
work (ISO: `_data/events/` separate from `_data/resolutions/`; OIML:
the metadata block of a ResolutionCollection already comments its
meeting URN).

### D4 — Localization parallels the Resolution pattern

`Meeting.localizations: MeetingLocalization[]` carries per-language
`title`, `general_area`, `practical_info`. ISO 639-3 + ISO 15924,
identical to `Localization` for Resolutions.

The schedule itself stays language-agnostic at the structural level
(date, time, room); localized `event` and `description` text live
inside `MeetingLocalization`. **v1 decision:** keep schedule
monolingual on `ScheduleItem` (event/description as plain strings)
and only localize at the Meeting level. If a future caller needs
per-schedule-item localization, add `ScheduleItemLocalization`
then — don't pre-bake it.

### D5 — Reuse existing edoxen types

| Concept | Reuse |
|---|---|
| Identifier | `StructuredIdentifier` |
| Source URL | `SourceUrl` (extend with optional `kind` in this work) |
| Validation error | `Edoxen::ValidationError` |
| CLI scaffold | `Edoxen::Cli::Batch` |

### D6 — Meeting/Agenda have their own top-level containers

- `MeetingCollection` — top-level wrapper for a YAML containing many
  meetings (parallel to `ResolutionCollection`).
- Single-meeting files are also valid (`Meeting` directly under root,
  detected by `oneOf` in JSON-Schema).

### D7 — Wire-name are snake_case

LUTAML uses camelCase notation; YAML wire is snake_case. Same
convention as the rest of edoxen.

### D8 — All enums closed and synced

New enums land in `Edoxen::Enums` and the schema's `$defs/<EnumName>`
blocks. Both `schema_enum_sync_spec` and `schema_model_sync_spec`
extend to cover them.

## Type inventory (MECE check)

| Concept | Owns |
|---|---|
| `Meeting` | the event (identity, time, venue, officers, agenda, schedule) |
| `MeetingLocalization` | per-language content for a Meeting |
| `MeetingCollection` | top-level wrapper for many Meetings |
| `MeetingRelation` | directed link between two Meetings |
| `Agenda` | the business order document |
| `AgendaItem` | one entry on an Agenda |
| `Location` | venue geography |
| `Person` | identity + contact + affiliation |
| `HostRef` | typed reference to an organization |
| `ScheduleItem` | one entry in the timetable |
| `Deadline` | a time-bound requirement |
| `DateRange` | start + end pair |
| `Reference` | generic document reference (used by AgendaItem) |

13 new classes. No overlaps.

## Enums

| Enum | Values |
|---|---|
| `MEETING_TYPE` | plenary, working_group, task_group, ad_hoc, joint, conference_session |
| `MEETING_STATUS` | upcoming, completed, cancelled |
| `AGENDA_STATUS` | draft, final, amended, cancelled, superseded |
| `AGENDA_ITEM_KIND` | numbered, unnumbered, header, opening, closing |
| `AGENDA_ITEM_OUTCOME` | discussed, resolved, deferred, adopted, withdrawn |
| `HOST_TYPE` | national_body, liaison, associate, organizer |
| `MEETING_RELATION_TYPE` | continues_from, continues_to, joint_with, supersedes, supersedes_by, rescheduled_from, rescheduled_to |
| `SOURCE_URL_KIND` | agenda_pdf, minutes_pdf, resolutions_pdf, report_pdf, register_url, landing_page |

8 new enums.

## Acceptance criteria

- [x] D1–D8 written
- [x] Type inventory listed
- [x] Enum inventory listed
