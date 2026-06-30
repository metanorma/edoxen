# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen do
  describe "VERSION" do
    it "is a frozen semantic string" do
      expect(Edoxen::VERSION).to be_a(String)
      expect(Edoxen::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end

  describe "Error" do
    it "is a StandardError subclass reserved for gem-level raises" do
      expect(Edoxen::Error.ancestors).to include(StandardError)
      err = Edoxen::Error.new("boom")
      expect { raise err }.to raise_error(Edoxen::Error, /boom/)
    end
  end

  describe "ValidationError" do
    it "is an Edoxen::Error subclass — the unified validation shape" do
      expect(Edoxen::ValidationError.ancestors).to include(Edoxen::Error)
    end

    it "renders a clickable file:line:col: message including the pointer" do
      err = Edoxen::ValidationError.new(
        file: "foo.yaml", line: 12, column: 3,
        pointer: "/resolutions/0",
        message_text: "object is missing required property: identifier"
      )
      expect(err.message).to eq("foo.yaml:12:3: object is missing required property: identifier at `/resolutions/0`")
      expect(err.to_clickable_format).to eq(err.message)
      expect(err.source).to eq(:schema)
    end

    it "accepts an empty pointer (root-level errors)" do
      err = Edoxen::ValidationError.new(
        file: "foo.yaml", line: 1, column: 1,
        message_text: "YAML syntax error: oops"
      )
      expect(err.message).to eq("foo.yaml:1:1: YAML syntax error: oops")
    end

    it "carries a source tag (:schema, :model, :syntax) so renderers can branch" do
      schema_err = Edoxen::ValidationError.new(
        file: "x", line: 1, column: 1, message_text: "m",
        source: Edoxen::ValidationError::SOURCE_SCHEMA
      )
      model_err = Edoxen::ValidationError.new(
        file: "x", line: 1, column: 1, message_text: "m",
        source: Edoxen::ValidationError::SOURCE_MODEL
      )
      expect(schema_err.source).to eq(:schema)
      expect(model_err.source).to eq(:model)
    end

    it "stays reachable via the legacy SchemaValidator::ValidationError alias" do
      expect(Edoxen::SchemaValidator::ValidationError).to equal(Edoxen::ValidationError)
    end
  end
end
