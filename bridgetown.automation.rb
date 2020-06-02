require 'rake'



DIR_NAME = File.basename(File.expand_path(__dir__))
GITHUB_PATH = "https://github.com/ParamagicDev/#{DIR_NAME}.git"

def require_files(tmpdir = nil)
  files = Rake::FileList("lib/**/*")

  if tmpdir.nil?
    return files.each { |file| require File.expand_path(file) }
  end

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

    source_paths.unshift(tempdir = Dir.mktmpdir(DIR_NAME + "-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      GITHUB_PATH,
      tempdir
    ].map(&:shellescape).join(' ')

    if (branch = __FILE__[%r{#{DIR_NAME}/(.+)/bridgetown.automation.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
      require_files(tempdir)
      @current_dir = File.expand_path(tempdir)
    end
  else
    source_paths.unshift(DIR_NAME)
    require_files
  end
end

add_template_repository_to_source_path

packages = "postcss-import postcss-loader tailwindcss"
say("Hello there")
