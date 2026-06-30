# frozen_string_literal: true

module Edoxen
  # A formal Resolution. Language-agnostic admin fields live here; every
  # translatable field is wrapped inside `localizations[]` (one entry per
  # available language; at least one is required by the schema).
  class Resolution < Lutaml::Model::Serializable
    attribute :identifier, StructuredIdentifier, collection: true
    attribute :type, :string, values: Enums::RESOLUTION_TYPE
    attribute :doi, :string
    attribute :urn, :string
    attribute :agenda_item, :string
    attribute :dates, ResolutionDate, collection: true
    attribute :categories, :string, collection: true
    attribute :meeting, MeetingIdentifier
    attribute :relations, ResolutionRelation, collection: true
    attribute :urls, Url, collection: true
    attribute :localizations, Localization, collection: true

    key_value do
      map "identifier", to: :identifier
      map "type", to: :type
      map "doi", to: :doi
      map "urn", to: :urn
      map "agenda_item", to: :agenda_item
      map "dates", to: :dates
      map "categories", to: :categories
      map "meeting", to: :meeting
      map "relations", to: :relations
      map "urls", to: :urls
      map "localizations", to: :localizations
    end
  end
end
