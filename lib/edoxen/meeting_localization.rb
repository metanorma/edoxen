# frozen_string_literal: true

module Edoxen
  # Per-language content for a Meeting. Mirrors the glossarist
  # pattern used by `Localization` for Resolutions: language-agnostic
  # admin fields live on the parent Meeting; per-language content
  # lives here.
  class MeetingLocalization < Lutaml::Model::Serializable
    attribute :language_code, :string
    attribute :script, :string
    attribute :title, :string
    attribute :general_area, :string
    attribute :practical_info, :string
  end
end
