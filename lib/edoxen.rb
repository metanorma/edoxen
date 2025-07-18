# frozen_string_literal: true

require "lutaml/model"
require_relative "edoxen/version"

# Configure lutaml-model for YAML serialization
Lutaml::Model::Config.configure do |config|
  config.yaml_adapter_type = :standard_yaml
  config.json_adapter_type = :standard_json
end

module Edoxen
  class Error < StandardError; end

  # Load all model classes
  require_relative "edoxen/action"
  require_relative "edoxen/approval"
  require_relative "edoxen/consideration"
  require_relative "edoxen/meeting"
  require_relative "edoxen/resolution"
  require_relative "edoxen/resolution_collection"
  require_relative "edoxen/resolution_date"
  require_relative "edoxen/resolution_relationship"
  require_relative "edoxen/structured_identifier"
  require_relative "edoxen/subject_body"
  require_relative "edoxen/meeting_identfier"
end
