# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Localization do
  describe "language_code + script ISO-code conventions" do
    it "accepts the canonical Eng/Latn pairing" do
      payload = {
        "language_code" => "eng", "script" => "Latn",
        "title" => "Title", "subject" => "Subject", "message" => "Message",
        "considering" => "Considering",
        "considerations" => [],
        "approvals" => [], "actions" => []
      }
      loc = described_class.from_yaml(YAML.dump(payload))
      expect(loc.language_code).to eq("eng")
      expect(loc.script).to eq("Latn")
    end

    it "stores nested Consideration/Approval/Action collections with their real types" do
      payload = {
        "language_code" => "fra", "script" => "Latn",
        "title" => "Décision",
        "considerations" => [
          {
            "type" => "having",
            "date_effective" => { "date" => "2024-01-15", "type" => "adoption" },
            "message" => "having regard"
          }
        ],
        "approvals" => [
          {
            "type" => "affirmative", "degree" => "unanimous",
            "date" => { "date" => "2024-01-15", "type" => "adoption" },
            "message" => "unanime"
          }
        ],
        "actions" => [
          {
            "type" => "decides",
            "date_effective" => { "date" => "2024-01-15", "type" => "adoption" },
            "message" => "decide"
          }
        ]
      }
      loc = described_class.from_yaml(YAML.dump(payload))
      expect(loc.considerations.first).to be_a(Edoxen::Consideration)
      expect(loc.approvals.first).to be_a(Edoxen::Approval)
      expect(loc.actions.first).to be_a(Edoxen::Action)
    end

    it "round-trips through YAML without data loss" do
      payload = {
        "language_code" => "eng", "script" => "Latn",
        "title" => "Title", "subject" => "Subject",
        "considerations" => [
          {
            "type" => "having",
            "date_effective" => { "date" => "2024-01-15", "type" => "adoption" },
            "message" => "having regard"
          }
        ],
        "approvals" => [], "actions" => []
      }
      original = described_class.from_yaml(YAML.dump(payload))
      reload = described_class.from_yaml(original.to_yaml)
      expect(reload.language_code).to eq("eng")
      expect(reload.title).to eq("Title")
      expect(reload.subject).to eq("Subject")
      expect(reload.considerations.first).to be_a(Edoxen::Consideration)
      expect(reload.considerations.first.message).to eq("having regard")
    end
  end

  describe "missing-language-code is accepted (the schema enforces it strictly)" do
    # The model is permissive; the schema requires language_code.
    it "constructs without language_code but the round-trip is asymmetric" do
      loc = described_class.new(title: "T", script: "Latn")
      expect(loc.language_code).to be_nil
      expect(loc.title).to eq("T")
    end
  end
end
