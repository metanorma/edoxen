# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::MeetingIdentifier do
  let(:fixture_yaml) do
    <<~YAML
      ---
      venue: University of Luxembourg
      date: 2019-10-17
    YAML
  end

  describe "round-trip serialization" do
    it "parses venue and date" do
      m = described_class.from_yaml(fixture_yaml)
      expect(m.venue).to eq("University of Luxembourg")
      expect(m.date).to eq(Date.new(2019, 10, 17))
    end

    it "round-trips through YAML" do
      m = described_class.from_yaml(fixture_yaml)
      reloaded = described_class.from_yaml(m.to_yaml)
      expect(reloaded.venue).to eq("University of Luxembourg")
      expect(reloaded.date).to eq(Date.new(2019, 10, 17))
    end
  end

  it "treats a nil date as nil (not coerced)" do
    m = described_class.new(venue: "Online")
    expect(m.date).to be_nil
  end
end
