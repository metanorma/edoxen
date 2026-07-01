# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::VoteRecord do
  describe "LUTAML VoteType coverage" do
    Edoxen::Enums::VOTE_TYPE.each do |vote|
      it "round-trips vote=#{vote}" do
        payload = {
          "resolution_ref" => "urn:example:resolution:1",
          "person" => { "name" => "Jane" },
          "vote" => vote
        }
        v = described_class.from_yaml(YAML.dump(payload))
        expect(v.vote).to eq(vote)
        expect(v.resolution_ref).to eq("urn:example:resolution:1")
      end
    end
  end

  it "carries an affiliation and notes" do
    payload = {
      "resolution_ref" => "urn:example:resolution:1",
      "person" => { "name" => "Jane" },
      "affiliation" => "NB of France",
      "vote" => "affirmative",
      "notes" => "Endorsed"
    }
    v = described_class.from_yaml(YAML.dump(payload))
    expect(v.affiliation).to eq("NB of France")
    expect(v.notes).to eq("Endorsed")
  end
end
