# frozen_string_literal: true

require "minitest"
require "minitest/autorun"
require "rake"

ROOT_DIR = File.expand_path("..", __dir__)

TEST_DIR = File.expand_path(__dir__)
TEST_APP = File.expand_path("test_app")
TEST_APP_GEMFILE = File.join(TEST_APP, "Gemfile")
