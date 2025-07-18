# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Action do
  describe "attributes" do
    it "has the expected attributes" do
      action = described_class.new

      expect(action).to respond_to(:type)
      expect(action).to respond_to(:date_effective)
      expect(action).to respond_to(:message)
      expect(action).to respond_to(:subject)
    end
  end

  describe "type validation" do
    let(:valid_action_types) do
      %w[
        adopts thanks approves decides declares asks invites resolves confirms
        welcomes recommends requests congratulates instructs urges appoints
        calls-upon encourages affirms elects authorizes charges states remarks
        judges sanctions abrogates empowers
      ]
    end

    it "accepts all valid action types" do
      valid_action_types.each do |type|
        action = described_class.new(type: type)
        expect(action.type).to eq(type)
      end
    end

    it "accepts any string as action type" do
      action = described_class.new(type: "custom_action_type")
      expect(action.type).to eq("custom_action_type")
    end
  end

  describe "date handling" do
    it "accepts Date objects for date_effective" do
      date = Date.new(2024, 1, 15)
      action = described_class.new(date_effective: date)
      expect(action.date_effective).to eq(date)
    end

    it "handles string dates" do
      action = described_class.new(date_effective: "2024-01-15")
      expect(action.date_effective).to be_a(Date)
      expect(action.date_effective.year).to eq(2024)
    end
  end

  describe "YAML serialization" do
    let(:action_data) do
      {
        type: "resolves",
        date_effective: Date.new(2024, 1, 15),
        message: "resolves to implement the new standard"
      }
    end

    it "serializes to YAML correctly" do
      action = described_class.new(action_data)
      yaml_output = action.to_yaml

      expect(yaml_output).to include("type: resolves")
      expect(yaml_output).to include("date_effective: '2024-01-15'")
      expect(yaml_output).to include("message: resolves to implement the new standard")
    end

    it "deserializes from YAML correctly" do
      action = described_class.new(action_data)
      yaml_output = action.to_yaml
      parsed_action = described_class.from_yaml(yaml_output)

      expect(parsed_action.type).to eq(action.type)
      expect(parsed_action.date_effective).to eq(action.date_effective)
      expect(parsed_action.message).to eq(action.message)
    end

    it "handles round-trip serialization" do
      action = described_class.new(action_data)
      yaml_output = action.to_yaml
      parsed_action = described_class.from_yaml(yaml_output)
      second_yaml = parsed_action.to_yaml

      expect(yaml_output).to eq(second_yaml)
    end
  end

  describe "real-world examples" do
    it "handles 'resolves' action type" do
      action = described_class.new(
        type: "resolves",
        date_effective: Date.new(2019, 10, 17),
        message: "resolves to submit ISO 9735-11 for NWIP ballot again by end of this year."
      )

      expect(action.type).to eq("resolves")
      expect(action.message).to include("submit ISO 9735-11")
    end

    it "handles 'requests' action type" do
      action = described_class.new(
        type: "requests",
        date_effective: Date.new(2019, 10, 17),
        message: "requests ISO/CS to register the project as ISO/PWI 34100"
      )

      expect(action.type).to eq("requests")
      expect(action.message).to include("ISO/CS")
    end

    it "handles 'thanks' action type" do
      action = described_class.new(
        type: "thanks",
        message: "warmly thanks Prof Peter Plapper and all participants"
      )

      expect(action.type).to eq("thanks")
      expect(action.message).to include("warmly thanks")
    end

    it "handles 'abrogates' action type" do
      action = described_class.new(
        type: "abrogates",
        date_effective: Date.new(2019, 10, 17),
        message: "abrogates ISO/TS 21981."
      )

      expect(action.type).to eq("abrogates")
      expect(action.message).to include("abrogates")
    end
  end

  describe "edge cases" do
    it "handles actions without date_effective" do
      action = described_class.new(
        type: "thanks",
        message: "thanks all participants"
      )

      expect(action.type).to eq("thanks")
      expect(action.date_effective).to be_nil
    end

    it "handles actions without subject" do
      action = described_class.new(
        type: "resolves",
        message: "resolves to proceed"
      )

      expect(action.type).to eq("resolves")
      expect(action.subject).to be_nil
    end

    it "handles multiline messages" do
      multiline_message = <<~MSG.strip
        resolves to register a project ISO/PWI TR 19626-3 "Trusted Communication Platforms for Electronic Documents -Part3: implementation guideline". The Part3 should only be published after the publication of Part1 and Part2.
      MSG

      action = described_class.new(
        type: "resolves",
        message: multiline_message
      )

      expect(action.message).to include("Part3 should only be published")
    end
  end
end
