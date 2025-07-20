# frozen_string_literal: true

require "lutaml/model"

module Edoxen
  class Url < Lutaml::Model::Serializable
    attribute :kind, :string, values: %w[access report]
    attribute :ref, :string
    attribute :format, :string

    key_value do
      map "kind", to: :kind
      map "ref", to: :ref
      map "format", to: :format
    end
  end
end
