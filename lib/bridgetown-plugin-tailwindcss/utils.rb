# frozen_string_literal: true

require "thor"

module TailwindCss
  module Utils
    class Action < Thor
      include Thor::Actions
    end
    # @see https://ruby-doc.org/core-2.7.1/Regexp.html#class-Regexp-label-Capturing
    # capture groups
    class Bump < Thor
      include Thor::Actions

      RUBY_VERSION_REGEX = %r!(.*VERSION.?=.*)!.freeze
      NPM_VERSION_REGEX = %r!(.*"version":.*)!.freeze
      VERSION_LINE = Regexp.union(RUBY_VERSION_REGEX, NPM_VERSION_REGEX)
      VERSION_REGEX = %r!(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)!.freeze
      GSUB_REGEX = %r!(?<version>#{VERSION_LINE})#{VERSION_REGEX}!.freeze

      # rubocop:disable Metrics/BlockLength
      no_commands do
        def current_version
          VERSION
        end

        def bump_version_to_string(string)
          say("Bumping from #{VERSION} to #{string}", :red)

          match = GSUB_REGEX.match(File.read(file))
          gsub_string = "#{match[:version]}#{string}"
          version_files.each do |file|
            gsub_file(file, GSUB_REGEX, gsub_string)
          end
        end

        def bump_version(type, version: VERSION)
          say(version_change(type, version: version), :red)

          version_files.each do |file|
            match = GSUB_REGEX.match(File.read(file))
            gsub_string = "#{match[:version]}#{to_version(type, version: version)}"

            gsub_file(file, GSUB_REGEX,
                      gsub_string)
          end
        end

        private

        def gsub_match(file)
          GSUB_REGEX.match(File.read(file))
        end

        def version_files
          package_json = File.expand_path("package.json")
          version_file = File.expand_path(File.join(__dir__, "version.rb"))

          [package_json, version_file]
        end

        # ef version_replacement
        #   match = GSUB_REGEX.match(File.readlines
        # end

        def to_version(type, version: nil)
          from = version
          match = VERSION_REGEX.match(from)

          groups = {
            major: match[:major],
            minor: match[:minor],
            patch: match[:patch],
          }

          unless groups.key?(type)
            raise "\nYou gave #{type} but the only accepted types are
                  #{groups.keys}"
          end

          groups[type] = (groups[type].to_i + 1).to_s

          bump_to_zero(type, groups)

          "#{groups[:major]}.#{groups[:minor]}.#{groups[:patch]}"
        end

        def bump_to_zero(type, groups)
          return if type == :patch

          groups[:patch] = "0"

          return if type == :minor

          groups[:minor] = "0"
        end

        def version_change(type, version: nil)
          "Bumping from #{version} to #{to_version(type, version: version)}"
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
