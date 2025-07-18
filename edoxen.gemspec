# frozen_string_literal: true

require_relative "lib/edoxen/version"

Gem::Specification.new do |spec|
  spec.name = "edoxen"
  spec.version = Edoxen::VERSION
  spec.authors = ["Ribose Inc."]
  spec.email = ["open.source@ribose.com"]

  spec.summary = "Edoxen is a set of information models used for representing resolution and decision information."
  spec.description = <<~HEREDOC
    Edoxen provides a Ruby library for working with resolution models, allowing
    users to create, manipulate, and serialize resolution data in a structured
    format. It is built on top of the lutaml-model serialization framework,
    which provides a flexible and extensible way to define data models and
    serialize them to YAML or JSON formats.
  HEREDOC

  spec.homepage = "https://github.com/metanorma/edoxen"
  spec.license = "BSD-2-Clause"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/metanorma/edoxen"
  spec.metadata["changelog_uri"] = "https://github.com/metanorma/edoxen"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "lutaml-model", "~> 0.7"
end
