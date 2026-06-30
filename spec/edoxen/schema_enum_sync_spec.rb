# frozen_string_literal: true

require "spec_helper"

# Mapping from each schema `$defs` enum-name to the Ruby constant in
# `lib/edoxen/enums.rb`. Declared outside the describe block so rubocop
# doesn't flag it as `Lint/ConstantDefinitionInBlock`.
SCHEMA_ENUM_BINDINGS = {
  "ActionType" => :ACTION_TYPE,
  "ConsiderationType" => :CONSIDERATION_TYPE,
  "ApprovalType" => :APPROVAL_TYPE,
  "ApprovalDegree" => :APPROVAL_DEGREE,
  "ResolutionType" => :RESOLUTION_TYPE,
  "ResolutionDateType" => :RESOLUTION_DATE_TYPE,
  "ResolutionRelationType" => :RESOLUTION_RELATION_TYPE,
  "UrlKind" => :URL_KIND
}.freeze

# Schema <-> Ruby enum sync. The schema in `schema/edoxen.yaml` MUST agree,
# value-for-value, with the constants in `Edoxen::Enums`. Adding a value in
# one without the other is a future-bug; this spec fails at runtime.
RSpec.describe "Schema <-> Ruby enum sync" do
  let(:schema) { YAML.safe_load(File.read("schema/edoxen.yaml")) }
  let(:defs) { schema.fetch("$defs") }

  SCHEMA_ENUM_BINDINGS.each do |enum_name, ruby_const|
    describe "##{enum_name}" do
      it "matches Edoxen::Enums::#{ruby_const} value-for-value" do
        schema_entry = defs.fetch(enum_name)
        expect(schema_entry["type"]).to eq("string"),
                                        "$defs/#{enum_name} must declare type=string"
        schema_values = Array(schema_entry["enum"])
        ruby_values = Edoxen::Enums.const_get(ruby_const)
        expect(schema_values).to match_array(ruby_values),
                                 "schema $defs/#{enum_name} (=#{schema_values.inspect}) " \
                                 "differs from Edoxen::Enums::#{ruby_const} (=#{ruby_values.inspect}); " \
                                 "update both in the same commit."
      end
    end
  end

  it "every enum declared in the schema is bound to a Ruby constant" do
    schema_enum_defs = defs.keys.select do |name|
      defs[name]["type"] == "string" && defs[name]["enum"].is_a?(Array)
    end
    schema_enum_defs.each do |enum_name|
      expect(SCHEMA_ENUM_BINDINGS).to have_key(enum_name),
                                        "$defs/#{enum_name} is declared in schema/edoxen.yaml but has no Ruby binding"
    end
  end
end
