require "shale"
require "shale/type/value"

module Edoxen

  class ConsiderationTypeEnumInvalidValue < TypeError; end

  class ActionTypeEnum < Shale::Type::Value
    ALLOWED_VALUES = ['adopts', 'thanks', 'approves', 'decides', 'declares', 'asks', 'invites', 'resolves', 'confirms',
    'welcomes', 'recommends', 'requests', 'congratulates', 'instructs', 'urges', 'appoints', 'resolves further',
    'instructs', 'calls-upon', 'encourages', 'affirms', 'elects', 'authorizes', 'charges', 'states', 'remarks', 'judges',
    'sanctions', 'abrogates', 'empowers'].freeze

    def self.cast(value)
      if ALLOWED_VALUES.include?(value.to_s)
        value.to_sym
      else
        raise ConsiderationTypeEnumInvalidValue, "#{value.inspect} is not a valid action type"
      end
    end

  end

  class Action < Shale::Mapper
    attribute :type, ActionTypeEnum
    attribute :dateEffective, Shale::Type::Date
    attribute :message, Shale::Type::String
    attribute :subject, Shale::Type::String
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
