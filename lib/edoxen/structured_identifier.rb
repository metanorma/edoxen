# StructuredIdentifier {
#   number:
#   prefix:
# }

require "shale"
require "shale/type/value"

module Edoxen
  class StructuredIdentifier < Shale::Mapper
    attribute :number, Shale::Type::String
    attribute :prefix, Shale::Type::String
  end
end
