# Phase 9 — Verify, PR, merge, release

Priority: **P0**

## Goal

Land everything via PRs. Verify GHA passes. Merge. Bump edoxen minor
(new feature) and release.

## Branch / PR plan

| Repo | Branch | PRs against |
|---|---|---|
| `metanorma/edoxen-model` | `feat/meeting-agenda-model` | main |
| `metanorma/edoxen` | `feat/meeting-agenda-model` | main |

Order: edoxen-model first (canonical), then edoxen (mirror).

## Verification gates

Per branch, before pushing:

- [ ] `bundle exec rspec` — 0 failures.
- [ ] `bundle exec rubocop` — 0 offenses.
- [ ] `bundle exec exe/edoxen validate-meetings "spec/fixtures/meetings/*.yaml"` — clean.
- [ ] `bundle exec exe/edoxen normalize-meetings --output /tmp/out` — round-trips.
- [ ] No AI attribution in any commit.
- [ ] No TODOs / FIXMEs in committed source.
- [ ] No transient files (.DS_Store, .bak, .swp).

## Post-merge

- [ ] Trigger `gh workflow run release.yml --ref main -f next_version=minor`
      on `metanorma/edoxen`.
- [ ] Confirm new version appears on rubygems.org.
- [ ] Confirm tag `vX.Y.Z` pushed.

## Why minor (not patch)

The new Meeting/Agenda model is an additive feature. No breaking
change to existing Resolution APIs. Semver minor on the 0.x line.
