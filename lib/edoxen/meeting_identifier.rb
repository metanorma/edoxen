# frozen_string_literal: true

module Edoxen
  # Identifier of a meeting (venue + date). Singular — the meeting a
  # particular Resolution belongs to.
  class MeetingIdentifier < Lutaml::Model::Serializable
    attribute :venue, :string
    attribute :date, :date

    key_value do
      map "venue", to: :venue
      map "date", to: :date
    end
  end
end
