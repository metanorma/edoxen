# frozen_string_literal: true

module Edoxen
  # A single Meeting — the event that produces Resolutions. Carries
  # identity, time, venue, officers, agenda, schedule, deadlines, and
  # URN links to one or more ResolutionCollection documents.
  #
  # Meetings and ResolutionCollections are kept as separate documents
  # and joined by URN (Meeting.resolution_refs ↔
  # ResolutionCollection.metadata.meeting_urn) because they have
  # different lifetimes: agendas exist weeks before a meeting;
  # resolutions only after adoption.
  class Meeting < Lutaml::Model::Serializable
    attribute :identifier, StructuredIdentifier, collection: true
    attribute :urn, :string
    attribute :ordinal, :integer
    attribute :type, :string, values: Enums::MEETING_TYPE
    attribute :status, :string, values: Enums::MEETING_STATUS
    attribute :year, :integer

    attribute :date_range, DateRange

    attribute :committee, :string
    attribute :committee_group, :string

    attribute :venues, Location, collection: true
    attribute :general_area, :string
    attribute :city, :string
    attribute :country_code, :string
    attribute :virtual, :boolean

    attribute :chair, Person
    attribute :secretary, Person
    attribute :host, :string
    attribute :hosts, HostRef, collection: true

    attribute :source_urls, SourceUrl, collection: true
    attribute :landing_url, :string
    attribute :registration_url, :string

    attribute :agenda, Agenda
    attribute :schedule, ScheduleItem, collection: true
    attribute :deadlines, Deadline, collection: true

    attribute :attendance, Attendance, collection: true
    attribute :vote_records, VoteRecord, collection: true

    attribute :localizations, MeetingLocalization, collection: true
    attribute :relations, MeetingRelation, collection: true
    attribute :resolution_refs, :string, collection: true

    # Lookup by ISO 639-3 language code. Mirrors Resolution#in_language.
    def in_language(code, fallback: false)
      match = localizations&.find { |loc| loc.language_code == code.to_s }
      return match if match

      fallback ? localizations&.first : nil
    end

    # English when available, else the first declared localization.
    def primary_localization
      in_language("eng", fallback: true)
    end

    # Find an agenda item by label. Returns nil when no agenda or no
    # matching label.
    def find_agenda_item(label)
      agenda&.find_item(label)
    end
  end
end
