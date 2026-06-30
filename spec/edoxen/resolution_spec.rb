# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Resolution do
  describe "language-agnostic admin fields (LUTAML canonical)" do
    it "carries identifier as a collection of StructuredIdentifier" do
      payload = {
        "identifier" => [
          { "prefix" => "ISO", "number" => "2019-01" },
          { "prefix" => "TC154", "number" => "WG1" }
        ],
        "type" => "decision",
        "localizations" => [
          { "language_code" => "eng", "script" => "Latn", "title" => "T" }
        ]
      }
      r = described_class.from_yaml(YAML.dump(payload))
      expect(r.identifier).to be_an(Array)
      expect(r.identifier.size).to eq(2)
      expect(r.identifier.first).to be_a(Edoxen::StructuredIdentifier)
      expect(r.type).to eq("decision")
    end

    it "carries LUTAML LutaML ResolutionType values" do
      Edoxen::Enums::RESOLUTION_TYPE.each do |rt|
        r = described_class.new(type: rt, identifier: [Edoxen::StructuredIdentifier.new(prefix: "X", number: "1")])
        expect(r.type).to eq(rt)
      end
    end

    it "carries doi, urn, agenda_item, dates, categories, meeting, relations, urls" do
      payload = {
        "identifier" => [{ "prefix" => "X", "number" => "1" }],
        "doi" => "10.1234/abc",
        "urn" => "urn:x:y",
        "agenda_item" => "11.2",
        "dates" => [{ "date" => "2024-01-15", "type" => "adoption" }],
        "categories" => ["WG 1"],
        "meeting" => { "venue" => "Online", "date" => "2024-01-15" },
        "relations" => [
          {
            "source" => { "prefix" => "X", "number" => "1" },
            "destination" => { "prefix" => "X", "number" => "2" },
            "type" => "updates"
          }
        ],
        "urls" => [{ "kind" => "access", "ref" => "https://example.com", "format" => "html" }],
        "localizations" => [
          { "language_code" => "eng", "script" => "Latn", "title" => "T" }
        ]
      }
      r = described_class.from_yaml(YAML.dump(payload))
      expect(r.doi).to eq("10.1234/abc")
      expect(r.urn).to eq("urn:x:y")
      expect(r.agenda_item).to eq("11.2")
      expect(r.dates.first).to be_a(Edoxen::ResolutionDate)
      expect(r.categories).to eq(["WG 1"])
      expect(r.meeting).to be_a(Edoxen::MeetingIdentifier)
      expect(r.relations.first).to be_a(Edoxen::ResolutionRelation)
      expect(r.urls.first).to be_a(Edoxen::Url)
    end
  end

  describe "translatable fields live ONLY inside localizations[]" do
    it "no longer has flat #title / #subject / #considerations / #approvals / #actions" do
      expect(described_class.new).not_to respond_to(:title)
      expect(described_class.new).not_to respond_to(:subject)
      expect(described_class.new).not_to respond_to(:message)
      expect(described_class.new).not_to respond_to(:considering)
      expect(described_class.new).not_to respond_to(:considerations)
      expect(described_class.new).not_to respond_to(:approvals)
      expect(described_class.new).not_to respond_to(:actions)
    end

    it "exposes those fields via Localization" do
      payload = {
        "identifier" => [{ "prefix" => "X", "number" => "1" }],
        "type" => "decision",
        "localizations" => [
          {
            "language_code" => "eng", "script" => "Latn",
            "title" => "Title", "subject" => "Subject",
            "considerations" => [],
            "approvals" => [],
            "actions" => [
              {
                "type" => "approves",
                "date_effective" => { "date" => "2024-01-15", "type" => "adoption" },
                "message" => "approves"
              }
            ]
          }
        ]
      }
      r = described_class.from_yaml(YAML.dump(payload))
      eng = r.localizations.first
      expect(eng.title).to eq("Title")
      expect(eng.subject).to eq("Subject")
      expect(eng.actions.first).to be_a(Edoxen::Action)
    end
  end

  describe "real-world fixtures round-trip" do
    Dir.glob(File.expand_path("../fixtures/*.yaml", __dir__)).each do |fixture|
      it "round-trips #{File.basename(fixture)}" do
        collection = Edoxen::ResolutionCollection.from_yaml(File.read(fixture))
        reloaded = Edoxen::ResolutionCollection.from_yaml(collection.to_yaml)
        expect(reloaded.resolutions.size).to eq(collection.resolutions.size)
        expect(reloaded.resolutions.first.identifier).to eq(collection.resolutions.first.identifier)
        expect(reloaded.resolutions.first.localizations).to eq(collection.resolutions.first.localizations)
      end
    end
  end
end
