# frozen_string_literal: true

module Edoxen
  # Directed relation between two resolutions, identified by their
  # StructuredIdentifier (prefix + number).
  class ResolutionRelation < Lutaml::Model::Serializable
    attribute :source, StructuredIdentifier
    attribute :destination, StructuredIdentifier
    attribute :type, :string, values: Enums::RESOLUTION_RELATION_TYPE
  end
end
