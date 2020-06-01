# frozen_string_literal: true

require "bridgetown"
require_relative "utils"

module Bridgetown
  module Commands
    class TailwindInit < Bridgetown::Command
      ACTIONS = TailwindCss::Utils::Actions.new

      class << self
        def init_with_program(prog)
          prog.command(:tailwind_init) do |c|
            c.syntax "tailwind_init"
            c.description "Initialize config for Tailwind"
            # c.option 'path', '--path', 'Choose the path to install tailwind'

            c.action do |_args, _options|
              Bridgetown::Commands::TailwindInit.run
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

          ACTIONS.create_file(webpack_config, webpack_file_contents)
          ACTIONS.create_file(tailwind_config, tailwind_config_contents)
          prepend_to_stylesheet
        end

        def webpack_contents
          <<~WEBPACK
            const path = require("path");
            const MiniCssExtractPlugin = require("mini-css-extract-plugin");
            const ManifestPlugin = require("webpack-manifest-plugin");

            module.exports = {
              entry: "./frontend/javascript/index.js",
              devtool: "source-map",
              // Set some or all of these to true if you want more verbose logging:
              stats: {
                modules: false,
                builtAt: false,
                timings: false,
                children: false,
              },
              output: {
                path: path.resolve(__dirname, "output", "_bridgetown", "static", "js"),
                filename: "all.[contenthash].js",
              },
              resolve: {
                extensions: [".js", ".jsx"],
              },
              plugins: [
                new MiniCssExtractPlugin({
                  filename: "../css/all.[contenthash].css",
                }),
                new ManifestPlugin({
                  fileName: path.resolve(__dirname, ".bridgetown-webpack", "manifest.json"),
                }),
              ],
              module: {
                rules: [
                  {
                    test: /\.(js|jsx)/,
                    use: {
                      loader: "babel-loader",
                      options: {
                        presets: ["@babel/preset-env"],
                        plugins: [
                          "@babel/plugin-proposal-class-properties",
                          [
                            "@babel/plugin-transform-runtime",
                            {
                              helpers: false,
                            },
                          ],
                        ],
                      },
                    },
                  },
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
                    ],
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
                  {
                    test: /\.woff2?$|\.ttf$|\.eot$|\.svg$/,
                    loader: "file-loader",
                    options: {
                      outputPath: "../fonts",
                      publicPath: "../fonts",
                    },
                  },
                ],
              },
            };

          WEBPACK
        end

        def prepend_to_stylesheet
          frontend_stylesheet = File.join("frontend", "styles", "index.scss")
          frontend_stylesheet = File.expand_path(frontend_stylesheet)

          return unless File.exist?(frontend_stylesheet)

          ACTIONS.prepend_to_file(frontend_stylesheet, import_tailwind_contents)
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
  end
end
