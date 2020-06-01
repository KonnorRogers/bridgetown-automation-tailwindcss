require 'rake'

class IntegrationTest < Minitest::Test
  def setup
    Rake.sh("$CWD")
  end

  def teardown
  end
end
