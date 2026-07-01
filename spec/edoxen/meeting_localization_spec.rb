# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::MeetingLocalization do
  it "round-trips a localized meeting block" do
    payload = {
      "language_code" => "fra", "script" => "Latn",
      "title" => "56e réunion du CIML",
      "general_area" => "Paris",
      "practical_info" => "Dress code: business"
    }
    ml = described_class.from_yaml(YAML.dump(payload))
    expect(ml.language_code).to eq("fra")
    expect(ml.title).to eq("56e réunion du CIML")
    expect(ml.practical_info).to eq("Dress code: business")
  end
end
