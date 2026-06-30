# frozen_string_literal: true

require "lutaml/model"
require_relative "resolution_date"

module Edoxen
  # ISO 639-3 three-letter language code (eng, fra, deu, spa, jpn, ...).
  # Stored as a plain string so new languages need no schema change.
  class LanguageCode < Lutaml::Model::Serializable
    attribute :code, :string

    key_value do
      map_all
    end

    def to_s
      code.to_s
    end
  end

  # A monolingual rendering of a Resolution. Mirrors the glossarist
  # LocalizedConcept pattern: language-agnostic fields live on the
  # parent Resolution; per-language content lives here.
  #
  # See edoxen.yaml `$defs/Localization` for the JSON-Schema form.
  class Localization < Lutaml::Model::Serializable
    attribute :language_code, :string
    attribute :script, :string
    attribute :title, :string
    attribute :subject, :string
    attribute :message, :string
    attribute :considering, :string
    attribute :considerations, Consideration, collection: true
    attribute :approvals, Approval, collection: true
    attribute :actions, Action, collection: true

    key_value do
      map "language_code", to: :language_code
      map "script", to: :script
      map "title", to: :title
      map "subject", to: :subject
      map "message", to: :message
      map "considering", to: :considering
      map "considerations", to: :considerations
      map "approvals", to: :approvals
      map "actions", to: :actions
    end
  end
end
