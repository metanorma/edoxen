# frozen_string_literal: true

module Edoxen
  # Venue geography. Multi-venue meetings (e.g., a plenary week with
  # different hotels) carry one Location per venue.
  class Location < Lutaml::Model::Serializable
    attribute :name, :string
    attribute :address, :string
    attribute :link, :string
    attribute :phone, :string
    attribute :note, :string
    attribute :lat, :float
    attribute :lon, :float
  end
end
