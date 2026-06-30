# frozen_string_literal: true

module Edoxen
  # Per-language canonical source URL (e.g. one PDF per language).
  # Carries the URL ref, its format, and the ISO 639-3 language_code the URL
  # is the canonical source for.
  class SourceUrl < Lutaml::Model::Serializable
    attribute :ref, :string
    attribute :format, :string
    attribute :language_code, :string

    key_value do
      map "ref", to: :ref
      map "format", to: :format
      map "language_code", to: :language_code
    end
  end
end
