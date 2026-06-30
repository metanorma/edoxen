# frozen_string_literal: true

module Edoxen
  # Collection-level metadata: the title (string for default / single-language
  # collections, or `title_localized[]` for multilingual), the meeting date,
  # the source secretariat, per-language source PDFs, and the host venue.
  class ResolutionMetadata < Lutaml::Model::Serializable
    attribute :title, :string
    attribute :title_localized, Localization, collection: true
    attribute :date, :date
    attribute :source, :string
    attribute :source_urls, SourceUrl, collection: true
    attribute :city, :string
    attribute :country_code, :string

    key_value do
      map "title", to: :title
      map "title_localized", to: :title_localized
      map "date", to: :date
      map "source", to: :source
      map "source_urls", to: :source_urls
      map "city", to: :city
      map "country_code", to: :country_code
    end
  end
end
