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
end
