# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

def filelist(*strings)
  Rake::FileList.new(strings) do |fl|
    fl.exclude(/node_modules/)
    fl.exclude(/Rakefile/)
    fl.exclude(/\.md/)
    fl.exclude(/\.txt/)
  end
end

def file_rename(file, regex, string)
  return nil unless file =~ regex

  new_file = file.gsub(regex, string)
  File.rename(file, new_file)
end

PLUGIN_NAME = "bridgetown-plugin-tailwindcss"
MODULE_NAME = "TailwindCss"

SAMPLE_PLUGIN = /sample-plugin/
BRIDGETOWN_SAMPLE_PLUGIN = /bridgetown-sample-plugin/
SAMPLE_PLUGIN_MODULE = /SamplePlugin/

PLUGIN_FILES = filelist("**/*sample-plugin**")
ALL_FILES = filelist("**/*")

# https://avdi.codes/rake-part-2-file-lists/
namespace :plugin do
  desc "Renames the plugin"
  task :rename_files do
    PLUGIN_FILES.each do |file|
      # fixes bridgetown_sample_plugin.gemspec
      next if file_rename(file + ".backup", BRIDGETOWN_SAMPLE_PLUGIN, PLUGIN_NAME)

      # fixes everything else
      file_rename(file + ".backup", SAMPLE_PLUGIN, PLUGIN_NAME)
    end
  end

  desc "Renames the plugin inside of files"
  task :rename_plugin do
    ALL_FILES.each do |file|
      next if File.directory?(file)

      text = File.read(file).encode("UTF-8", invalid: :replace, replace: "?")
      replacement_text = text.gsub(SAMPLE_PLUGIN_MODULE, MODULE_NAME)
      replacement_text = text.gsub(SAMPLE_PLUGIN, PLUGIN_NAME)
      File.open(file + ".backup", "w") { |file| file.puts replacement_text }
    end
  end
end


