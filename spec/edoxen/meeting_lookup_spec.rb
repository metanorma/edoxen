# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Meeting, "#in_language" do
  let(:meeting) do
    described_class.new(
      identifier: [Edoxen::StructuredIdentifier.new(prefix: "X", number: "1")],
      type: "plenary",
      localizations: [
        Edoxen::MeetingLocalization.new(language_code: "fra", title: "Réunion"),
        Edoxen::MeetingLocalization.new(language_code: "eng", title: "Meeting")
      ]
    )
  end

  it "returns the localization whose language_code matches" do
    expect(meeting.in_language("eng").title).to eq("Meeting")
    expect(meeting.in_language("fra").title).to eq("Réunion")
  end

  it "returns nil when no match and fallback disabled" do
    expect(meeting.in_language("deu")).to be_nil
  end

  it "falls back to the first when fallback: true" do
    expect(meeting.in_language("deu", fallback: true).language_code).to eq("fra")
  end

  it "returns the English rendering via #primary_localization" do
    expect(meeting.primary_localization.title).to eq("Meeting")
  end

  it "falls back to the first when English is absent" do
    m = described_class.new(
      identifier: [Edoxen::StructuredIdentifier.new(prefix: "X", number: "1")],
      type: "plenary",
      localizations: [Edoxen::MeetingLocalization.new(language_code: "fra", title: "X")]
    )
    expect(m.primary_localization.language_code).to eq("fra")
  end
end

RSpec.describe Edoxen::Meeting, "#find_agenda_item" do
  let(:meeting) do
    described_class.new(
      identifier: [Edoxen::StructuredIdentifier.new(prefix: "X", number: "1")],
      type: "plenary",
      agenda: Edoxen::Agenda.new(items: [
                                   Edoxen::AgendaItem.new(label: "1", title: "First"),
                                   Edoxen::AgendaItem.new(label: "5.2", title: "Sub")
                                 ])
    )
  end

  it "finds an agenda item by label" do
    expect(meeting.find_agenda_item("5.2").title).to eq("Sub")
  end

  it "returns nil when no matching label" do
    expect(meeting.find_agenda_item("99")).to be_nil
  end

  it "returns nil when the meeting has no agenda" do
    m = described_class.new(
      identifier: [Edoxen::StructuredIdentifier.new(prefix: "X", number: "1")],
      type: "plenary"
    )
    expect(m.find_agenda_item("1")).to be_nil
  end
end
