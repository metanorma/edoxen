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
require "shale"
require "shale/type/value"
module Edoxen
  class ConsiderationTypeEnumInvalidValue < TypeError; end

  class ApprovalDegreeEnumInvalidValue < TypeError; end

  class ConsiderationTypeEnum < Shale::Type::Value
    ALLOWED_VALUES = ['affirmative', 'negative'].freeze

    def self.cast(value)
      if ALLOWED_VALUES.include?(value.to_s)
        value.to_sym
      else
        raise ConsiderationTypeEnumInvalidValue, "#{value.inspect} is not a valid approval type"
      end
    end

  end

  class ApprovalDegreeEnum < Shale::Type::Value
    ALLOWED_VALUES = ['affirmative', 'negative'].freeze

    def self.cast(value)
      if ALLOWED_VALUES.include?(value.to_s)
        value.to_sym
      else
        raise ApprovalDegreeEnumInvalidValue, "#{value.inspect} is not a valid approval degree"
      end
    end

  end

  class Approval < Shale::Mapper
    attribute :type, ConsiderationTypeEnum
    attribute :degree, ApprovalDegreeEnum
    attribute :date, Shale::Type::Date
    attribute :message, Shale::Type::String
  end
end
