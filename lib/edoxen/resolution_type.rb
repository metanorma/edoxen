# Resolution {
#   subject: SubjectBody
#   title
#   type: ResolutionType
#   identifier: StructuredIdentifier[]
#   meeting: MeetingIdentifier
#   dates: ResolutionDate[]
#   considerations: Consideration[]
#   actions: Action[]
#   approvals: Approval[]
#   agendaItem: AgendaItemId
# }

# ResolutionType {
#   resolution
#   recommendation
#   decision
#   declaration
# }
require "shale"
require "shale/type/value"

module Edoxen
  class ConsiderationTypeEnumInvalidValue < TypeError; end

  class ResolutionTypeEnum < Shale::Type::Value
    ALLOWED_VALUES = ['resolution', 'recommendation', 'decision', 'declaration'].freeze

    def self.cast(value)
      if ALLOWED_VALUES.include?(value.to_s)
        value.to_sym
      else
        raise ConsiderationTypeEnumInvalidValue, "#{value.inspect} is not a valid resolution type"
      end
    end

  end
end
