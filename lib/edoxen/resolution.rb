# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"
require_relative "consideration"
require_relative "approval"
require_relative "action"
require_relative "meeting_identifier"
require_relative "resolution_relation"
require_relative "localization"

module Edoxen
  class Resolution < Lutaml::Model::Serializable
    RESOLUTION_TYPE_ENUM = %w[resolution recommendation decision declaration].freeze

    # Language-agnostic admin fields. Per-language content lives
    # inside `localizations[]` (see Localization).
    attribute :identifier, :string
    attribute :type, :string, values: RESOLUTION_TYPE_ENUM
    attribute :doi, :string
    attribute :urn, :string
    attribute :agenda_item, :string
    attribute :dates, ResolutionDate, collection: true
    attribute :categories, :string, collection: true
    attribute :meeting_identifier, MeetingIdentifier
    attribute :relations, ResolutionRelation, collection: true
    attribute :urls, Url, collection: true

    # One entry per available language. At least one is required
    # (enforced by the schema, not by lutaml-model).
    attribute :localizations, Localization, collection: true

    key_value do
      map "identifier", to: :identifier
      map "type", to: :type
      map "doi", to: :doi
      map "urn", to: :urn
      map "agenda_item", to: :agenda_item
      map "dates", to: :dates
      map "categories", to: :categories
      map "meeting_identifier", to: :meeting_identifier
      map "relations", to: :relations
      map "urls", to: :urls
      map "localizations", to: :localizations
    end
  end
end
