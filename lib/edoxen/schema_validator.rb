# frozen_string_literal: true

require "json_schemer"
require "yaml"
require "json"
require "psych"

module Edoxen
  class SchemaValidator
    class ValidationError < StandardError
      attr_reader :file, :line, :column, :message, :data_pointer

      def initialize(file, line, column, message, data_pointer = nil)
        @file = file
        @line = line
        @column = column
        @message = message
        @data_pointer = data_pointer
        super("#{file}:#{line}:#{column}: #{message}")
      end

      def to_clickable_format
        "#{file}:#{line}:#{column}: #{message}"
      end
    end

    # Custom YAML handler to track line numbers
    class LineTrackingHandler < Psych::Handler
      attr_reader :line_map, :path_stack, :array_indices

      def initialize
        @line_map = {}
        @path_stack = []
        @array_indices = {}
        @current_path = ""
      end

      def start_document(version, tag_directives, implicit)
        # Document start
      end

      def start_mapping(anchor, tag, implicit, style)
        # Starting a new mapping/object
      end

      def start_sequence(_anchor, _tag, _implicit, _style)
        # Starting a new sequence/array
        parent_path = "/#{@path_stack.join("/")}"
        parent_path = "" if parent_path == "/"
        @array_indices[parent_path] = -1
      end

      def scalar(value, anchor, tag, plain, quoted, style)
        # This is called for each scalar value
        # We need to track this in context of the current path
      end

      def alias(anchor)
        # Handle YAML aliases
      end

      def end_sequence
        # End of sequence/array
      end

      def end_mapping
        # End of mapping/object
      end

      def end_document(implicit)
        # Document end
      end
    end

    def initialize(schema_path = nil)
      @schema_path = schema_path || File.join(__dir__, "..", "..", "schema", "edoxen.yaml")
      @schemer = nil
      load_schema
    end

    def validate_file(file_path)
      return [ValidationError.new(file_path, 1, 1, "File not found")] unless File.exist?(file_path)

      content = File.read(file_path)
      validate_content(content, file_path)
    end

    def validate_content(content, file_path)
      errors = []

      begin
        # Parse YAML and build line map
        yaml_data, line_map = parse_yaml_with_line_tracking(content)

        # Validate against schema
        if @schemer
          schema_errors = @schemer.validate(yaml_data).to_a
          errors.concat(convert_schema_errors(schema_errors, file_path, line_map))
        else
          errors << ValidationError.new(file_path, 1, 1, "Schema not available for validation")
        end
      rescue Psych::SyntaxError => e
        line = e.line || 1
        column = e.column || 1
        errors << ValidationError.new(file_path, line, column, "YAML syntax error: #{e.problem}")
      rescue StandardError => e
        errors << ValidationError.new(file_path, 1, 1, "Validation error: #{e.message}")
      end

      errors
    end

    private

    def load_schema
      return unless File.exist?(@schema_path)

      begin
        schema_content = File.read(@schema_path)
        schema_data = YAML.safe_load(schema_content)
        @schemer = JSONSchemer.schema(schema_data)
      rescue StandardError => e
        warn "Warning: Could not load schema from #{@schema_path}: #{e.message}"
        @schemer = nil
      end
    end

    def parse_yaml_with_line_tracking(content)
      # Parse YAML normally
      yaml_data = YAML.safe_load(content)

      # Build line map by parsing the content line by line
      line_map = build_line_map(content)

      [yaml_data, line_map]
    end

    def build_line_map(content)
      line_map = {}
      lines = content.split("\n")
      path_stack = []
      array_indices = {}

      lines.each_with_index do |line, index|
        line_number = index + 1
        stripped = line.strip

        # Skip empty lines and comments
        next if stripped.empty? || stripped.start_with?("#")

        # Calculate indentation
        indent = line.length - line.lstrip.length
        level = indent / 2 # Assuming 2-space indentation

        # Adjust path stack based on indentation level
        path_stack = path_stack[0, level] if level < path_stack.length

        if stripped.start_with?("- ")
          # Array item
          parent_path = path_stack.empty? ? "" : "/#{path_stack.join("/")}"
          array_indices[parent_path] ||= -1
          array_indices[parent_path] += 1

          array_index = array_indices[parent_path]
          current_path = "#{parent_path}/#{array_index}"
          line_map[current_path] = line_number

          # Check if array item has a key
          item_content = stripped[2..].strip
          if item_content.include?(":")
            key = item_content.split(":").first.strip.gsub(/["']/, "")
            if key.empty?
              path_stack = path_stack[0, level] + [array_index.to_s]
            else
              key_path = "#{current_path}/#{key}"
              line_map[key_path] = line_number
              path_stack = path_stack[0, level] + [array_index.to_s, key]
            end
          else
            path_stack = path_stack[0, level] + [array_index.to_s]
          end
        elsif stripped.include?(":")
          # Regular key-value pair
          key = stripped.split(":").first.strip.gsub(/["']/, "")
          next if key.empty?

          path_stack = path_stack[0, level] + [key]
          current_path = "/#{path_stack.join("/")}"
          line_map[current_path] = line_number

          # Reset array indices for this path and deeper
          array_indices.each_key do |path|
            array_indices.delete(path) if path.start_with?(current_path)
          end
        end
      end

      line_map
    end

    def convert_schema_errors(schema_errors, file_path, line_map)
      schema_errors.map do |error|
        data_pointer = error["data_pointer"] || ""
        line = find_line_for_pointer(data_pointer, line_map)
        column = 1

        message = build_error_message(error)

        ValidationError.new(file_path, line, column, message, data_pointer)
      end
    end

    def find_line_for_pointer(pointer, line_map)
      return 1 if pointer.empty?

      # Try exact match first
      return line_map[pointer] if line_map[pointer]

      # Try progressively shorter paths
      parts = pointer.split("/").reject(&:empty?)
      (parts.length - 1).downto(0) do |i|
        partial_path = "/#{parts[0..i].join("/")}"
        return line_map[partial_path] if line_map[partial_path]
      end

      # For paths like /resolutions/0/actions/0/type, try to find the specific action
      if parts.length >= 4 && parts[0] == "resolutions" && parts[2] == "actions"
        # Try to find the specific action line
        resolution_index = parts[1]
        action_index = parts[3]
        parts[4] if parts.length > 4

        # Look for patterns like /resolutions/0/actions/0
        action_path = "/resolutions/#{resolution_index}/actions/#{action_index}"
        return line_map[action_path] if line_map[action_path]

        # Look for the actions array start
        actions_path = "/resolutions/#{resolution_index}/actions"
        return line_map[actions_path] if line_map[actions_path]
      end

      # Try to find the closest match by looking for the last non-numeric part
      if parts.any?
        parts.reverse.each do |part|
          next if part.match?(/^\d+$/) # Skip array indices

          line_map.each do |path, line|
            return line if path.end_with?("/#{part}")
          end
        end
      end

      # Default to line 1
      1
    end

    def build_error_message(error)
      type = error["type"]
      details = error["details"] || {}
      data_pointer = error["data_pointer"] || ""

      base_message = case type
                     when "required"
                       missing = details["missing_keys"] || []
                       if missing.length == 1
                         "object is missing required property: #{missing.first}"
                       else
                         "object is missing required properties: #{missing.join(", ")}"
                       end
                     when "additionalProperties"
                       extra = details["extra_keys"] || []
                       if extra.length == 1
                         "object property '#{extra.first}' is a disallowed additional property"
                       else
                         "object properties #{extra.map do |k|
                           "'#{k}'"
                         end.join(", ")} are disallowed additional properties"
                       end
                     when "enum"
                       value = details["value"]
                       valid_values = details["valid_values"] || []
                       "value '#{value}' is not one of: #{valid_values}"
                     when "type"
                       details["actual_type"]
                       expected = details["expected_types"] || []
                       "value is not #{expected.join(" or ")}"
                     else
                       error["error"] || "validation failed"
                     end

      # Add data pointer for debugging if it's not empty
      if !data_pointer.empty?
        "#{base_message} at `#{data_pointer}`"
      else
        base_message
      end
    end
  end
end
