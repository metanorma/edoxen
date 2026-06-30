# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this gem is

`edoxen` is an information model for formal resolutions and decisions
(ISO/TC 154, CIPM, OIML, etc.). It provides:

- A set of `Lutaml::Model::Serializable` subclasses that mirror the canonical
  LutaML UML model in `../edoxen-model/models/*.lutaml`.
- A JSON-Schema (`schema/edoxen.yaml`) used to validate real-world YAML
  files via `SchemaValidator` (`json_schemer`).
- A Thor CLI (`edoxen validate`, `edoxen normalize`) that wraps both the
  schema validator and the Ruby model parser.

## Architecture

### Loading

`lib/edoxen.rb` configures `Lutaml::Model::Config` and `autoload`s every
constant defined under `Edoxen::...` from its native file. **No
`require_relative` is used anywhere in this gem.** Cross-references between
model classes resolve through Ruby autoload (works for circular references
because autoload is lazy).

If you add a new model class under `lib/edoxen/<name>.rb`, register one
autoload entry in `lib/edoxen.rb`. The namespace is flat under `Edoxen::`,
matching the LUTAML naming.

### Three sources of truth that must stay in sync

There are three descriptions of the same data, and they must agree:

1. **`lib/edoxen/*.rb`** — Ruby model. Attribute declarations + `key_value`
   `map` blocks drive (de)serialization. The model is permissive about
   field names and tolerant of unknown fields (lutaml-model drops them
   silently) — the schema is the strict source.
2. **`schema/edoxen.yaml`** — JSON-Schema (draft-07). Used by
   `SchemaValidator`. Adds `additionalProperties: false`, `required`,
   `enum`, `pattern`, and `minItems` constraints the model does not.
3. **`spec/fixtures/*.yaml`** — real-world samples. Must validate against
   the schema AND round-trip through the Ruby model.

When you change one, change all three in the same PR. The
`spec/edoxen/schema_enum_sync_spec.rb` enforces the schema ↔ Ruby enum
boundary at runtime.

### Enum single source of truth

`lib/edoxen/enums.rb` is the authoritative list for every enum used by
the gem (`ACTION_TYPE`, `CONSIDERATION_TYPE`, `RESOLUTION_TYPE`,
`RESOLUTION_RELATION_TYPE`, `RESOLUTION_DATE_TYPE`, `APPROVAL_TYPE`,
`APPROVAL_DEGREE`, `URL_KIND`). Both the Ruby model
(`attribute :type, :string, values: Enums::ACTION_TYPE`) and the
`schema/edoxen.yaml` `$defs/<EnumName>` block reference these constants.

`schema_enum_sync_spec.rb` loads both, walks `$defs` for enum-typed
definitions, and asserts each value-list matches the corresponding
`Edoxen::Enums::*` array.

If you add a value (e.g. a new verb), add it to the Ruby constant AND
the schema enum block in the same commit.

### Glossarist-style localization pattern

Per-language content lives inside `Resolution#localizations[]` (one
`Localization` per language). `Localization` carries `language_code`
(ISO 639-3) and `script` (ISO 15924), plus `title`, `subject`, `message`,
`considering`, `considerations`, `actions`, `approvals`.

Language-agnostic admin fields (`identifier`, `doi`, `urn`,
`agenda_item`, `dates`, `categories`, `meeting`, `relations`, `urls`)
live on the parent `Resolution`.

`Metadata#title_localized` and `Metadata#source_urls` mirror this
pattern for collection-level metadata.

### LUTAML fidelity + LUTAML quirks

The Ruby model is faithful to the LUTAML files. Two LUTAML quirks
that propagate:

- `empowers` is in both `ConsiderationType` and `ActionType` (upstream
  duplication). `enums_spec.rb` documents this with an explicit test.
- LUTAML uses `camelCase` attribute names (e.g. `agendaItem`). Wire names
  in this gem are `snake_case` (`agenda_item`) for YAML convention;
  `dateEffective` becomes `date_effective`. This is a deliberate
  one-way mapping from the LUTAML notation; the LUTAML files remain
  authoritative for the semantic model.

### SchemaValidator

`lib/edoxen/schema_validator.rb` is intentionally small:

- `Edoxen::ValidationError` (defined in `lib/edoxen/error.rb`) — the unified
  validation shape. `SchemaValidator::ValidationError` is a back-compat
  alias. Carries `file`, `line`, `column`, `pointer`, `message_text`, and
  `source` (`:schema` / `:model` / `:syntax`) so renderers can branch on
  failure origin. Rendered as `file:line:col: msg at \`/pointer\``.
- `#validate_file(path)` → `Array<Edoxen::ValidationError>`.
- `#validate_content(content, path)` → `Array<Edoxen::ValidationError>`.
- `SchemaValidator::LineMap` — builds an indent-heuristic
  `{json_pointer => line_no}` map and resolves a JSON-Schema data
  pointer to a line via longest-prefix match. **No path-shape
  hardcoding.** Adding new collection paths never requires touching this.
- Date coercion (`normalize_dates`) converts `Date` / `Time` instances
  back to ISO strings before handing data to `json_schemer` because the
  schema declares them as `type: string, format: date`.

### CLI

`Edoxen::Cli` (Thor) lives in `lib/edoxen/cli.rb`. Two commands:

- `validate PATTERN` — glob-expands YAML files and runs both
  `SchemaValidator#validate_file` and `Collection.from_yaml`. The dual
  check is intentional: the schema catches `additionalProperties` /
  `enum` / `required` / `pattern` violations that the model silently
  drops, and the model catches structural issues json_schemer can't
  express (numeric/date coercion, missing nested classes).
