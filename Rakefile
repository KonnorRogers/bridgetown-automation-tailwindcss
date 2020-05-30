# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# https://avdi.codes/rake-part-2-file-lists/
namespace :plugin do
  desc "Renames the plugin"
  task :rename do

    files = Rake::FileList["**/*"]
    files.exclude("node_modules/*")
    puts files
  end
end
