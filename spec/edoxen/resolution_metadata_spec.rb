# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::ResolutionMetadata do
  describe "canonical fields (LUTAML ResolutionMetadata.lutaml)" do
    it "carries title, date, source, source_urls, city, country_code" do
      payload = {
        "title" => "Resolutions of the 38th plenary meeting of ISO/TC 154",
        "date" => "2019-10-17",
        "source" => "ISO/TC 154 Secretariat",
        "source_urls" => [
          { "ref" => "https://example.com/file.pdf", "format" => "pdf", "language_code" => "eng" }
        ],
        "city" => "LUX",
        "country_code" => "LU"
      }
      m = described_class.from_yaml(YAML.dump(payload))
      expect(m.title).to eq("Resolutions of the 38th plenary meeting of ISO/TC 154")
      expect(m.date).to eq(Date.new(2019, 10, 17))
      expect(m.source).to eq("ISO/TC 154 Secretariat")
      expect(m.source_urls).to all(be_a(Edoxen::SourceUrl))
      expect(m.city).to eq("LUX")
      expect(m.country_code).to eq("LU")
    end

    it "supports title_localized[] for multilingual collections" do
      payload = {
        "title" => "Default",
        "title_localized" => [
          { "language_code" => "eng", "script" => "Latn", "title" => "English title" },
          { "language_code" => "fra", "script" => "Latn", "title" => "Titre français" }
        ]
      }
      m = described_class.from_yaml(YAML.dump(payload))
      expect(m.title_localized.size).to eq(2)
      expect(m.title_localized).to all(be_a(Edoxen::Localization))
      expect(m.title_localized.map(&:language_code)).to eq(%w[eng fra])
      expect(m.title_localized.map(&:title)).to eq(["English title", "Titre français"])
    end
  end
end
