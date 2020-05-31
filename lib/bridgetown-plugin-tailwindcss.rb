# frozen_string_literal: true

require "bridgetown"
require "bridgetown-plugin-tailwindcss/command.rb"
require "bridgetown-plugin-tailwindcss/utils.rb"

Bridgetown::PluginManager.new_source_manifest(
  origin: TailwindCss
)
