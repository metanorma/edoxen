# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"

module Edoxen
  class Approval < Lutaml::Model::Serializable
    APPROVAL_TYPE_ENUM = %w[affirmative negative].freeze
    APPROVAL_DEGREE_ENUM = %w[unanimous majority minority].freeze

    attribute :type, :string, values: APPROVAL_TYPE_ENUM
    attribute :degree, :string, values: APPROVAL_DEGREE_ENUM
    attribute :dates, ResolutionDate, collection: true
    attribute :message, :string

    key_value do
      map "type", to: :type
      map "degree", to: :degree
      map "dates", to: :dates
      map "message", to: :message
    end
  end
end
