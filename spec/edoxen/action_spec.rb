# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Action do
  let(:fixture_path) { File.join(__dir__, "..", "fixtures", "simple-action.yaml") }
  let(:fixture_yaml) { File.read(fixture_path) }

  describe "attributes" do
    it "has the expected attributes" do
      action = described_class.new

      expect(action).to respond_to(:type)
      expect(action).to respond_to(:dates)
      expect(action).to respond_to(:message)
      expect(action).to respond_to(:subject)
      expect(action).to respond_to(:degree)
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
  end

  describe "date handling" do
    it "accepts ResolutionDate objects for dates" do
      date = Edoxen::ResolutionDate.new(start: "2024-01-15", kind: "effective")
      action = described_class.new(dates: [date])
      expect(action.dates.first).to be_a(Edoxen::ResolutionDate)
      expect(action.dates.first.start).to be_a(Date)
      expect(action.dates.first.start.to_s).to eq("2024-01-15")
    end

    it "handles multiple dates" do
      dates = [
        Edoxen::ResolutionDate.new(start: "2024-01-15", kind: "effective"),
        Edoxen::ResolutionDate.new(start: "2024-02-01", kind: "deadline")
      ]
      action = described_class.new(dates: dates)
      expect(action.dates.length).to eq(2)
      expect(action.dates.first.kind).to eq("effective")
      expect(action.dates.last.kind).to eq("deadline")
    end
  end

  describe "YAML serialization" do
    it "serializes to YAML correctly" do
      action = described_class.from_yaml(fixture_yaml)
      yaml_output = action.to_yaml

      expect(yaml_output).to include("type:")
      expect(yaml_output).to include("resolves")
      expect(yaml_output).to include("dates:")
      expect(yaml_output).to include("start: '2024-01-15'")
      expect(yaml_output).to include("kind: effective")
      expect(yaml_output).to include("message: resolves to implement the new standard")
    end

    it "deserializes from YAML correctly" do
      action = described_class.from_yaml(fixture_yaml)

      expect(action.type).to eq("resolves")
      expect(action.dates.first.start.to_s).to eq("2024-01-15")
      expect(action.dates.first.kind).to eq("effective")
      expect(action.message).to eq("resolves to implement the new standard")
      expect(action.subject).to eq("ISO/TC 154")
      expect(action.degree).to eq("unanimous")
    end

    it "handles round-trip serialization" do
      action = described_class.from_yaml(fixture_yaml)
      yaml_output = action.to_yaml
      parsed_action = described_class.from_yaml(yaml_output)
      second_yaml = parsed_action.to_yaml

      expect(yaml_output).to eq(second_yaml)
    end
  end

  describe "real-world examples" do
    it "handles 'resolves' action type" do
      action = described_class.from_yaml(fixture_yaml)

      expect(action.type).to eq("resolves")
      expect(action.message).to include("implement the new standard")
    end

    it "handles 'requests' action type" do
      yaml_content = <<~YAML
        type: requests
        dates:
          - start: '2019-10-17'
            kind: effective
        message: requests ISO/CS to register the project as ISO/PWI 34100
      YAML

      action = described_class.from_yaml(yaml_content)

      expect(action.type).to eq("requests")
      expect(action.message).to include("ISO/CS")
    end

    it "handles 'thanks' action type" do
      yaml_content = <<~YAML
        type: thanks
        message: warmly thanks Prof Peter Plapper and all participants
      YAML

      action = described_class.from_yaml(yaml_content)

      expect(action.type).to eq("thanks")
      expect(action.message).to include("warmly thanks")
    end

    it "handles 'abrogates' action type" do
      yaml_content = <<~YAML
        type: abrogates
        dates:
          - start: '2019-10-17'
            kind: effective
        message: abrogates ISO/TS 21981.
      YAML

      action = described_class.from_yaml(yaml_content)

      expect(action.type).to eq("abrogates")
      expect(action.message).to include("abrogates")
    end
  end

  describe "edge cases" do
    it "handles actions without dates" do
      yaml_content = <<~YAML
        type: thanks
        message: thanks all participants
      YAML

      action = described_class.from_yaml(yaml_content)

      expect(action.type).to eq("thanks")
      expect(action.dates).to be_nil
    end

    it "handles actions without subject" do
      yaml_content = <<~YAML
        type: resolves
        message: resolves to proceed
      YAML

      action = described_class.from_yaml(yaml_content)

      expect(action.type).to eq("resolves")
      expect(action.subject).to be_nil
    end

    it "handles multiline messages" do
      multiline_message = <<~MSG.strip
        resolves to register a project ISO/PWI TR 19626-3 "Trusted Communication Platforms for Electronic Documents -Part3: implementation guideline". The Part3 should only be published after the publication of Part1 and Part2.
      MSG

      yaml_content = <<~YAML
        type: resolves
        message: |
          #{multiline_message}
      YAML

      action = described_class.from_yaml(yaml_content)

      expect(action.message).to include("Part3 should only be published")
    end
  end
end
