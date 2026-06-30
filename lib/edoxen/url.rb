# frozen_string_literal: true

module Edoxen
  # URL with a kind (access / report) and an optional format hint (pdf, html).
  class Url < Lutaml::Model::Serializable
    attribute :kind, :string, values: Enums::URL_KIND
    attribute :ref, :string
    attribute :format, :string
  end
end
