# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"
require_relative "url"

module Edoxen
  class Metadata < Lutaml::Model::Serializable
    attribute :title, :string
    attribute :identifier, :string
    attribute :dates, ResolutionDate, collection: true
    attribute :source, :string
    attribute :venue, :string
    attribute :chair, :string
    attribute :urls, Url, collection: true

    key_value do
      map "title", to: :title
      map "identifier", to: :identifier
      map "dates", to: :dates
      map "source", to: :source
      map "venue", to: :venue
      map "chair", to: :chair
      map "urls", to: :urls
    end
  end
end
