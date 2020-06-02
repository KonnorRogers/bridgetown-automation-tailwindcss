# frozen_string_literal: true

require "bridgetown"
require_relative "utils"

module Bridgetown
  module Commands
    class TailwindInit < Bridgetown::Command
      ACTION = TailwindCss::Utils::Action.new

      class << self
        def init_with_program(prog)
          prog.command(:tailwind_init) do |c|
            c.syntax "tailwind_init"
            c.description "Initialize config for Tailwind"
            # c.option 'path', '--path', 'Choose the path to install tailwind'

            c.action do |_args, _options|
              run
            end
          end
        end

        private

        def run
          write_files
        end

        def write_files
          webpack_config = File.expand_path("webpack.config.js")
          tailwind_config = File.expand_path("tailwind.config.js")

          ACTION.create_file(webpack_config, webpack_file_contents)
          ACTION.create_file(tailwind_config, tailwind_config_contents)
          prepend_to_stylesheet
        end

        def prepend_to_stylesheet
          frontend_stylesheet = File.join("frontend", "styles", "index.scss")
          frontend_stylesheet = File.expand_path(frontend_stylesheet)

          return unless File.exist?(frontend_stylesheet)

          ACTION.prepend_to_file(frontend_stylesheet, import_tailwind_contents)
        end

        def import_tailwind_contents
          <<~IMPORT

          IMPORT
        end

      end
    end
  end
end
