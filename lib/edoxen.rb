# frozen_string_literal: true

require "lutaml/model"

# Configure the lutaml-model serialization framework used throughout the
# Edoxen information-model gem.
Lutaml::Model::Config.configure do |c|
  c.yaml_adapter_type = :standard_yaml
  c.json_adapter_type = :standard_json
end

module Edoxen
  # Autoload every constant defined under the Edoxen namespace from its
  # native `lib/edoxen/<name>.rb` file. This is the only place where file
  # paths are tied to constants; everywhere else, models reference each
  # other by class name (resolved lazily by Ruby).
  #
  # There are intentionally NO `require_relative` calls in this gem —
  # autoload keeps load-order semantics clean and lets us tolerate the
  # extensive cross-references between model classes
  # (Resolution <-> Localization, ResolutionMetadata <-> Localization, etc.).
  autoload :VERSION, "edoxen/version"
  autoload :Error, "edoxen/error"
  autoload :ValidationError, "edoxen/error"
  autoload :Enums, "edoxen/enums"
  autoload :ReferenceData, "edoxen/reference_data"

  # Information-model classes (one per file, one concept per class).
  # Names mirror ../edoxen-model/models/*.lutaml.
  autoload :StructuredIdentifier, "edoxen/structured_identifier"
  autoload :MeetingIdentifier, "edoxen/meeting_identifier"
  autoload :ResolutionDate, "edoxen/resolution_date"
  autoload :Action, "edoxen/action"
  autoload :Approval, "edoxen/approval"
  autoload :Consideration, "edoxen/consideration"
  autoload :SourceUrl, "edoxen/source_url"
  autoload :Localization, "edoxen/localization"
  autoload :Url, "edoxen/url"
  autoload :ResolutionRelation, "edoxen/resolution_relation"
  autoload :Resolution, "edoxen/resolution"
  autoload :ResolutionMetadata, "edoxen/resolution_metadata"
  autoload :ResolutionCollection, "edoxen/resolution_collection"

  # Meeting / Agenda side. Mirrors edoxen-model/models/meeting*.lutaml.
  autoload :DateRange, "edoxen/date_range"
  autoload :Location, "edoxen/location"
  autoload :Person, "edoxen/person"
  autoload :HostRef, "edoxen/host_ref"
  autoload :ScheduleItemLocalization, "edoxen/schedule_item_localization"
  autoload :ScheduleItem, "edoxen/schedule_item"
  autoload :Deadline, "edoxen/deadline"
  autoload :Reference, "edoxen/reference"
  autoload :AgendaItem, "edoxen/agenda_item"
  autoload :Agenda, "edoxen/agenda"
  autoload :Attendance, "edoxen/attendance"
  autoload :VoteRecord, "edoxen/vote_record"
  autoload :MeetingRelation, "edoxen/meeting_relation"
  autoload :MeetingLocalization, "edoxen/meeting_localization"
  autoload :Meeting, "edoxen/meeting"
  autoload :MeetingCollectionMetadata, "edoxen/meeting_collection_metadata"
  autoload :MeetingCollection, "edoxen/meeting_collection"

  # Services.
  autoload :SchemaValidator, "edoxen/schema_validator"
  autoload :LinkChecker, "edoxen/link_checker"
  autoload :Cli, "edoxen/cli"
end
