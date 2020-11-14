# frozen_string_literal: true

require "test_helper"
require "bundler"
require "shellwords"

CURRENT_BRIDGETOWN_VERSION = "~> 0.15.0"
BRANCH = `git branch --show-current`.chomp.freeze

class IntegrationTest < Minitest::Test
  def setup
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
  end

  def read_test_file(filename)
    File.read(File.join(TEST_APP, filename))
  end

  def read_template_file(filename)
    File.read(File.join(TEMPLATES_DIR, filename))
  end

  def run_assertions
    config_files = %w[tailwind.config.js webpack.config.js postcss.config.js]

    config_files.each do |config_file|
      test_config_file = read_test_file(config_file)
      template_config_file = read_template_file(config_file)

      assert_equal(test_config_file, template_config_file)
    end

    styles = "index.scss"
    styles_test_path = File.join("frontend", "styles", styles)

    test_styles_file = read_test_file(styles_test_path)
    template_styles_file = read_template_file(styles)

    assert test_styles_file.include?(template_styles_file)
  end

  def test_it_works_with_local_automation
    Rake.cd TEST_APP

    # This has to overwrite `webpack.config.js` so it needs to force: true
    ENV["TAILWIND_INTEGRATION_TEST"] = "true"

    Rake.sh("bridgetown new . --force --apply='../bridgetown.automation.rb'")

    run_assertions
  end

  # Have to push to github first, and wait for github to update
  def test_it_works_with_remote_automation
    Rake.cd TEST_APP
    Rake.sh("bridgetown new . --force")

    # Force file creation
    ENV["TAILWIND_INTEGRATION_TEST"] = "true"

    github_url = "https://raw.githubusercontent.com"
    user_and_reponame = "ParamagicDev/bridgetown-automation-tailwindcss/#{BRANCH}"

    file = "bridgetown.automation.rb"

    url = "#{github_url}/#{user_and_reponame}/#{file}"

    Rake.sh("bridgetown apply #{url.shellescape}")

    run_assertions
  end
end
