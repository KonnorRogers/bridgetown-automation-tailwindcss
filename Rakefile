# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# https://avdi.codes/rake-part-2-file-lists/
namespace :plugin do
  PLUGIN_FILES = Rake::FileList["**/*sample-plugin**", "**sample-plugin**"] do |fl|
    fl.exclude("node_modules")
    # files = Rake::FileList[regexp]
  end

  desc "Renames the plugin"
  task :rename do
    puts PLUGIN_FILES.ext(".rb")
  end
end
