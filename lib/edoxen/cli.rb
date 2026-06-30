# frozen_string_literal: true

require "thor"
require "fileutils"

module Edoxen
  # Thor command-line surface for the gem. Two responsibilities:
  #   * `validate PATTERN` — runs both JSON-Schema validation and the
  #     Ruby model parser against each matching YAML file.
  #   * `normalize PATTERN (--output DIR | --inplace)` — round-trips each
  #     matching YAML file through the Ruby model, preserving any
  #     `# yaml-language-server: $schema=...` directive on the first line.
  #
  # The CLI deliberately does NOT own schema-or-model decisions — those
  # live in `SchemaValidator` and `Lutaml::Model` respectively. It only
  # glues them together and formats output.
  class Cli < Thor
    package_name "edoxen"

    desc "validate YAML_FILE_PATTERN",
         "Validate one or more Edoxen YAML files against the schema and the model."

    def validate(pattern)
      files = expand_yaml_pattern(pattern)
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

        schema_errors = validator.validate_file(file)
        model_errors = collect_model_errors(file)

        if schema_errors.empty? && model_errors.empty?
          say "✅ VALID", :green
          valid_count += 1
        else
          say "❌ INVALID", :red
          invalid_count += 1
          schema_errors.each { |e| say "    #{e.to_clickable_format}", :red }
          model_errors.each { |m| say "    #{file}:1:1: #{m}", :red }
        end
      end

      print_summary(files.size, valid_count, invalid_count, validator_type: :binary)
      exit(invalid_count.positive? ? 1 : 0)
    end

    desc "normalize YAML_FILE_PATTERN",
         "Round-trip YAML file(s) through the Edoxen model (--output DIR or --inplace)."

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

      files = expand_yaml_pattern(pattern)
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
          yaml_language_server_comment = extract_yaml_language_server_comment(File.read(file))
          normalized = ResolutionCollection.from_yaml(File.read(file)).to_yaml
          normalized = "#{yaml_language_server_comment}\n#{normalized}" if yaml_language_server_comment

          if options[:inplace]
            File.write(file, normalized)
            say "✅ NORMALIZED", :green
          else
            out = File.join(options[:output], File.basename(file))
            FileUtils.mkdir_p(File.dirname(out))
            File.write(out, normalized)
            say "✅ NORMALIZED → #{out}", :green
          end
          success_count += 1
        rescue StandardError => e
          say "❌ FAILED — #{e.message}", :red
          error_count += 1
        end
      end

      print_summary(files.size, success_count, error_count, validator_type: :lax,
                                                            extra: [
                                                              ["  Output directory", options[:output]],
                                                              ["  Mode", options[:inplace] ? "in place" : "--output"]
                                                            ].compact)
      exit(error_count.positive? ? 1 : 0)
    end

    no_commands do
      # Reserved for private Thor plumbing if we add it later.
    end

    private

    def expand_yaml_pattern(pattern)
      Dir.glob(pattern).select { |f| File.file?(f) && f.match?(/\.ya?ml\z/i) }.sort
    end

    # Round-trip the file through the model to catch structural issues
    # (missing nested classes, type mismatches) that the JSON-Schema can't
    # express. The model is permissive about field names — schema is the
    # strict source.
    def collect_model_errors(file)
      ResolutionCollection.from_yaml(File.read(file))
      []
    rescue StandardError => e
      ["Model parsing failed: #{e.message}"]
    end

    def extract_yaml_language_server_comment(content)
      lines = content.split("\n").first(5)
      lines.find { |l| l.strip.match?(/\A#\s*yaml-language-server:\s*\$schema=/) }&.rstrip
    end

    def print_summary(total, ok_count, bad_count, validator_type:, extra: [])
      say "\n📊 Summary:", :blue
      say "  Total: #{total}", :blue
      label_text = if validator_type == :binary
                     "  Valid: #{ok_count}, Invalid: #{bad_count}"
                   else
                     "  Success: #{ok_count}, Failed: #{bad_count}"
                   end
      say label_text, bad_count.positive? ? :red : :green
      success_rate = total.zero? ? 0 : ((ok_count.to_f / total) * 100).round(1)
      say "  Success rate: #{success_rate}%", :blue
      extra.each { |label, value| say "  #{label}: #{value}", :blue }
    end
  end
end
