# frozen_string_literal: true

# Consideration {
#   type: ConsiderationType
#   dateEffective: Date
#   message: Text
# }

# enum ConsiderationType {
#   having / having regard
#   noting
#   recognizing
#   acknowledging
#   recalling / further recalling
#   reaffirming
#   considering
#   taking into account
#   pursuant to
#   bearing in mind
#   emphasizing
#   concerned
#   accepts
#   observing
#   referring
#   acting
#   empowers
#   reaffirming
# }

require "lutaml/model"

module Edoxen
  class Consideration < Lutaml::Model::Serializable
    CONSIDERATION_TYPE_ENUM = %w[having noting recognizing acknowledging recalling reaffirming considering
                                 taking-into-account pursuant-to bearing-in-mind emphasizing concerned accepts observing
                                 referring acting empowers reaffirming].freeze

    attribute :type, :string, values: CONSIDERATION_TYPE_ENUM
    attribute :date, :date
    attribute :message, :string

    key_value do
      map "type", to: :type
      map "date", to: :date
      map "message", to: :message
    end
  end
end
