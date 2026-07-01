# frozen_string_literal: true

module Edoxen
  # One section of a Meeting's minutes — typically tied to an agenda
  # item by its `number` field. Carries the narrative as Markdown
  # (the format the GLM-OCR pipeline emits) plus optional page range
  # for provenance back to the source PDF.
  class MinutesSection < Lutaml::Model::Serializable
    attribute :number, :string
    attribute :title, :string
    attribute :narrative, :string
    attribute :page_start, :integer
    attribute :page_end, :integer
    attribute :references, Reference, collection: true

    def in_language(code, fallback: false)
      match = localizations&.find { |loc| loc.language_code == code.to_s }
      return match if match

      fallback ? localizations&.first : nil
    end

    def primary_localization
      in_language("eng", fallback: true)
    end
  end
end
