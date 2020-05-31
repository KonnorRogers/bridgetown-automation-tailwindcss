# frozen_string_literal: true

module TailwindCss
  class Builder < Bridgetown::Builder
    def build
      liquid_tag "bridgetown_plugin_tailwindcss" do
        "This plugin works!"
      end
    end
  end
end

TailwindCss::Builder.register
