require "test_helper"
require "fileutils"

class IntegrationTest < Minitest::Test
  def test_it_works
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
    Rake.cd(TEST_APP)
    Rake.sh("gem install bundler")
    Rake.sh("bundle init")
    Rake.sh("bundle add bridgetown -v '0.15.0.beta-2'")
    Rake.sh("bundle install")
    Rake.sh("bundle exec bridgetown new . --force")
  end
end
