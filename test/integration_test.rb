# frozen_string_literal: true

require 'test_helper'
require 'bundler'
require 'active_support'

CURRENT_BRIDGETOWN_VERSION = '~> 0.15.0.beta3'

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
    tailwind = 'tailwind.config.js'
    test_tailwind_file = read_test_file(tailwind)
    template_tailwind_file = read_template_file(tailwind)

    assert_equal(test_tailwind_file, template_tailwind_file)

    webpack = 'webpack.config.js'
    test_webpack_file = read_test_file(webpack)
    template_webpack_file = read_template_file(webpack)

    assert_equal(test_webpack_file, template_webpack_file)

    styles = 'index.scss'
    styles_test_path = File.join('frontend', 'styles', styles)

    test_styles_file = read_test_file(styles_test_path)
    template_styles_file = read_template_file(styles)

    assert test_styles_file.include?(template_styles_file)
  end

  def test_it_works_with_local_automation
    Rake.cd TEST_APP

    # This has to overwrite `webpack.config.js` so it needs to force: true
    ENV['TAILWIND_INTEGRATION_TEST'] = 'true'

    Rake.sh("bridgetown new . --force --apply='../bridgetown.automation.rb'")

    run_assertions
  end

  # Have to push to github first, and wait for github to update
  def test_it_works_with_remote_automation
    Rake.cd TEST_APP
    Rake.sh('bridgetown new . --force')

    # Force file creation
    ENV['TAILWIND_INTEGRATION_TEST'] = 'true'

    github_url = 'https://raw.githubusercontent.com'
    user_and_reponame = 'ParamagicDev/bridgetown-plugin-tailwindcss/master'

    file = 'bridgetown.automation.rb'

    url = "#{github_url}/#{user_and_reponame}/#{file}"

    Rake.sh("bridgetown apply #{url}")

    run_assertions
  end
end
