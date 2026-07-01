# frozen_string_literal: true

require "spec_helper"
require "open3"
require "fileutils"

RSpec.describe "edoxen CLI unlocode subcommand" do
  let(:cli_bin) { File.expand_path("../../exe/edoxen", __dir__) }

  def run_cli(*args)
    env = { "RUBYOPT" => "-I#{File.expand_path("../../lib", __dir__)}" }
    Open3.capture3(env, "bundle", "exec", "ruby", cli_bin, *args,
                   chdir: File.expand_path("../..", __dir__))
  end

  it "resolves a known UN/LOCODE" do
    stdout, _stderr, status = run_cli("unlocode", "FRPAR")
    expect(status.exitstatus).to eq(0)
    expect(stdout).to include("UN/LOCODE:  FRPAR")
    expect(stdout).to include("Paris")
    expect(stdout).to include("Country:   FR")
  end

  it "exits non-zero for an unknown code" do
    _stdout, _stderr, status = run_cli("unlocode", "ZZZZZ")
    expect(status.exitstatus).to eq(1)
  end

  it "accepts lowercase input" do
    stdout, _stderr, status = run_cli("unlocode", "frpar")
    expect(status.exitstatus).to eq(0)
    expect(stdout).to include("FRPAR")
  end
end
