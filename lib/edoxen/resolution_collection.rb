# frozen_string_literal: true

module Edoxen
  # Top-level container for a published resolution collection: metadata
  # plus the list of resolutions.
  class ResolutionCollection < Lutaml::Model::Serializable
    attribute :metadata, ResolutionMetadata
    attribute :resolutions, Resolution, collection: true

    key_value do
      map "metadata", to: :metadata
      map "resolutions", to: :resolutions
    end
  end
end
