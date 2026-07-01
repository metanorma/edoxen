# frozen_string_literal: true

module Edoxen
  # Per-language content for a ScheduleItem. Mirrors the glossarist
  # LocalizedConcept pattern: structural fields (date, time, room) live
  # on the parent ScheduleItem; per-language content (event name,
  # description) lives here.
  class ScheduleItemLocalization < Lutaml::Model::Serializable
    attribute :language_code, :string
    attribute :script, :string
    attribute :event, :string
    attribute :description, :string

    key_value do
      map "language_code", to: :language_code
      map "script", to: :script
      map "event", to: :event
      map "description", to: :description
    end
  end
end
