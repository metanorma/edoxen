# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Location do
  it "round-trips a full venue record" do
    payload = {
      "name" => "OIML HQ", "address" => "11 Rue Turgot, Paris",
      "link" => "https://example.org", "phone" => "+33 1 48 78 82 83",
      "note" => "Buzzer after hours", "lat" => 48.8774, "lon" => 2.3412
    }
    loc = described_class.from_yaml(YAML.dump(payload))
    expect(loc.name).to eq("OIML HQ")
    expect(loc.lat).to eq(48.8774)
    expect(loc.lon).to eq(2.3412)

    reload = described_class.from_yaml(loc.to_yaml)
    expect(reload.name).to eq("OIML HQ")
    expect(reload.lat).to eq(48.8774)
  end
end
