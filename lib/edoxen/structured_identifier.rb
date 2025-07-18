# frozen_string_literal: true

# StructuredIdentifier {
#   number:
#   prefix:
# }

require "lutaml/model"

module Edoxen
  class StructuredIdentifier < Lutaml::Model::Serializable
    attribute :number, :string
    attribute :prefix, :string

    key_value do
      map "number", to: :number
      map "prefix", to: :prefix
    end
  end
end
