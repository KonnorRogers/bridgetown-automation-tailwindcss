# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

PLUGIN_NAME = "bridgetown-plugin-tailwindcss"

MODULE_NAME = "TailwindCss"
MODULE_REGEXP = /SamplePlugin/

def filelist(*strings)
  Rake::FileList.new(strings) do |fl|
    fl.exclude(/node_modules/)
    fl.exclude(/Rakefile/)
    fl.exclude(/\.md/)
    fl.exclude(/\.txt/)
  end
end

PLUGIN_FILES = filelist("**/*sample-plugin**")
ALL_FILES = filelist("**/*")

# https://avdi.codes/rake-part-2-file-lists/
namespace :plugin do
  desc "Renames the plugin"
  task :rename_files do
    PLUGIN_FILES.each do |file|
      if file =~ /bridgetown-sample-plugin/
        new_file = file.gsub(/bridgetown-sample-plugin/, PLUGIN_NAME)
        File.rename(file, new_file)
      elsif file =~ /.*sample-plugin.*/
        new_file = file.gsub(/sample-plugin/, PLUGIN_NAME)
        File.rename(file, new_file)
      end
    end
  end

  desc "Renames the plugin inside of files"
  task :rename_plugin do
    ALL_FILES.each do |file|
      next if File.directory?(file)

      text = File.read(file)
      replacement_text = text.gsub(MODULE_REGEXP, MODULE_NAME)
      File.open(file, "w") { |file| file.puts replacement_text }
    end
  end
end
