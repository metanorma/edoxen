# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"
require_relative "consideration"
require_relative "approval"
require_relative "action"
require_relative "meeting_identifier"
require_relative "resolution_relation"

module Edoxen
  class Resolution < Lutaml::Model::Serializable
    RESOLUTION_TYPE_ENUM = %w[resolution recommendation decision declaration].freeze

    attribute :dates, ResolutionDate, collection: true
    attribute :subject, :string
    attribute :title, :string
    attribute :type, :string, values: RESOLUTION_TYPE_ENUM
    attribute :identifier, :string
    attribute :message, :string
    attribute :considering, :string
    attribute :considerations, Consideration, collection: true
    attribute :approvals, Approval, collection: true
    attribute :actions, Action, collection: true
    attribute :meeting_identifier, MeetingIdentifier
    attribute :relations, ResolutionRelation, collection: true
    attribute :categories, :string, collection: true
    attribute :urls, Url, collection: true

    key_value do
      map "dates", to: :dates
      map "subject", to: :subject
      map "title", to: :title
      map "type", to: :type
      map "identifier", to: :identifier
      map "message", to: :message
      map "considering", to: :considering
      map "considerations", to: :considerations
      map "approvals", to: :approvals
      map "actions", to: :actions
      map "meeting_identifier", to: :meeting_identifier
      map "relations", to: :relations
      map "categories", to: :categories
      map "urls", to: :urls
    end

  end
end
