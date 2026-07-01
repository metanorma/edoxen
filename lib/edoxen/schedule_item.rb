# frozen_string_literal: true

module Edoxen
  # One entry in a meeting timetable. Structural fields (date, time,
  # room) are language-agnostic; descriptive fields (event,
  # description) live here as plain strings in v1 — see
  # TODO.meeting-agenda/10-future-enhancements.md P2.1 for per-item
  # localization.
  class ScheduleItem < Lutaml::Model::Serializable
    attribute :date, :date
    attribute :time, :string
    attribute :event, :string
    attribute :description, :string
    attribute :room, :string
  end
end
