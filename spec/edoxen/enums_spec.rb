# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::Enums do
  # The single source of truth for every enum value used by the gem.
  # Adding/removing a value here is a Schema <-> Ruby change — update
  # `schema/edoxen.yaml` in the same PR. The schema_sync_spec asserts
  # the YAML schema's inline enum arrays stay equal to these constants.

  it "freezes every enum so callers cannot mutate the canonical list" do
    Edoxen::Enums.constants(false).each do |name|
      value = Edoxen::Enums.const_get(name)
      expect(value).to be_frozen, "Edoxen::Enums::#{name} must be frozen"
      expect(value).to all(be_a(String)), "Edoxen::Enums::#{name} must contain only strings"
    end
  end

  it "has no duplicate values within each enum" do
    Edoxen::Enums.constants(false).each do |enum_name|
      value = Edoxen::Enums.const_get(enum_name)
      duplicates = value.group_by(&:itself).select { |_, vs| vs.size > 1 }.keys
      expect(duplicates).to be_empty,
                            "Edoxen::Enums::#{enum_name} contains duplicates: #{duplicates.inspect}"
    end
  end

  it "contains the LUTAML-canonical verb set in ACTION_TYPE" do
    expect(Edoxen::Enums::ACTION_TYPE).to include(
      "adopts", "thanks", "approves", "decides", "declares", "asks",
      "resolves", "confirms", "welcomes", "recommends", "requests"
    )
  end

  it "contains no duplicate values *within* a single enum" do
    Edoxen::Enums.constants(false).each do |enum_name|
      value = Edoxen::Enums.const_get(enum_name)
      duplicates = value.group_by(&:itself).select { |_, vs| vs.size > 1 }.keys
      expect(duplicates).to be_empty,
                            "Edoxen::Enums::#{enum_name} contains duplicates: #{duplicates.inspect}"
    end
  end

  it "documents which values are intentionally shared across enums (LUTAML quirk)" do
    # The LutaML canonical model declares "empowers" in both ActionType
    # and ConsiderationType. This is a documented imperfection upstream;
    # we mirror it verbatim and explicitly call out the overlap here so a
    # future cleanup is intentional, not an accidental drift.
    expect(Edoxen::Enums::ACTION_TYPE).to include("empowers")
    expect(Edoxen::Enums::CONSIDERATION_TYPE).to include("empowers")
  end

  it "contains the LUTAML-canonical verb set in CONSIDERATION_TYPE" do
    expect(Edoxen::Enums::CONSIDERATION_TYPE).to include(
      "having", "noting", "considering", "accepts", "observing", "referring"
    )
  end
end
