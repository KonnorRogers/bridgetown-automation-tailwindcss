# frozen_string_literal: true

# Add this here due to a testing issue
require 'fileutils'
require 'shellwords'

@current_dir = File.expand_path(__dir__)
ROOT_PATH = File.expand_path(__dir__)
DIR_NAME = 'bridgetown-plugin-tailwindcss'
GITHUB_PATH = "https://github.com/ParamagicDev/#{DIR_NAME}.git"

def template_dir
  File.join(@current_dir, 'templates')
end

# I didnt feel it was necessary here.
# I left this here for reference.
def require_files(tmpdir = nil)
  files = Dir.glob('lib/**/*')

  return if files.empty?

  return files.each { |file| require File.expand_path(file) } if tmpdir.nil?

  files.each { |file| require File.join(tmpdir, File.expand_path(file)) }
end

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'

    source_paths.unshift(tempdir = Dir.mktmpdir(DIR_NAME + '-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    run("git clone --quiet #{GITHUB_PATH.shellescape} #{tempdir.shellescape}")

    if (branch = __FILE__[%r{#{DIR_NAME}/(.+)/bridgetown.automation.rb}, 1])
      Dir.chdir(tempdir) { system("git checkout #{branch}") }
      require_files(tempdir)
      @current_dir = File.expand_path(tempdir)
    end
  else
    source_paths.unshift(DIR_NAME)
    require_files
  end
end

def add_yarn_packages
  packages = 'postcss-import postcss-loader tailwindcss'

  say "Adding the following yarn packages: #{packages}", :green
  system("yarn add #{packages}")
end

def add_tailwind_config
  filename = 'tailwind.config.js'

  tailwind_config = File.join(template_dir, filename)

  say "Creating #{filename} ...", :green
  create_file(filename, File.read(tailwind_config))
end

def import_tailwind_statements
  filename = 'index.scss'
  style_file = File.join('frontend', 'styles', filename)
  template_file = File.join(template_dir, filename)

  say "Prepending to #{style_file} ...", :green
  prepend_to_file(style_file, File.read(template_file))
end

def add_webpack_config
  filename = 'webpack.config.js'

  webpack_config = File.join(template_dir, filename)

  say "Creating #{filename}", :green

  force = (ENV['TAILWIND_INTEGRATION_TEST'] == 'true')
  create_file(filename, File.read(webpack_config), force: force)
end

add_template_repository_to_source_path
add_tailwind_config
add_webpack_config
import_tailwind_statements
add_yarn_packages
