# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"
require_relative "url"
require_relative "localization"

module Edoxen
  # A per-language source-URL record. Carries the URL ref, its format
  # (pdf, html, ...), and the language_code (ISO 639-3) for which the
  # URL is the canonical source.
  class SourceUrl < Lutaml::Model::Serializable
    attribute :ref, :string
    attribute :format, :string
    attribute :language_code, :string

    key_value do
      map "ref", to: :ref
      map "format", to: :format
      map "language_code", to: :language_code
    end
  end

  class Metadata < Lutaml::Model::Serializable
    attribute :title, :string
    attribute :identifier, :string
    attribute :dates, ResolutionDate, collection: true
    attribute :source, :string
    attribute :venue, :string
    attribute :chair, :string
    attribute :urls, Url, collection: true

    # OIML extensions — see TODO.complete/14 for the glossarist-style
    # i18n model. `title_localized` carries the per-language title
    # parallel to Resolution#localizations. `source_urls` carries the
    # per-language PDF URLs. `city`/`country_code` carry the IATA /
    # ISO 3166-1 alpha-2 codes for the host venue.
    attribute :title_localized, Localization, collection: true
    attribute :source_urls, SourceUrl, collection: true
    attribute :city, :string
    attribute :country_code, :string

    key_value do
      map "title", to: :title
      map "identifier", to: :identifier
      map "dates", to: :dates
      map "source", to: :source
      map "venue", to: :venue
      map "chair", to: :chair
      map "urls", to: :urls
      map "title_localized", to: :title_localized
      map "source_urls", to: :source_urls
      map "city", to: :city
      map "country_code", to: :country_code
    end
  end
end
