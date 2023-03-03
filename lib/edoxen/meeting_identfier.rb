# MeetingIdentifier {
#   venue: String
#   date: DateTime
# }
require "shale"
require "shale/type/value"

module Edoxen
  class MeetingIdentifier < Shale::Mapper
    attribute :venue, Shale::Type::String
    attribute :date, Shale::Type::Date
  end
end
