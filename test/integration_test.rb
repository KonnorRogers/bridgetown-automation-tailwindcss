require "test_helper"
require "fileutils"
require 'bundler'

CURRENT_BRIDGETOWN_VERSION = '0.15.0.beta2'
# CURRENT_BRIDGETOWN_VERSION = '0.14.0'

class IntegrationTest < Minitest::Test
  def test_it_works
      Rake.rm_rf(TEST_APP)
      Rake.mkdir_p(TEST_APP)
      Rake.cd(TEST_APP)

      File.open(TEST_APP_GEMFILE, 'a') do |file|
        file << "gem 'bridgetown', '~> #{CURRENT_BRIDGETOWN_VERSION}'"
      end

    Bundler.with_unbundled_env do
      Rake.sh("bundle install")
      Rake.sh("bundle exec bridgetown new . --force")
    end
  end
end
