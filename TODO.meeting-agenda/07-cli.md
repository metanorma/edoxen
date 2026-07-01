# Phase 7 — CLI integration

Priority: **P1**

## Goal

Add `validate-meetings` and `normalize-meetings` subcommands. Reuse
the existing `Edoxen::Cli::Batch` deep module — no scaffold
duplication.

## Deliverables

- `lib/edoxen/cli.rb` — two new subcommands:

```ruby
desc "validate-meetings YAML_FILE_PATTERN",
     "Validate Meeting/Agenda YAML file(s) against schema/meeting.yaml."

def validate_meetings(pattern)
  validator = SchemaValidator.new(meeting_schema_path)
  Batch.run(self, pattern, header: "🔍 Validating meetings") do |file|
    errors = validator.validate_file(file) + collect_meeting_model_errors(file)
    errors.empty? ? Batch::Result.ok("VALID") : Batch::Result.bad(errors.map(&:to_clickable_format))
  end
end

desc "normalize-meetings YAML_FILE_PATTERN",
     "Round-trip Meeting YAML file(s) through the model (--output DIR | --inplace)."

option :output, type: :string
option :inplace, type: :boolean

def normalize_meetings(pattern)
  # Same shape as normalize — uses Batch.run
end
```

- `lib/edoxen/cli.rb` private: `meeting_schema_path`,
  `collect_meeting_model_errors`.

## Why separate subcommands

- Different root schema, different model parser.
- `validate` (existing) is for ResolutionCollection; backward
  compatibility preserved.
- Future: a `validate-all` that auto-detects via `oneOf` if needed.

## Acceptance criteria

- [ ] `edoxen validate-meetings PATTERN` exits 0 on valid fixtures.
- [ ] `edoxen validate-meetings PATTERN` exits non-zero + lists
      errors on invalid input.
- [ ] `edoxen normalize-meetings PATTERN --output DIR` round-trips.
- [ ] Existing `validate` and `normalize` (for Resolutions) unchanged.
- [ ] `edoxen help` lists both pairs of commands.
