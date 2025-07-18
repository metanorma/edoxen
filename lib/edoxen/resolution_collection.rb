# frozen_string_literal: true

require "lutaml/model"

module Edoxen
  class ResolutionCollection < Lutaml::Model::Serializable
    attribute :metadata, :hash
    attribute :resolutions, Resolution, collection: true

    key_value do
      map "metadata", to: :metadata
      map "resolutions", to: :resolutions
    end

    # Example of a ResolutionCollection
    # metadata:
    #   title: Resolutions of the 38th plenary meeting of ISO/TC 154
    #   date: 2019-10-17
    #   source: ISO/TC 154 Secretariat
    # resolutions:
    #   - category: Resolutions related to JWG 1
    #     dates: 2019/10/17
    #     ...
  end
end
