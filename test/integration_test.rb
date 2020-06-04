require "test_helper"
require 'bundler'

class IntegrationTest < Minitest::Test
  include TailwindCss::IoTestHelpers

  def run_setup
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
    Rake.cd(TEST_APP)
    Rake.sh("bundle install")
  end

  def read_test_file(filename)
    File.read(File.join(TEST_APP, filename))
  end

  def read_template_file(filename)
    File.read(File.join(TEMPLATES_DIR, filename))
  end

  def current_commit_hash
    %x(git rev-parse HEAD)
  end

  def run_assertions
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

  def test_it_works_with_local_automation
    run_setup

    # This has to overwrite `webpack.config.js` so it needs input
    simulate_stdin("y") do
      Rake.sh("bundle exec bridgetown new . --force --apply='../bridgetown.automation.rb'")
    end

    run_assertions
  end

  def test_it_works_with_remote_automation
    Rake.sh("bundle exec bridgetown new . --force")

    github_url = "raw.githubusercontent.com"
    user_and_reponame = "ParamagicDev/bridgetown-plugin-tailwindcss"

    file = "bridgetown.automation.rb"

    url = "#{github_url}/#{user_and_reponame}/#{current_commit_hash}/#{file}"

    simulate_stdin("y") do
      Rake.sh("bundle exec bridgetown apply #{url}")
    end

    run_assertions
  end
end
