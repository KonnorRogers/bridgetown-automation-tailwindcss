# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new(:test) do |task|
  task.libs << 'test'
  task.libs << 'lib'
  task.test_files = FileList['test/*_test.rb', 'test/test_*.rb']
end

task default: :test
task spec: :test
