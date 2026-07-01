# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::MeetingRelation do
  describe "LUTAML MeetingRelationType coverage" do
    Edoxen::Enums::MEETING_RELATION_TYPE.each do |t|
      it "round-trips type=#{t}" do
        payload = {
          "source" => { "prefix" => "CIML", "number" => "56" },
          "destination" => { "prefix" => "CIML", "number" => "55" },
          "type" => t
        }
        r = described_class.from_yaml(YAML.dump(payload))
        expect(r.type).to eq(t)
        expect(r.source).to be_a(Edoxen::StructuredIdentifier)
        expect(r.destination).to be_a(Edoxen::StructuredIdentifier)
      end
    end
  end
end
