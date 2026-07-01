# frozen_string_literal: true

module Edoxen
  # One attendance record per person. Mirrors the ParticipationStatus
  # enum from edoxen-model/models/participation_status.lutaml.
  # Optional `affiliation` and `notes` fields let callers annotate
  # proxy representatives and any meeting-specific details.
  class Attendance < Lutaml::Model::Serializable
    attribute :person, Person
    attribute :status, :string, values: Enums::PARTICIPATION_STATUS
    attribute :affiliation, :string
    attribute :proxy_for, Person
    attribute :notes, :string

    key_value do
      map "person", to: :person
      map "status", to: :status
      map "affiliation", to: :affiliation
      map "proxy_for", to: :proxy_for
      map "notes", to: :notes
    end
  end
end
