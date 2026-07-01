# frozen_string_literal: true

module Edoxen
  # One entry in the meeting timetable. Structural fields (date, time,
  # room) are language-agnostic; per-language content (event name,
  # description) lives in `localizations[]`. Mirrors the glossarist
  # LocalizedConcept pattern.
  class ScheduleItem < Lutaml::Model::Serializable
    attribute :date, :date
    attribute :time, :string
    attribute :event, :string
    attribute :description, :string
    attribute :room, :string
    attribute :localizations, ScheduleItemLocalization, collection: true

    def in_language(code, fallback: false)
      match = localizations&.find { |loc| loc.language_code == code.to_s }
      return match if match

      fallback ? localizations&.first : nil
    end

    def primary_localization
      in_language("eng", fallback: true)
    end
  end
end
