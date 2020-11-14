# frozen_string_literal: true

# Add this here due to a testing issue
require 'fileutils'
require 'shellwords'

# Dynamically determined due to having to load from the tempdir
@current_dir = File.expand_path(__dir__)

# If its a remote file, the branch is appended to the end, so go up a level
# IE: https://blah-blah-blah/bridgetown-plugin-tailwindcss/master
ROOT_PATH = if __FILE__ =~ %r{\Ahttps?://}
              File.expand_path('../', __dir__)
            else
              File.expand_path(__dir__)
            end

DIR_NAME = 'bridgetown-automation-tailwindcss'
GITHUB_PATH = "https://github.com/ParamagicDev/#{DIR_NAME}.git"

def template_dir
  File.join(@current_dir, 'templates')
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
      @current_dir = File.expand_path(tempdir)
    end
  else
    source_paths.unshift(DIR_NAME)
  end
end

def add_yarn_packages
  packages = "postcss-import \
              postcss-loader \
              tailwindcss \
              @fullhuman/postcss-purgecss"

  say "Adding the following yarn packages: #{packages.split(/\s+/).join(" ")}", :green
  run "yarn add -D #{packages}"
end

def import_tailwind_statements
  filename = 'index.scss'
  style_file = File.join('frontend', 'styles', filename)
  template_file = File.join(template_dir, filename)

  say "Prepending to #{style_file} ...", :green
  prepend_to_file(style_file, File.read(template_file))
end

def add_config_files
  config_files = %w[webpack.config.js tailwind.config.js postcss.config.js]

  config_files.each do |filename|
    config_file = File.join(template_dir, filename)
    say "Creating #{filename}", :green

    force = (ENV['TAILWIND_INTEGRATION_TEST'] == 'true')
    create_file(filename, File.read(config_file), force: force)
  end
end

add_template_repository_to_source_path
add_yarn_packages
add_config_files
import_tailwind_statements
