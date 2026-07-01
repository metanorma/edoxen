# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Edoxen::LinkChecker do
  def write(dir, name, content)
    File.write(File.join(dir, name), content)
  end

  it "returns no errors when every URN resolves" do
    Dir.mktmpdir do |dir|
      write(dir, "meeting-1.yaml", <<~YAML)
        ---
        identifier:
        - prefix: CIML
          number: '1'
        urn: urn:oiml:ciml:meeting:ciml-1
        type: plenary
        resolution_refs:
        - urn:oiml:ciml:resolution-collection:ciml-1-resolutions
      YAML
      write(dir, "resolutions.yaml", <<~YAML)
        ---
        metadata:
          meeting_urn: urn:oiml:ciml:meeting:ciml-1
        resolutions: []
      YAML
      expect(described_class.check(dir)).to be_empty
    end
  end

  it "reports a dangling meeting_urn on a ResolutionCollection" do
    Dir.mktmpdir do |dir|
      write(dir, "resolutions.yaml", <<~YAML)
        ---
        metadata:
          meeting_urn: urn:oiml:ciml:meeting:ciml-99
        resolutions: []
      YAML
      errs = described_class.check(dir)
      expect(errs.size).to eq(1)
      expect(errs.first.urn).to eq("urn:oiml:ciml:meeting:ciml-99")
      expect(errs.first.kind).to eq("no matching Meeting")
    end
  end

  it "is tolerant of files that are neither Meetings nor ResolutionCollections" do
    Dir.mktmpdir do |dir|
      write(dir, "noise.yaml", <<~YAML)
        ---
        title: Just metadata
        description: Not a meeting or resolution collection
      YAML
      expect(described_class.check(dir)).to be_empty
    end
  end

  it "ignores malformed YAML silently (returns empty for the file)" do
    Dir.mktmpdir do |dir|
      write(dir, "broken.yaml", "title: [unterminated")
      expect { described_class.check(dir) }.not_to raise_error
    end
  end
end
