require 'thor'

module TailwindCss
  module Utils
    class Actions < Thor
      include Thor::Actions
    end
    # @see https://ruby-doc.org/core-2.7.1/Regexp.html#class-Regexp-label-Capturing
    # capture groups
    class Bump < Thor
      include Thor::Actions

      VERSION_REGEX = /(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)/

      no_commands {
        def current_version
          VERSION
        end

        def bump_version_to_string(string)
          say("Bumping from #{VERSION} to #{string}", :red)

          version_files.each do |file|
            gsub_file(file, VERSION_REGEX, string)
          end
        end

        def bump_version(type, version: VERSION, value: nil)
          say(version_change(type, version: version, value: value), :red)


          version_files.each do |file|
            gsub_file(file, VERSION_REGEX,
                      to_version(type, version: version, value: value))
          end
        end

        private

        def version_files
          @package_json = File.expand_path("package.json")
          @version_file = File.expand_path(File.join(__dir__, "version.rb"))

          [ @package_json, @version_file ]
        end

        def to_version(type, version: nil, value: nil)
          from = version
          match = VERSION_REGEX.match(from)

          groups = {
            major: match[:major],
            minor: match[:minor],
            patch: match[:patch]
          }

          raise "\nYou gave #{type} but the only accepted types are
                #{groups.keys}" unless groups.keys.include?(type)

          groups[type] = value || (groups[type].to_i + 1).to_s

          bump_to_zero(type, groups)

          "#{groups[:major]}.#{groups[:minor]}.#{groups[:patch]}"
        end

        def bump_to_zero(type, groups)
          return if type == :patch

          groups[:patch] = "0"

          return if type == :minor

          groups[:minor] = "0"
        end

        def version_change(type, version: nil, value: nil)
          "Bumping from #{version} to #{to_version(type, version: version, value: value)}"
        end
      }
    end
  end
end
