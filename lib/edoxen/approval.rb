# frozen_string_literal: true

# Approval {
#   type: ApprovalType
#   degree: ApprovalDegree
#   date: Date
#   message: Text
# }

# enum ApprovalType {
#   affirmative
#   negative
# }

# enum ApprovalDegree {
#   unanimous
#   majority
#   minority
# }
require "lutaml/model"

module Edoxen
  class Approval < Lutaml::Model::Serializable
    APPROVAL_TYPE_ENUM = %w[affirmative negative].freeze
    APPROVAL_DEGREE_ENUM = %w[unanimous majority minority].freeze

    attribute :type, :string, values: APPROVAL_TYPE_ENUM
    attribute :degree, :string, values: APPROVAL_DEGREE_ENUM
    attribute :date, :date
    attribute :message, :string

    key_value do
      map "type", to: :type
      map "degree", to: :degree
      map "date", to: :date
      map "message", to: :message
    end
  end
end
