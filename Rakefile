# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

task :release do
  Rake.sh "./script/release"
end

def filelist(*strings)
  Rake::FileList.new(strings) do |fl|
    fl.exclude(/node_modules/)
    fl.exclude(/Rakefile/)
    fl.exclude(/\.md/)
    fl.exclude(/\.txt/)
    fl.exclude(/tags/)
  end
end

def file_rename(file, regex, string)
  return nil unless file =~ regex

  new_file = file.gsub(regex, string)
  Rake.mkdir_p(File.dirname(new_file))
  Rake.mv(file, new_file)
end

PLUGIN_NAME = "bridgetown-plugin-tailwindcss"
UNDERSCORE_PLUGIN_NAME = PLUGIN_NAME.gsub(/-/, "_")
MODULE_NAME = "TailwindCss"

SAMPLE_PLUGIN = /sample-plugin/
UNDERSCORE_SAMPLE_PLUGIN = /sample_plugin/
BRIDGETOWN_SAMPLE_PLUGIN = /bridgetown-sample-plugin/
SAMPLE_PLUGIN_MODULE = /SamplePlugin/

ALL_REGEX_ARY = [
  SAMPLE_PLUGIN,
  UNDERSCORE_SAMPLE_PLUGIN,
  BRIDGETOWN_SAMPLE_PLUGIN,
  SAMPLE_PLUGIN_MODULE
]

# Reverse it so files come first, then directories
ALL_FILES = filelist("**/*").reverse

# https://avdi.codes/rake-part-2-file-lists/
namespace :plugin do
  desc "Renames and rewrites files"
  task rename: [:rewrite_files, :rename_files] do
  end

  desc "Renames the plugin"
  task :rename_files do
    ALL_FILES.map do |file|
      file_rename(file, BRIDGETOWN_SAMPLE_PLUGIN, PLUGIN_NAME)
      file_rename(file, SAMPLE_PLUGIN, PLUGIN_NAME)
      file_rename(file, UNDERSCORE_SAMPLE_PLUGIN, UNDERSCORE_PLUGIN_NAME)
    end
  end

  desc "Renames the plugin inside of files"
  task :rewrite_files do
    ALL_FILES.each do |file|
      next if File.directory?(file)

      # Fixes an issue with non-unicode characters
      text = File.read(file).encode("UTF-8", invalid: :replace, replace: "?")

      # Go to next iteration, unless it contains the regex
      next unless ALL_REGEX_ARY.any? { |regex| text =~ regex }

      # Check for /bridgetown-sample-plugin/ first, if that doesnt
      # exist, then check for regular /sample-plugin/
      replacement_text = text.gsub(SAMPLE_PLUGIN_MODULE, MODULE_NAME)
      replacement_text = replacement_text.gsub(BRIDGETOWN_SAMPLE_PLUGIN, PLUGIN_NAME)
      replacement_text = replacement_text.gsub(SAMPLE_PLUGIN, PLUGIN_NAME)
      replacement_text = replacement_text.gsub(UNDERSCORE_SAMPLE_PLUGIN,
                                               UNDERSCORE_PLUGIN_NAME)
      File.open(file, "w") { |file| file.puts replacement_text }
    end
  end
end


