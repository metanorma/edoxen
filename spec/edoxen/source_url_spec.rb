# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::SourceUrl do
  describe "round-trip serialization" do
    it "stores ref, format, language_code" do
      su = described_class.from_yaml(
        YAML.dump(
          "ref" => "https://example.com/file.pdf",
          "format" => "pdf",
          "language_code" => "eng"
        )
      )
      expect(su.ref).to eq("https://example.com/file.pdf")
      expect(su.format).to eq("pdf")
      expect(su.language_code).to eq("eng")
    end

    it "round-trips through YAML" do
      original = described_class.from_yaml(
        YAML.dump(
          "ref" => "https://example.com/file.pdf",
          "format" => "pdf",
          "language_code" => "eng"
        )
      )
      reload = described_class.from_yaml(original.to_yaml)
      expect(reload.ref).to eq("https://example.com/file.pdf")
      expect(reload.format).to eq("pdf")
      expect(reload.language_code).to eq("eng")
    end
  end
end
