# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Url do
  describe "LUTAML UrlKind coverage" do
    Edoxen::Enums::URL_KIND.each do |kind|
      it "round-trips a url of kind=#{kind}" do
        u = described_class.from_yaml(YAML.dump("kind" => kind, "ref" => "https://example.com/#{kind}",
                                                "format" => "html"))
        expect(u.kind).to eq(kind)
        reload = described_class.from_yaml(u.to_yaml)
        expect(reload.kind).to eq(kind)
        expect(reload.format).to eq("html")
      end
    end
  end
end
