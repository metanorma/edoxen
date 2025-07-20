# frozen_string_literal: true

# class ResolutionRelation {
#   source: StructuredIdentifier (Resolution)
#   destination: StructuredIdentifier (Resolution)
#   type: ResolutionRelationType
# }

# enum ResolutionRelationType {
#   annexOf {
#     This resolution is an annex to the target resolution.
#   }

#   hasAnnex {
#     The target resolution is an annex of the source resolution.
#   }

#   updates {
#     This resolution updates the target resolution.
#   }

#   refines {
#     This resolution refines the target resolution.
#   }

#   replaces/obsoletes {
#     This resolution replaces/obsoletes the target resolution.
#   }

#   considers {
#     This resolution is made in consideration of the target resolution.
#   }
# }

require "lutaml/model"

module Edoxen
  class ResolutionRelation < Lutaml::Model::Serializable
    RESOLUTION_RELATIONSHIP_ENUM = %w[annexOf hasAnnex updates refines replaces obsoletes considers].freeze

    attribute :source, :string
    attribute :destination, :string
    attribute :type, :string, values: RESOLUTION_RELATIONSHIP_ENUM

    key_value do
      map "source", to: :source
      map "destination", to: :destination
      map "type", to: :type
    end
  end
end
