# frozen_string_literal: true

module Edoxen
  # A structured resolution identifier, e.g. prefix "ISO" + number "2019-01".
  # A Resolution carries 1..* StructuredIdentifier so a single resolution can
  # hold its TC number, its SC number, and any cross-cutting reference number
  # without forcing callers to flatten them into one opaque string.
  class StructuredIdentifier < Lutaml::Model::Serializable
    attribute :prefix, :string
    attribute :number, :string

    key_value do
      map "prefix", to: :prefix
      map "number", to: :number
    end
  end
end
