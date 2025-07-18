# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::ResolutionCollection do
  describe "attributes" do
    it "has the expected attributes" do
      collection = described_class.new

      expect(collection).to respond_to(:metadata)
      expect(collection).to respond_to(:resolutions)
    end
  end

  describe "metadata handling" do
    it "accepts hash metadata" do
      metadata = {
        title: "Test Collection",
        date: "2024-01-15",
        source: "Test Source"
      }

      collection = described_class.new(metadata: metadata)
      expect(collection.metadata).to eq(metadata)
    end

    it "handles string keys in metadata" do
      metadata = {
        "title" => "Test Collection",
        "date" => "2024-01-15",
        "source" => "Test Source"
      }

      collection = described_class.new(metadata: metadata)
      expect(collection.metadata["title"]).to eq("Test Collection")
    end
  end

  describe "resolutions collection" do
    it "handles empty resolutions array" do
      collection = described_class.new(resolutions: [])
      expect(collection.resolutions).to be_an(Array)
      expect(collection.resolutions).to be_empty
    end

    it "handles array of Resolution objects" do
      resolution1 = Edoxen::Resolution.new(
        title: "First Resolution",
        type: "resolution",
        identifier: "2024-01"
      )
      resolution2 = Edoxen::Resolution.new(
        title: "Second Resolution",
        type: "decision",
        identifier: "2024-02"
      )

      collection = described_class.new(resolutions: [resolution1, resolution2])
      expect(collection.resolutions.length).to eq(2)
      expect(collection.resolutions.first).to be_a(Edoxen::Resolution)
      expect(collection.resolutions.first.title).to eq("First Resolution")
    end
  end

  describe "YAML serialization" do
    let(:collection_data) do
      {
        metadata: {
          title: "Resolutions of the 38th plenary meeting",
          date: "2019-10-17",
          source: "ISO/TC 154 Secretariat"
        },
        resolutions: [
          {
            category: "Technical resolutions",
            title: "Test Resolution 1",
            type: "resolution",
            identifier: "2024-01",
            considerations: [
              {
                type: "considering",
                message: "considering the importance of testing"
              }
            ],
            actions: [
              {
                type: "resolves",
                message: "resolves to implement the solution"
              }
            ]
          },
          {
            category: "Administrative resolutions",
            title: "Test Resolution 2",
            type: "decision",
            identifier: "2024-02"
          }
        ]
      }
    end

    it "serializes to YAML correctly" do
      collection = described_class.new(collection_data)
      yaml_output = collection.to_yaml

      expect(yaml_output).to include("metadata:")
      expect(yaml_output).to include("title: Resolutions of the 38th plenary meeting")
      expect(yaml_output).to include("resolutions:")
      expect(yaml_output).to include("Test Resolution 1")
      expect(yaml_output).to include("Test Resolution 2")
    end

    it "deserializes from YAML correctly" do
      collection = described_class.new(collection_data)
      yaml_output = collection.to_yaml
      parsed_collection = described_class.from_yaml(yaml_output)

      expect(parsed_collection.metadata[:title]).to eq("Resolutions of the 38th plenary meeting")
      expect(parsed_collection.resolutions.length).to eq(collection.resolutions.length)
      expect(parsed_collection.resolutions.first.title).to eq("Test Resolution 1")
      expect(parsed_collection.resolutions.last.title).to eq("Test Resolution 2")
    end

    it "handles round-trip serialization" do
      collection = described_class.new(collection_data)
      yaml_output = collection.to_yaml
      parsed_collection = described_class.from_yaml(yaml_output)
      second_yaml = parsed_collection.to_yaml

      # Parse both YAML outputs to compare structure
      original_data = YAML.safe_load(yaml_output, permitted_classes: [Date, Symbol])
      second_data = YAML.safe_load(second_yaml, permitted_classes: [Date, Symbol])

      expect(original_data["metadata"]).to eq(second_data["metadata"])
      expect(original_data["resolutions"].length).to eq(second_data["resolutions"].length)
    end
  end

  describe "real-world data compatibility" do
    let(:real_world_yaml) do
      <<~YAML
        metadata:
          title: Resolutions of the 38th plenary meeting of ISO/TC 154
          date: 2019-10-17
          source: ISO/TC 154 Secretariat
        resolutions:
          - category: Resolutions related to JWG 1
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
          - category: General Resolutions
            dates:
              - 2019-10-17
            title: "Approval of the Business Plan"
            identifier: 2019-20
            approvals:
              - type: affirmative
                degree: unanimous
                message: The resolution was taken by unanimity.
            actions:
              - type: approves
                date_effective: 2019-10-17
                message: TC 154 approves the revised business plan.
      YAML
    end

    it "loads real-world YAML data correctly" do
      collection = described_class.from_yaml(real_world_yaml)

      expect(collection.metadata["title"]).to eq("Resolutions of the 38th plenary meeting of ISO/TC 154")
      expect(collection.metadata["date"]).to eq(Date.new(2019, 10, 17))
      expect(collection.metadata["source"]).to eq("ISO/TC 154 Secretariat")

      expect(collection.resolutions.length).to eq(2)

      first_resolution = collection.resolutions.first
      expect(first_resolution.category).to eq("Resolutions related to JWG 1")
      expect(first_resolution.identifier).to eq("2019-01")
      expect(first_resolution.considerations.length).to eq(1)
      expect(first_resolution.approvals.length).to eq(1)
      expect(first_resolution.actions.length).to eq(1)

      second_resolution = collection.resolutions.last
      expect(second_resolution.category).to eq("General Resolutions")
      expect(second_resolution.identifier).to eq("2019-20")
      expect(second_resolution.actions.first.type).to eq("approves")
    end

    it "preserves all data through round-trip" do
      collection = described_class.from_yaml(real_world_yaml)
      yaml_output = collection.to_yaml
      reparsed_collection = described_class.from_yaml(yaml_output)

      expect(reparsed_collection.metadata["title"]).to eq(collection.metadata["title"])
      expect(reparsed_collection.resolutions.length).to eq(collection.resolutions.length)

      # Check that nested objects are preserved
      original_first = collection.resolutions.first
      reparsed_first = reparsed_collection.resolutions.first

      expect(reparsed_first.considerations.length).to eq(original_first.considerations.length)
      expect(reparsed_first.approvals.length).to eq(original_first.approvals.length)
      expect(reparsed_first.actions.length).to eq(original_first.actions.length)
    end
  end

  describe "edge cases" do
    it "handles collection with no metadata" do
      collection = described_class.new(resolutions: [])
      expect(collection.metadata).to be_nil
    end

    it "handles collection with no resolutions" do
      collection = described_class.new(
        metadata: { title: "Empty Collection" }
      )
      expect(collection.resolutions).to be_nil
    end

    it "handles empty collection" do
      collection = described_class.new
      yaml_output = collection.to_yaml
      parsed_collection = described_class.from_yaml(yaml_output)

      expect(parsed_collection).to be_a(described_class)
    end
  end

  describe "JSON serialization" do
    let(:simple_collection_data) do
      {
        metadata: {
          title: "Test Collection",
          date: "2024-01-15"
        },
        resolutions: [
          {
            title: "Test Resolution",
            type: "resolution",
            identifier: "2024-01"
          }
        ]
      }
    end

    it "serializes to JSON correctly" do
      collection = described_class.new(simple_collection_data)
      json_output = collection.to_json

      expect(json_output).to include('"title":"Test Collection"')
      expect(json_output).to include('"type":"resolution"')
    end

    it "deserializes from JSON correctly" do
      collection = described_class.new(simple_collection_data)
      json_output = collection.to_json
      parsed_collection = described_class.from_json(json_output)

      expect(parsed_collection.metadata["title"]).to eq("Test Collection")
      expect(parsed_collection.resolutions.first.title).to eq("Test Resolution")
    end
  end
end
