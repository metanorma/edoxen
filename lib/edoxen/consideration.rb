# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"

module Edoxen
  class Consideration < Lutaml::Model::Serializable
    CONSIDERATION_TYPE_ENUM = %w[
      acknowledging basing considering identifying noting recalling recognises according following
      recognising recognizing
    ].freeze

    attribute :type, :string, values: CONSIDERATION_TYPE_ENUM
    attribute :dates, ResolutionDate, collection: true
    attribute :message, :string
    attribute :subject, :string

    key_value do
      map "type", to: :type
      map "dates", to: :dates
      map "message", to: :message
      map "subject", to: :subject
    end
  end
end
