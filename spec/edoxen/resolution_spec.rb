# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Resolution do
  describe "attributes" do
    it "has the expected attributes" do
      resolution = described_class.new

      expect(resolution).to respond_to(:category)
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
      consideration = Edoxen::Consideration.new(
        type: "considering",
        message: "Test consideration"
      )

      resolution = described_class.new(considerations: [consideration])
      expect(resolution.considerations).to be_an(Array)
      expect(resolution.considerations.first).to be_a(Edoxen::Consideration)
    end

    it "handles approvals as a collection" do
      approval = Edoxen::Approval.new(
        type: "affirmative",
        degree: "unanimous"
      )

      resolution = described_class.new(approvals: [approval])
      expect(resolution.approvals).to be_an(Array)
      expect(resolution.approvals.first).to be_a(Edoxen::Approval)
    end

    it "handles actions as a collection" do
      action = Edoxen::Action.new(
        type: "resolves",
        message: "Test action"
      )

      resolution = described_class.new(actions: [action])
      expect(resolution.actions).to be_an(Array)
      expect(resolution.actions.first).to be_a(Edoxen::Action)
    end

    it "handles dates as a collection" do
      dates = [Date.new(2024, 1, 15), Date.new(2024, 1, 16)]
      resolution = described_class.new(dates: dates)

      expect(resolution.dates).to be_an(Array)
      expect(resolution.dates.length).to eq(2)
      expect(resolution.dates.first).to be_a(Date)
    end
  end

  describe "YAML serialization" do
    let(:resolution_data) do
      {
        category: "Technical resolutions",
        dates: [Date.new(2024, 1, 15)],
        subject: "ISO/TC 154",
        title: "Test Resolution",
        type: "resolution",
        identifier: "2024-01",
        considerations: [
          {
            type: "considering",
            date_effective: Date.new(2024, 1, 15),
            message: "considering the importance of testing"
          }
        ],
        approvals: [
          {
            type: "affirmative",
            degree: "unanimous",
            message: "Approved unanimously"
          }
        ],
        actions: [
          {
            type: "resolves",
            date_effective: Date.new(2024, 1, 15),
            message: "resolves to implement the solution"
          }
        ]
      }
    end

    it "serializes to YAML correctly" do
      resolution = described_class.new(resolution_data)
      yaml_output = resolution.to_yaml

      expect(yaml_output).to include("category: Technical resolutions")
      expect(yaml_output).to include("title: Test Resolution")
      expect(yaml_output).to include("type: resolution")
      expect(yaml_output).to include("identifier: 2024-01")
    end

    it "deserializes from YAML correctly" do
      resolution = described_class.new(resolution_data)
      yaml_output = resolution.to_yaml
      parsed_resolution = described_class.from_yaml(yaml_output)

      expect(parsed_resolution.title).to eq(resolution.title)
      expect(parsed_resolution.type).to eq(resolution.type)
      expect(parsed_resolution.category).to eq(resolution.category)
      expect(parsed_resolution.identifier).to eq(resolution.identifier)
    end

    it "handles round-trip serialization" do
      resolution = described_class.new(resolution_data)
      yaml_output = resolution.to_yaml
      parsed_resolution = described_class.from_yaml(yaml_output)
      second_yaml = parsed_resolution.to_yaml

      expect(yaml_output).to eq(second_yaml)
    end
  end

  describe "JSON serialization" do
    let(:resolution_data) do
      {
        title: "Test Resolution",
        type: "resolution",
        category: "Technical",
        identifier: "2024-01"
      }
    end

    it "serializes to JSON correctly" do
      resolution = described_class.new(resolution_data)
      json_output = resolution.to_json

      expect(json_output).to include('"title":"Test Resolution"')
      expect(json_output).to include('"type":"resolution"')
    end

    it "deserializes from JSON correctly" do
      resolution = described_class.new(resolution_data)
      json_output = resolution.to_json
      parsed_resolution = described_class.from_json(json_output)

      expect(parsed_resolution.title).to eq(resolution.title)
      expect(parsed_resolution.type).to eq(resolution.type)
    end
  end

  describe "real-world data compatibility" do
    let(:real_world_yaml) do
      <<~YAML
        category: Resolutions related to JWG 1
        dates:
          - 2019-10-17
        subject: ISO/TC 154 Processes, data elements and documents in commerce, industry and administration
        title: "Adoption of NWIP ballot for ISO/PWI 9735-11"
        identifier: 2019-01
        considerations:
          - type: considering
            date_effective: 2019-10-17
            message: considering the voting result
        approvals:
          - type: affirmative
            degree: unanimous
            message: The resolution was taken by unanimity.
        actions:
          - type: resolves
            date_effective: 2019-10-17
            message: resolves to submit ISO 9735-11 for NWIP ballot
      YAML
    end

    it "loads real-world YAML data correctly" do
      resolution = described_class.from_yaml(real_world_yaml)

      expect(resolution.category).to eq("Resolutions related to JWG 1")
      expect(resolution.title).to include("Adoption of NWIP ballot")
      expect(resolution.identifier).to eq("2019-01")
      expect(resolution.considerations.length).to eq(1)
      expect(resolution.approvals.length).to eq(1)
      expect(resolution.actions.length).to eq(1)
    end
  end
end
