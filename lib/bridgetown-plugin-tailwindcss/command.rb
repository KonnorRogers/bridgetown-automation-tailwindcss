require 'bridgetown'
require 'utils'

class Command < Bridgetown::Command
  include Utils

  class << self
    def init_with_program(prog)
      prog.command(:init) do |c|
        c.syntax "init"
        c.description 'Initialize config for Tailwind'
        # c.option 'path', '--path', 'Choose the path to install tailwind'

        c.action do |args, options|
          generate_tailwind
        end
      end
    end

    private

    def generate_tailwind
      install_tailwind
      write_files
    end

    def install_tailwind
      yarn_add = "yarn add -D"
      packages = "tailwindcss postcss-import postcss-loader"
      Bridgetown::Utils::Exec.run(yarn_add, packages)
    end

    def write_files
      webpack_config = File.expand_path("webpack.config.js")
      tailwind_config = File.expand_path("tailwind.config.js")

      File.open(webpack_config) do |f|
        f.write(webpack_file_contents)
      end

      File.open(tailwind_config) do |f|
        f.write(tailwind_config_contents)
      end

      prepend_to_stylesheet
    end

    def prepend_to_stylesheet
      frontend_stylesheet = File.join("frontend", "styles", "index.scss")
      frontend_stylesheet = File.expand_path(frontend_stylesheet)

      return unless File.exist?(frontend_stylesheet)

      prepend_to_file(frontend_stylesheet, import_tailwind_contents)
    end

    def import_tailwind_contents
      <<~IMPORT
        @import 'tailwindcss/base';
        @import 'tailwindcss/components';
        @import 'tailwindcss/utilities';
      IMPORT
    end

    def tailwind_config_contents
      <<~TAILWIND
        module.exports = {
          purge: {
            enabled: true,
            content: ['./src/**/*.html'],
          },
          theme: {
            extend: {},
          },
          variants: {},
          plugins: [],
        }
      TAILWIND
    end

    def webpack_file_contents
      <<~WEBPACK
        {
          test: /\.(s[ac]|c)ss$/,
          use: [
            MiniCssExtractPlugin.loader,
            "css-loader",
            {
              loader: "sass-loader",
              options: {
                sassOptions: {
                  includePaths: [
                    path.resolve(__dirname, "src/_components"),
                    path.resolve(__dirname, "src/_includes"),
                  ],
                },
              },
            },
            {
              loader: "postcss-loader",
              options: {
                ident: "postcss",
                plugins: [
                  require("postcss-import"),
                  require("tailwindcss"),
                  require("autoprefixer"),
                ],
              },
            },
          ],
        },
      WEBPACK
    end
  end
end
