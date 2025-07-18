# frozen_string_literal: true

require "lutaml/model"

module Edoxen
  class Resolution < Lutaml::Model::Serializable
    RESOLUTION_TYPE_ENUM = %w[resolution recommendation decision declaration].freeze

    attribute :category, :string
    attribute :dates, :date, collection: true
    attribute :subject, :string
    attribute :title, :string
    attribute :type, :string, values: RESOLUTION_TYPE_ENUM
    attribute :identifier, :string
    attribute :considerations, Consideration, collection: true
    attribute :approvals, Approval, collection: true
    attribute :actions, Action, collection: true

    key_value do
      map "category", to: :category
      map "dates", to: :dates
      map "subject", to: :subject
      map "title", to: :title
      map "type", to: :type
      map "identifier", to: :identifier
      map "considerations", to: :considerations
      map "approvals", to: :approvals
      map "actions", to: :actions
    end

    # Example of a Resolution
    # category: Resolutions related to JWG 1
    # dates:
    #   - 2019-10-17
    # subject: ISO/TC 154
    # title: "Adoption of NWIP ballot for ISO/PWI 9735-11 "Electronic data..."
    # identifier: 2019-01
    # considerations:
    #   - type: considering
    #     date_effective: 2019-10-17
    #     message: considering the voting result ...

    #   - type: considering
    #     date_effective: 2019-10-17
    #     message: considering the importance of ...

    #   - type: considering
    #     date_effective: 2019-10-17
    #     message: considering the request from JWG1...

    # approvals:
    #   - type: affirmative
    #     degree: unanimous
    #     message: The resolution was taken by unanimity.

    # actions:
    #   - type: resolves
    #     date_effective: 2019-10-17
    #     message: resolves to submit ISO 9735-11...
  end
end
