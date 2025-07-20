# frozen_string_literal: true

require "lutaml/model"

module Edoxen
  class ResolutionDate < Lutaml::Model::Serializable
    attribute :start, :date
    attribute :end, :date
    attribute :kind, :string, values: %w[ballot enactment effective decision meeting]

    key_value do
      map "start", to: :start
      map "end", to: :end
      map "kind", to: :kind
    end

  end
end
