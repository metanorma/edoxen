# frozen_string_literal: true

require "thor"
require "fileutils"
require_relative "schema_validator"

module Edoxen
  class Cli < Thor
    desc "validate YAML_FILE_PATTERN", "Validate YAML files against Edoxen schema"
    def validate(pattern)
      files = expand_pattern(pattern)

      if files.empty?
        say "No files found matching pattern: #{pattern}", :red
        exit 1
      end

      say "🔍 Validating #{files.size} file(s)...", :blue

      validator = SchemaValidator.new
      valid_count = 0
      invalid_count = 0

      files.each do |file|
        print "  #{File.basename(file)}... "

        # Schema validation
        schema_errors = validator.validate_file(file)

        # Model parsing validation
        model_errors = []
        begin
          content = File.read(file)
          Edoxen::ResolutionSet.from_yaml(content)
        rescue => e
          model_errors << "Model parsing failed: #{e.message}"
        end

        if schema_errors.empty? && model_errors.empty?
          say "✅ VALID", :green
          valid_count += 1
        else
          say "❌ INVALID", :red
          invalid_count += 1

          # Show schema validation errors with clickable links
          unless schema_errors.empty?
            say "    Schema Validation Errors:", :red
            schema_errors.each do |error|
              say "      #{error.to_clickable_format}", :red
            end
          end

          # Show model parsing errors
          unless model_errors.empty?
            say "    Model Parsing Errors:", :red
            model_errors.each do |error|
              say "      #{file}:1:1: #{error}", :red
            end
          end
        end
      end

      say "\n📊 Validation Summary:", :blue
      say "  Valid files: #{valid_count}", :green
      say "  Invalid files: #{invalid_count}", invalid_count > 0 ? :red : :green
      say "  Success rate: #{((valid_count.to_f / files.size) * 100).round(1)}%", :blue

      exit(invalid_count > 0 ? 1 : 0)
    end

    desc "normalize YAML_FILE_PATTERN", "Normalize YAML files using Edoxen schema"
    option :output, type: :string, desc: "Output directory for normalized files"
    option :inplace, type: :boolean, desc: "Modify files in place (no backup)"
    def normalize(pattern)
      if options[:output] && options[:inplace]
        say "Error: Cannot use both --output and --inplace options", :red
        exit 1
      end

      unless options[:output] || options[:inplace]
        say "Error: Must specify either --output or --inplace option", :red
        exit 1
      end

      files = expand_pattern(pattern)

      if files.empty?
        say "No files found matching pattern: #{pattern}", :red
        exit 1
      end

      say "🔄 Normalizing #{files.size} file(s)...", :blue

      success_count = 0
      error_count = 0

      files.each do |file|
        print "  #{File.basename(file)}... "

        begin
          # Load and parse the file
          content = File.read(file)

          # Extract yaml-language-server comment if present
          yaml_language_server_comment = extract_yaml_language_server_comment(content)

          resolution_set = Edoxen::ResolutionSet.from_yaml(content)

          # Normalize by serializing back to YAML
          normalized_yaml = resolution_set.to_yaml

          # Prepend the yaml-language-server comment if it was present
          if yaml_language_server_comment
            normalized_yaml = "#{yaml_language_server_comment}\n#{normalized_yaml}"
          end

          if options[:inplace]
            # Write directly to the original file
            File.write(file, normalized_yaml)
            say "✅ NORMALIZED", :green
          else
            # Write to output directory
            output_file = File.join(options[:output], File.basename(file))
            FileUtils.mkdir_p(File.dirname(output_file))
            File.write(output_file, normalized_yaml)
            say "✅ NORMALIZED → #{output_file}", :green
          end

          success_count += 1
        rescue => e
          say "❌ FAILED", :red
          say "    Error: #{e.message}", :red
          error_count += 1
        end
      end

      say "\n📊 Normalization Summary:", :blue
      say "  Successful: #{success_count}", :green
      say "  Failed: #{error_count}", error_count > 0 ? :red : :green
      say "  Success rate: #{((success_count.to_f / files.size) * 100).round(1)}%", :blue

      if options[:output]
        say "  Output directory: #{options[:output]}", :blue
      elsif options[:inplace]
        say "  Files modified in place", :yellow
      end

      exit(error_count > 0 ? 1 : 0)
    end

    private

    def expand_pattern(pattern)
      # Handle glob patterns
      files = Dir.glob(pattern).select { |f| File.file?(f) }

      # Filter for YAML files
      files.select { |f| f.match?(/\.(ya?ml)$/i) }.sort
    end

    def extract_yaml_language_server_comment(content)
      lines = content.split("\n")

      # Look for yaml-language-server comment in the first few lines
      lines.first(5).each do |line|
        if line.strip.match?(/^#\s*yaml-language-server:\s*\$schema=/)
          return line.rstrip  # Only strip trailing whitespace, keep the #
        end
      end

      nil
    end
  end
end
