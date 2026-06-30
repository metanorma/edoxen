# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::ResolutionCollection do
  describe "real-world fixtures" do
    Dir.glob(File.expand_path("../fixtures/*.yaml", __dir__)).each do |fixture|
      it "loads #{File.basename(fixture)}" do
        collection = described_class.from_yaml(File.read(fixture))
        expect(collection).to be_a(described_class)
        expect(collection.resolutions).to all(be_a(Edoxen::Resolution))
        expect(collection.resolutions).not_to be_empty
      end

      it "round-trips #{File.basename(fixture)}" do
        original = described_class.from_yaml(File.read(fixture))
        reloaded = described_class.from_yaml(original.to_yaml)
        expect(reloaded.resolutions.size).to eq(original.resolutions.size)
        expect(reloaded.metadata).to eq(original.metadata)
      end
    end
  end

  describe "empty / partial inputs" do
    it "is constructible with only metadata" do
      c = described_class.new(metadata: Edoxen::ResolutionMetadata.new(title: "X"))
      expect(c.resolutions).to be_nil
      expect(c.metadata.title).to eq("X")
    end

    it "is constructible with an empty resolutions array" do
      c = described_class.new(resolutions: [])
      expect(c.resolutions).to eq([])
    end
  end
end
