# frozen_string_literal: true

require "bridgetown"
require "bridgetown-plugin-tailwindcss/builder"

Bridgetown::PluginManager.new_source_manifest(
  origin: TailwindCss,
)
