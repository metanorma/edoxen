# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::ResolutionRelation do
  describe "LUTAML ResolutionRelationType coverage" do
    Edoxen::Enums::RESOLUTION_RELATION_TYPE.each do |rel|
      it "round-trips a relation of type=#{rel}" do
        payload = {
          "source" => { "prefix" => "ISO", "number" => "1" },
          "destination" => { "prefix" => "ISO", "number" => "2" },
          "type" => rel
        }
        r = described_class.from_yaml(YAML.dump(payload))
        expect(r.source).to be_a(Edoxen::StructuredIdentifier)
        expect(r.destination).to be_a(Edoxen::StructuredIdentifier)
        expect(r.type).to eq(rel)
      end
    end
  end
end
