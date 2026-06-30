# frozen_string_literal: true

module Edoxen
  # A formal Resolution. Language-agnostic admin fields live here; every
  # translatable field is wrapped inside `localizations[]` (one entry per
  # available language; at least one is required by the schema).
  #
  # Wire names follow lutaml-model's default convention: each declared
  # attribute serializes to its snake_case name on the wire. Override
  # with an explicit `key_value do; map "wire", to: :attr; end` block
  # only when the wire name differs.
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

    # Lookup by ISO 639-3 language code. Returns nil when no exact match
    # exists and `fallback:` is false (the default); returns the first
    # localization otherwise. Keeps the language-preference policy in
    # one place so callers stop reimplementing `find { |l| ... }`.
    def in_language(code, fallback: false)
      match = localizations&.find { |loc| loc.language_code == code.to_s }
      return match if match

      fallback ? localizations&.first : nil
    end

    # The canonical rendering — English when available, else the first
    # declared localization. Mirrors the glossarist LocalizedConcept
    # "preferred language" notion.
    def primary_localization
      in_language("eng", fallback: true)
    end
  end
end
