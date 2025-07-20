# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Resolution do
  let(:fixture_path) { File.join(__dir__, "..", "fixtures", "isotc154-plenary-38.yaml") }
  let(:fixture_yaml) { File.read(fixture_path) }
  let(:resolution_set) { Edoxen::ResolutionSet.from_yaml(fixture_yaml) }
  let(:sample_resolution) { resolution_set.resolutions.first }

  describe "attributes" do
    it "has the expected attributes" do
      resolution = described_class.new

      expect(resolution).to respond_to(:categories)
      expect(resolution).to respond_to(:dates)
      expect(resolution).to respond_to(:subject)
      expect(resolution).to respond_to(:title)
      expect(resolution).to respond_to(:type)
      expect(resolution).to respond_to(:identifier)
      expect(resolution).to respond_to(:considerations)
      expect(resolution).to respond_to(:approvals)
      expect(resolution).to respond_to(:actions)
    end
  end

  describe "type validation" do
    it "accepts valid resolution types" do
      %w[resolution recommendation decision declaration].each do |type|
        resolution = described_class.new(type: type)
        expect(resolution.type).to eq(type)
      end
    end

    it "accepts any string as resolution type" do
      resolution = described_class.new(type: "custom_type")
      expect(resolution.type).to eq("custom_type")
    end
  end

  describe "collections" do
    it "handles considerations as a collection" do
      expect(sample_resolution.considerations).to be_an(Array)
      expect(sample_resolution.considerations.first).to be_a(Edoxen::Consideration)
      expect(sample_resolution.considerations.length).to eq(3)
    end

    it "handles approvals as a collection" do
      expect(sample_resolution.approvals).to be_an(Array)
      expect(sample_resolution.approvals.first).to be_a(Edoxen::Approval)
      expect(sample_resolution.approvals.first.type).to eq("affirmative")
    end

    it "handles actions as a collection" do
      expect(sample_resolution.actions).to be_an(Array)
      expect(sample_resolution.actions.first).to be_a(Edoxen::Action)
      expect(sample_resolution.actions.first.type).to eq("resolves")
    end

    it "handles dates as a collection" do
      expect(sample_resolution.dates).to be_an(Array)
      expect(sample_resolution.dates.first).to be_a(Edoxen::ResolutionDate)
      expect(sample_resolution.dates.first.kind).to eq("decision")
    end
  end

  describe "YAML serialization" do
    it "serializes to YAML correctly" do
      yaml_output = sample_resolution.to_yaml

      expect(yaml_output).to include("categories:")
      expect(yaml_output).to include("- Resolutions related to JWG 1")
      expect(yaml_output).to include("title: 'Adoption of NWIP ballot for ISO/PWI 9735-11")
      expect(yaml_output).to include("identifier: 2019-01")
    end

    it "deserializes from YAML correctly" do
      yaml_output = sample_resolution.to_yaml
      parsed_resolution = described_class.from_yaml(yaml_output)

      expect(parsed_resolution.title).to eq(sample_resolution.title)
      expect(parsed_resolution.categories).to eq(sample_resolution.categories)
      expect(parsed_resolution.identifier).to eq(sample_resolution.identifier)
    end

    it "handles round-trip serialization" do
      yaml_output = sample_resolution.to_yaml
      parsed_resolution = described_class.from_yaml(yaml_output)
      second_yaml = parsed_resolution.to_yaml

      expect(yaml_output).to eq(second_yaml)
    end
  end

  describe "JSON serialization" do
    it "serializes to JSON correctly" do
      json_output = sample_resolution.to_json

      expect(json_output).to include('"title":"Adoption of NWIP ballot for ISO/PWI 9735-11')
      expect(json_output).to include('"categories":["Resolutions related to JWG 1"]')
    end

    it "deserializes from JSON correctly" do
      json_output = sample_resolution.to_json
      parsed_resolution = described_class.from_json(json_output)

      expect(parsed_resolution.title).to eq(sample_resolution.title)
      expect(parsed_resolution.categories).to eq(sample_resolution.categories)
    end
  end

  describe "real-world data compatibility" do
    it "loads real-world YAML data correctly" do
      expect(sample_resolution.categories).to eq(["Resolutions related to JWG 1"])
      expect(sample_resolution.title).to include("Adoption of NWIP ballot")
      expect(sample_resolution.identifier).to eq("2019-01")
      expect(sample_resolution.considerations.length).to eq(3)
      expect(sample_resolution.approvals.length).to eq(1)
      expect(sample_resolution.actions.length).to eq(1)
    end

    it "handles different resolution types from fixture" do
      business_plan_resolution = resolution_set.resolutions.find { |r| r.identifier == "2019-20" }

      expect(business_plan_resolution.categories).to eq(["General Resolutions"])
      expect(business_plan_resolution.title).to eq("Approval of the Business Plan")
      expect(business_plan_resolution.actions.first.type).to eq("approves")
    end

    it "handles thanks resolutions" do
      thanks_resolution = resolution_set.resolutions.find { |r| r.identifier == "2019-22" }

      expect(thanks_resolution.categories).to eq(["General Resolutions"])
      expect(thanks_resolution.title).to eq("Appreciation of the meeting host and all participants")
      expect(thanks_resolution.actions.first.type).to eq("thanks")
      expect(thanks_resolution.actions.length).to eq(2)
    end
  end
end
