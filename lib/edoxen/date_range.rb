# frozen_string_literal: true

module Edoxen
  # Start + end pair for multi-day meetings. Both endpoints are Date.
  # Either may be nil for one-sided ranges (theoretically), though the
  # schema enforces both required when DateRange is present.
  class DateRange < Lutaml::Model::Serializable
    attribute :start, :date
    attribute :end, :date
  end
end
