# Phase 10 — Future enhancements (not in this release)

Priority: **P2**

These are documented as known-future-work; not executed in this pass.
Each one would be its own PR.

## P2.1 — Per-schedule-item localization

`ScheduleItemLocalization` carrying per-language `event` and
`description`. Triggered when a real consumer needs WG meeting titles
in FR alongside EN.

## P2.2 — Meeting series

`MeetingSeries` carrying `{identifier, name, description}` with
`Meeting.series_ref: String` (URN). Triggered when navigation across
ordinals becomes a real use case (ISO/TC 154 plenary history page).

## P2.3 — Contribution model

Replace flat `Person.contributors` with a `Contribution` class
matching the comment in the original draft (`'contributors should
defer to Contribution model`). Triggered when we need to distinguish
"presented" vs "authored" vs "reviewed" contributions per meeting.

## P2.4 — Auto-detect document type in CLI

A single `edoxen validate PATTERN` that auto-detects
ResolutionCollection vs Meeting via JSON-Schema `oneOf`. Triggered
when users complain about remembering two subcommand names.

## P2.5 — Cross-document link validation

A spec/assertion that every `Meeting.resolution_refs[*]` URN has a
matching `ResolutionCollection` somewhere in the data set, and vice
versa. Triggered when broken links cause real bugs.

## P2.6 — Attendance roster

`Meeting.attendance: Attendance[]` carrying per-person attendance
records (present/absent/apologies + affiliation). Triggered when a
consumer needs the full attendance record, not just officers.

## P2.7 — Vote records

`VoteRecord { resolution_ref, person, vote: VoteType }` linked to a
Meeting. Triggered when ballot-by-ballot transparency becomes a
requirement.

## P2.8 — Minutes narrative

A `Minutes` class distinct from `Agenda`, capturing the actual
narrative of what was said (linked Markdown / Asciidoc blocks per
agenda item). Triggered when the OIML `meetings/` directory starts
receiving Bulletin scans.

## P2.9 — federation (multi-body)

A `Federation` or `JointMeeting` class for meetings organized by
multiple bodies (e.g., a JWG with TC 154 + TC 307). Triggered when
real joint-meeting data lands.

## P2.10 — IANA / ISO 3166-1 / ISO 639-3 / ISO 15924 reference data

Built-in lookup tables to validate `country_code`, `language_code`,
`script` against the actual standard. Triggered when typo-rate
becomes painful.

## Acceptance criteria

This file documents intent only; nothing to land in this release.
