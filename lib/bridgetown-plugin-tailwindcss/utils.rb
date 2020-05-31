require 'thor'

class Utils < Thor

  # @see https://ruby-doc.org/core-2.7.1/Regexp.html#class-Regexp-label-Capturing
  # capture groups
  class Bump
    VERSION_REGEX = /(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)/
    def to_version(type, version)
      from = version
      match = VERSION_REGEX.match(from)

      groups = {
        major: match[:major],
        minor: match[:minor],
        patch: match[:patch]
      }

      return "Improper type given" if groups.keys.include?(type)

      groups[type] = (groups[type].to_i + 1).to_s

      bump_to_zero(type, groups)

      "#{groups[:major]}.#{groups[:minor]}.#{groups[:patch]}"
    end

    private

    def bump_to_zero(type, groups)
      return if type == :patch

      groups[:patch] = "0"

      return if type == :minor

      groups[:minor] = "0"
    end

    def version_change(type, version)
      "Bumping from #{version} to #{to_version(version, type)}"
    end

    def bump_version(type, version = TailwindCss::VERSION)
      say(version_change(type, version), :red)

      @package_json = File.expand_path("package.json")
      @version_file = File.expand_path(File.join(__dir__, "version.rb"))

      [@package_json, @version_file].each do |file|
        gsub_file(file, VERSION_REGEX, to_version(type, version))
      end
    end
  end
end
