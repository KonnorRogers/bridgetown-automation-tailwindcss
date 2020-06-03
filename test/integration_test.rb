require "test_helper"
require 'bundler'

class IntegrationTest < Minitest::Test
  def test_it_works
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
    Rake.cd(TEST_APP)

    Rake.sh("bundle install")
    Rake.sh("bundle exec bridgetown new . --force")
  end
end
