# frozen_string_literal: true

require "minitest"
require "rake"
require "minitest/autorun"
require "bridgetown"
require "thor"

Bridgetown.logger.log_level = :error

THOR = TailwindCss::Utils::Action.new

PLUGIN_NAME = "bridgetown-plugin-tailwindcss"

ROOT_DIR = File.expand_path("..", __dir__)
GEMSPEC_FILE = File.join(ROOT_DIR, "#{PLUGIN_NAME}.gemspec")

NPM_TARBALL = File.join(ROOT_DIR, "#{PLUGIN_NAME}-v#{TailwindCss::VERSION}.tgz")

TEST_DIR = File.expand_path(__dir__)
TEST_APP = File.expand_path("test_app")

def install_packages
  Rake.sh("rake install:local")

  # https://medium.com/@the1mills/how-to-test-your-npm-module-without-publishing-it-every-5-minutes-1c4cb4b369be
  Rake.sh("yarn pack") # Packs into a .tgz file similar to npm
end

def create_bridgetown_app
  current_dir = Dir.pwd

  install_packages

  Rake.rm_rf(TEST_APP)
  Rake.mkdir_p(TEST_APP)
  Rake.cd(TEST_APP)
  Rake.sh("gem install bundler")
  Rake.sh("bundle init --gemspec #{GEMSPEC_FILE}")
  Rake.sh("bundle install")
  Rake.sh("bundle exec bridgetown new . --force")

  THOR.append_to_file(TEST_APP) do
    <<~GEMFILE
      group :bridgetown_plugins do
        'bridgetown-plugin-tailwindcss', '#{TailwindCss::VERSION}'
      end
    GEMFILE
  end

  Rake.sh("yarn add #{NPM_TARBALL}")
  Rake.sh("bundle install")
  Rake.sh("bridgetown tailwind_init")
  Rake.cd(current_dir)
end

create_bridgetown_app
