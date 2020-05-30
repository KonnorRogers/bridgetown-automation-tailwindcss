# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

plugin_name = "bridgetown-plugin-tailwindcss"

# https://avdi.codes/rake-part-2-file-lists/
namespace :plugin do
  PLUGIN_FILES = Rake::FileList["**/*sample-plugin**"] do |fl|
    fl.exclude("node_modules")
    # files = Rake::FileList[regexp]
  end

  desc "Renames the plugin"
  task :rename do
    PLUGIN_FILES.each do |file|
      next unless file =~ /bridgetown-sample-plugin.gemspec/

      ext = file.pathmap("%x")
      File.rename(file, "#{plugin_name}#{ext}")
    end
  end
end
