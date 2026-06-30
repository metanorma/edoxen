# frozen_string_literal: true

module Edoxen
  # Verb + one effective date + human-readable message. Used inside a
  # Localization to express the multilingual part of an action.
  class Action < Lutaml::Model::Serializable
    attribute :type, :string, values: Enums::ACTION_TYPE
    attribute :date_effective, ResolutionDate
    attribute :message, :string

    key_value do
      map "type", to: :type
      map "date_effective", to: :date_effective
      map "message", to: :message
    end
  end
end
