# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::StructuredIdentifier do
  let(:fixture_yaml) do
    <<~YAML
      ---
      prefix: ISO
      number: "2019-01"
    YAML
  end

  describe "round-trip serialization" do
    it "deserializes a YAML string into a real StructuredIdentifier" do
      id = described_class.from_yaml(fixture_yaml)
      expect(id).to be_a(described_class)
      expect(id.prefix).to eq("ISO")
      expect(id.number).to eq("2019-01")
    end

    it "re-serializes to YAML form" do
      id = described_class.from_yaml(fixture_yaml)
      yaml = id.to_yaml
      expect(yaml).to include("prefix: ISO")
      expect(yaml).to include("number: 2019-01")
    end

    it "round-trips without data loss" do
      original = described_class.from_yaml(fixture_yaml)
      reloaded = described_class.from_yaml(original.to_yaml)
      expect(reloaded.prefix).to eq(original.prefix)
      expect(reloaded.number).to eq(original.number)
    end
  end

  describe "construction" do
    it "is constructible with explicit attrs" do
      id = described_class.new(prefix: "OIML", number: "44")
      expect(id.prefix).to eq("OIML")
      expect(id.number).to eq("44")
    end

    it "leaves both fields nil when constructed with no args" do
      id = described_class.new
      expect(id.prefix).to be_nil
      expect(id.number).to be_nil
    end
  end
end
