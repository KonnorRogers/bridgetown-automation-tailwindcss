# frozen_string_literal: true

require "minitest"
require "rake"
require "minitest/autorun"
require "bridgetown"

Bridgetown.logger.log_level = :error

ROOT_DIR = File.expand_path("..", __dir__)
GEMSPEC_FILE = File.join(ROOT_DIR, "bridgetown-plugin-tailwindcss.gemspec")

TEST_DIR = File.expand_path(__dir__)
TEST_APP = File.expand_path("test_app")

def install_packages
  Rake.sh("rake install:local")
  Rake.sh("npm pack") # Packs into a .tgz file similar to npm
end

def create_bridgetown_app
  current_dir = Dir.pwd

  Rake.rm_rf(TEST_APP)
  Rake.mkdir_p(TEST_APP)
  Rake.cd(TEST_APP)
  Rake.sh("")
  Rake.sh("gem install bundler")
  Rake.sh("bundle init --gemspec #{GEMSPEC_FILE}")
  Rake.sh("bundle add bridgetown-plugin-tailwindcss -g bridgetown_plugins")
  Rake.sh("bundle install")
  Rake.sh("bundle exec bridgetown new . --force")
  Rake.sh("bridgetown tailwind_init")
  Rake.cd(current_dir)
end

create_bridgetown_app
