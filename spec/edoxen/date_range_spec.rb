# frozen_string_literal: true

require "spec_helper"

RSpec.describe Edoxen::DateRange do
  it "round-trips a start + end pair" do
    dr = described_class.from_yaml(YAML.dump("start" => "2024-01-01", "end" => "2024-01-05"))
    expect(dr.start).to eq(Date.new(2024, 1, 1))
    expect(dr.end).to eq(Date.new(2024, 1, 5))

    reload = described_class.from_yaml(dr.to_yaml)
    expect(reload.start).to eq(Date.new(2024, 1, 1))
    expect(reload.end).to eq(Date.new(2024, 1, 5))
  end
end
