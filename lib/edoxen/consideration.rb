# frozen_string_literal: true

module Edoxen
  # Basis for a resolution: a verb (having, noting, considering, ...) plus
  # one effective date and the elaborated reasoning.
  class Consideration < Lutaml::Model::Serializable
    attribute :type, :string, values: Enums::CONSIDERATION_TYPE
    attribute :date_effective, ResolutionDate
    attribute :message, :string
  end
end