- `normalize PATTERN (--output DIR | --inplace)` — round-trips each
  YAML file through `ResolutionCollection.from_yaml` and writes the
  result back. Preserves any `# yaml-language-server: $schema=...`
  directive in the first 5 lines.

Both commands delegate their expand/sort/empty/header/loop/tally/summary/exit
scaffold to `Edoxen::Cli::Batch` — the deep module behind the seam. The
command bodies are per-file blocks returning `Batch::Result.ok(msg)` or
`Batch::Result.bad(errors)`. Adding a third command (e.g. `lint`, `diff`)
is one block.

`Resolution#in_language(code, fallback:)` and `Resolution#primary_localization`
provide the canonical lookup interface — callers should not iterate
`localizations.find { |l| l.language_code == code }` directly.

Exit code is non-zero if any file fails.

## Build, test, lint

```bash
bundle install                  # first-time setup
bundle exec rspec               # full test suite
bundle exec rspec spec/edoxen/schema_validator_spec.rb
bundle exec rspec spec/edoxen/enums_spec.rb
bundle exec rspec spec/edoxen/resolution_spec.rb:32      # one example by line
bundle exec rubocop             # lint (line length 120, double-quoted strings)
bundle exec rake                # default: spec + rubocop
bundle exec exe/edoxen validate "spec/fixtures/*.yaml"
mkdir -p /tmp/out && bundle exec exe/edoxen normalize "spec/fixtures/*.yaml" --output /tmp/out
```

## Conventions specific to this gem

- **No `double()` in specs** — use real `Edoxen::*` instances and fixture files.
- **Serialization is framework-only.** Never hand-roll `to_h` / `from_h` /
  `to_yaml` / `from_yaml` / `to_json` / `from_json` on a model class. Declare
  `attribute` only — lutaml-model auto-emits an identity map for each
  attribute when no `key_value` block is present. Add a `key_value do … end`
  block with `map "wire_name", to: :attr` only when the wire name differs
  from the attribute name.
- **Wire names are `snake_case`.** Even when the LUTAML notation uses
  camelCase, the YAML wire form is `snake_case` (`agenda_item`, not
  `agendaItem`). The attribute name on the Ruby side is also `snake_case`,
  and the wire name defaults to it.
- **Enums on the model and the schema must agree.** When you add or remove
  a value to `Enums::*`, also update the matching `enum:` list in
  `schema/edoxen.yaml` $defs. The `schema_enum_sync_spec` will catch any
  drift.
- **Fixtures are load-bearing.** `spec/fixtures/{ciml,cipm,isotc154,...}.yaml`
  are real-world extracts. If a model change invalidates them, that's a
  signal to either (a) update the fixture in the same PR, or (b)
  reconsider the model change. Do not leave them broken.
- **No backwards-compat shims on `Resolution`.** The flat `#title`,
  `#subject`, `#considerations`, `#approvals`, `#actions` form is gone.
  Always go through `localizations[]`.
- **Branch discipline.** Never commit to `main`, never push tags, all
  changes via PR. See the global rules.
- **No AI attribution** in commits, PRs, or code comments.

## Source hygiene — do not violate

- Never hand-roll `to_h` / `from_h` / `to_yaml` / `to_json` on a model.
- Never use `send` to call private methods.
- Never use `instance_variable_set` or `instance_variable_get` to cross
  another object's boundary.
- Never use `respond_to?` for type checking — design so the type
  hierarchy makes the check unnecessary, or use `is_a?`.
- Never use `require_relative` in library code. Use the autoload entries
  in `lib/edoxen.rb`.

## Adding a new model class (the OCP test)

When you introduce a new concept (e.g. `Subject`):

1. Add `lib/edoxen/subject.rb` declaring
   `class Subject < Lutaml::Model::Serializable` with attributes and
   `key_value do … end` mapping.
2. Add one autoload line in `lib/edoxen.rb`.
3. Add a `$defs/Subject` block in `schema/edoxen.yaml` and reference
   it from any parent that uses it.
4. Add `spec/edoxen/subject_spec.rb` covering round-trip for every
   field, every enum value, real-instance construction, no doubles.
5. Add a fixture or update an existing one to exercise the new model.
6. Run `bundle exec rspec` (full suite passes including
   `schema_enum_sync_spec`) and `bundle exec rubocop`.

No existing class requires modification. The library grows only by
extension.

## Adding a new CLI subcommand

1. Add a `desc "name ARGS", "Description"` block in `lib/edoxen/cli.rb`
   followed by a method. The CLI is intentionally a thin glue layer;
   put logic in a model or service class and call it from the command.
2. Add `spec/edoxen/cli_spec.rb` integration-style coverage that spawns
   the real `exe/edoxen` process via `Open3.capture3` and asserts on
   stdout/stderr/exit code. Don't shell out to a mocked binary — the
   CLI is exercised as an end-to-end contract.
3. Update the README's "Command-line interface" section.

## Audit checklist — run before approving any contribution

1. `bundle exec rspec` passes (currently 136 / 0).
2. `bundle exec exe/edoxen validate spec/fixtures/*.yaml` is clean
   (currently 4 / 0).
3. `bundle exec exe/edoxen normalize --output /tmp/out` round-trips
   every fixture without data loss (re-parse and assert equality).
4. Schema and Ruby model agree on: field names, enum values,
   required vs. optional, collection vs. scalar, `additionalProperties: false`.
5. No new hand-rolled `to_h` / `from_h` on a model class.
6. No new `LineMap`-style hardcoded path-shape branches.
7. README example YAML parses against the schema (currently three
   real-world fixtures do).
8. `bundle exec rubocop` clean (target Ruby ≥ 3.0, line length 120).
