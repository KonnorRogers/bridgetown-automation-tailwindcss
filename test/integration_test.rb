require "test_helper"
require 'bundler'

class IntegrationTest < Minitest::Test
  include IoTestHelpers

  def test_it_works
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
    Rake.cd(TEST_APP)

    Rake.sh("bundle install")

    simulate_stdin("y") do
      Rake.sh("bundle exec bridgetown new . --force --apply='../bridgetown.automation.rb'")
    end

    assert_equal
  end
end
