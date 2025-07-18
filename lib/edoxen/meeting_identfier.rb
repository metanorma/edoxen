# frozen_string_literal: true

# MeetingIdentifier {
#   venue: String
#   date: DateTime
# }
require "lutaml/model"

module Edoxen
  class MeetingIdentifier < Lutaml::Model::Serializable
    attribute :venue, :string
    attribute :date, :date

    key_value do
      map "venue", to: :venue
      map "date", to: :date
    end
  end
end
