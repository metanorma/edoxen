# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::HostRef do
  describe "LUTAML HostType coverage" do
    Edoxen::Enums::HOST_TYPE.each do |t|
      it "round-trips type=#{t}" do
        payload = { "ref" => "acme", "type" => t, "role" => "co-host" }
        h = described_class.from_yaml(YAML.dump(payload))
        expect(h.type).to eq(t)
        expect(h.ref).to eq("acme")
      end
    end
  end

  it "carries an optional contact Person" do
    payload = {
      "ref" => "acme", "type" => "organizer",
      "contact" => { "name" => "Jane", "email" => "jane@acme.org" }
    }
    h = described_class.from_yaml(YAML.dump(payload))
    expect(h.contact).to be_a(Edoxen::Person)
    expect(h.contact.name).to eq("Jane")
  end
end
