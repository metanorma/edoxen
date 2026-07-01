# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::ScheduleItem do
  it "round-trips a timetable entry" do
    payload = {
      "date" => "2024-01-15", "time" => "9:00-10:30",
      "event" => "Opening", "description" => "Welcome address",
      "room" => "Main hall"
    }
    si = described_class.from_yaml(YAML.dump(payload))
    expect(si.date).to eq(Date.new(2024, 1, 15))
    expect(si.event).to eq("Opening")
    expect(si.room).to eq("Main hall")
  end
end
