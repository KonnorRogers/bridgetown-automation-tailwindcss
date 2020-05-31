require 'bridgetown'

class Command < Bridgetown::Command
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
      write_files
      install_tailwind
    end

    def install_tailwind
      yarn_add = "yarn add -D"
      packages = "tailwindcss postcss-import postcss-loader"
      Bridgetown::Utils::Exec.run(yarn_add, packages)
    end

    def write_files
      File.open(File.expand_path("webpack.config.js"), "w") do |f|
        f.write(webpack_file_contents)
      end
    end

    def tailwind_file_contents
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
