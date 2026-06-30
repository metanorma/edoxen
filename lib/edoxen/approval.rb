# frozen_string_literal: true

module Edoxen
  # Approval record: type (affirmative / negative), degree (consensus level),
  # date of the approval event, and a human-readable elaboration.
  class Approval < Lutaml::Model::Serializable
    attribute :type, :string, values: Enums::APPROVAL_TYPE
    attribute :degree, :string, values: Enums::APPROVAL_DEGREE
    attribute :date, ResolutionDate
    attribute :message, :string

    key_value do
      map "type", to: :type
      map "degree", to: :degree
      map "date", to: :date
      map "message", to: :message
    end
  end
end
