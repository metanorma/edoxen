# frozen_string_literal: true

module Edoxen
  # Base class for any Edoxen-level error. Reserved for raise-on-failure paths;
  # schema validation errors live under SchemaValidator::ValidationError.
  class Error < StandardError; end
end
