# frozen_string_literal: true

module Edoxen
  # Directed link between two meetings, identified by their
  # StructuredIdentifier. Reuses the same relation-type vocabulary
  # pattern as ResolutionRelation.
  class MeetingRelation < Lutaml::Model::Serializable
    attribute :source, StructuredIdentifier
    attribute :destination, StructuredIdentifier
    attribute :type, :string, values: Enums::MEETING_RELATION_TYPE
  end
end
