# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"

module Edoxen
  class Action < Lutaml::Model::Serializable
    ACTION_TYPE_ENUM = %w[
      accepts acknowledges adoption adopts agrees allocates appoints appreciates
      appreciation approves asks assigns chairs communicating confirms consults considers
      creates decides defines delegates delivering directs disbands drafting elects
      empowers encourages endorses estabilishes establishes gathering identifies
      instructs investigates notes notifies recognises nominates
      recognizes recommends registers regrets request requests resolves restates reminds replaces
      scopes secures sends supports thanks welcomes withdraws
    ].freeze

    attribute :type, :string, values: ACTION_TYPE_ENUM
    attribute :dates, ResolutionDate, collection: true
    attribute :message, :string
    attribute :subject, :string
    attribute :degree, :string

    key_value do
      map "type", to: :type
      map "message", to: :message
      map "subject", to: :subject
      map "degree", to: :degree
      map "dates", to: :dates
    end
  end
end
