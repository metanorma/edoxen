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

require "shale"
require "shale/type/value"
module Edoxen
  class ConsiderationTypeEnumInvalidValue < TypeError; end

  class ConsiderationTypeEnum < Shale::Type::Value
    ALLOWED_VALUES = ['having', 'noting', 'recognizing', 'acknowledging', 'recalling', 'reaffirming', 'considering',
    'taking-into-account', 'pursuant-to', 'bearing-in-mind', 'emphasizing', 'concerned', 'accepts', 'observing',
    'referring', 'acting', 'empowers', 'reaffirming'].freeze

    def self.cast(value)
      if ALLOWED_VALUES.include?(value.to_s)
        value.to_sym
      else
        raise ConsiderationTypeEnumInvalidValue, "#{value.inspect} is not a valid approval type"
      end
    end

  end

  class Consideration < Shale::Mapper
    attribute :type, ConsiderationTypeEnum
    attribute :degree, ApprovalDegreeEnum
    attribute :date, Shale::Type::Date
    attribute :message, Shale::Type::String
  end
end
