# frozen_string_literal: true

module Edoxen
  # Date with semantic kind (adoption, drafted, discussed).
  # ResolutionDate is the only carrier of a *typed* date in the model —
  # plain `Date` in lutaml-model has no semantic context.
  class ResolutionDate < Lutaml::Model::Serializable
    attribute :date, :date
    attribute :type, :string, values: Enums::RESOLUTION_DATE_TYPE
  end
end
