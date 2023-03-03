# SubjectBody {
#   name
#   address
#   etc.
# }
require "shale"
require "shale/type/value"

module Edoxen
  class SubjectBody < Shale::Mapper
    attribute :name, Shale::Type::String
    attribute :address, Shale::Type::String
  end
end
