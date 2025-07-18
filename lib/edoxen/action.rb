# frozen_string_literal: true

require "lutaml/model"

module Edoxen
  class Action < Lutaml::Model::Serializable
    ACTION_TYPE_ENUM = %w[
      adopts thanks approves decides declares asks invites resolves confirms
      welcomes recommends requests congratulates instructs urges appoints
      resolves further instructs calls-upon encourages affirms elects
      authorizes charges states remarks judges sanctions abrogates empowers
    ].freeze

    attribute :type, :string, values: ACTION_TYPE_ENUM
    attribute :date_effective, :date
    attribute :message, :string
    attribute :subject, :string

    key_value do
      map "type", to: :type
      map "date_effective", to: :date_effective
      map "message", to: :message
      map "subject", to: :subject
    end
  end
end

# Action {
#   type: ActionType
#   dateEffective: Date
#   message: Text
# }

# enum ActionType {
#   adopts
#   thanks / expresses-appreciation (subjects)
#   approves
#   decides
#   declares
#   asks (subjects)
#   invites / further invites (subjects)
#   resolves
#   confirms
#   welcomes (subjects)
#   recommends
#   requests (subjects)
#   congratulates (subjects)
#   instructs (subjects)
#   urges (subjects)
#   appoints (subjects)
#   resolves further
#   instructs (subjects)
#   calls upon (subjects)
#   encourages (subjects)
#   affirms / reaffirming (subjects)
#   elects
#   authorizes
#   charges
#   states
#   remarks
#   judges
#   sanctions
#   abrogates
#   empowers
# }
