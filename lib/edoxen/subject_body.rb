# frozen_string_literal: true

# SubjectBody {
#   name
#   address
#   etc.
# }
require "lutaml/model"

module Edoxen
  class SubjectBody < Lutaml::Model::Serializable
    attribute :name, :string
    attribute :address, :string

    key_value do
      map "name", to: :name
      map "address", to: :address
    end
  end
end
