require "test_helper"
require 'bundler'

class IntegrationTest < Minitest::Test
  include TailwindCss::IoTestHelpers

  def read_test_file(filename)
    File.read(File.join(TEST_APP, filename))
  end

  def read_template_file(filename)
    File.read(File.join(TEMPLATES_DIR, filename))
  end

  def test_it_works
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
    Rake.cd(TEST_APP)

    Rake.sh("bundle install")

    # This has to overwrite `webpack.config.js`
    simulate_stdin("y") do
      Rake.sh("bundle exec bridgetown new . --force --apply='../bridgetown.automation.rb'")
    end

    tailwind = "tailwind.config.js"
    test_tailwind_file = read_test_file(tailwind)
    template_tailwind_file = read_template_file(tailwind)

    assert_equal(test_tailwind_file, template_tailwind_file)

    webpack = "webpack.config.js"
    test_webpack_file = read_test_file(webpack)
    template_webpack_file = read_template_file(webpack)

    assert_equal(test_webpack_file, template_webpack_file)

    styles = "index.scss"
    styles_test_path = File.join("frontend", "styles", styles)

    test_styles_file = read_test_file(styles_test_path)
    template_styles_file = read_template_file(styles)

    assert test_styles_file.include?(template_styles_file)
  end
end
