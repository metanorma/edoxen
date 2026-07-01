# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::ScheduleItemLocalization do
  it "round-trips a per-language schedule entry" do
    payload = {
      "language_code" => "fra", "script" => "Latn",
      "event" => "Séance d'ouverture",
      "description" => "Mot de bienvenue"
    }
    sil = described_class.from_yaml(YAML.dump(payload))
    expect(sil.language_code).to eq("fra")
    expect(sil.event).to eq("Séance d'ouverture")
  end
end

RSpec.describe Edoxen::ScheduleItem, "#in_language" do
  let(:item) do
    described_class.new(
      date: Date.new(2024, 1, 15),
      time: "9:00",
      localizations: [
        Edoxen::ScheduleItemLocalization.new(language_code: "eng", event: "Opening"),
        Edoxen::ScheduleItemLocalization.new(language_code: "fra", event: "Ouverture")
      ]
    )
  end

  it "returns the matching localization" do
    expect(item.in_language("fra").event).to eq("Ouverture")
    expect(item.in_language("eng").event).to eq("Opening")
  end

  it "returns nil when no match and fallback disabled" do
    expect(item.in_language("deu")).to be_nil
  end

  it "falls back to the first when fallback: true" do
    expect(item.in_language("deu", fallback: true).language_code).to eq("eng")
  end

  it "exposes the English rendering via #primary_localization" do
    expect(item.primary_localization.event).to eq("Opening")
  end
end
