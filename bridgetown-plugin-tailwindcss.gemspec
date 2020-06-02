# frozen_string_literal: true

require_relative "lib/bridgetown-plugin-tailwindcss/version"

Gem::Specification.new do |spec|
  spec.name          = "bridgetown-plugin-tailwindcss"
  spec.version       = TailwindCss::VERSION
  spec.author        = "Konnor Rogers"
  spec.email         = "konnor7414@gmail.com"
  spec.summary       = "A plugin to add tailwindcss to a site"
  spec.homepage      = "https://github.com/paramagicdev/bridgetown-plugin-tailwindcss"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|script|spec|features|frontend)/!) }
  spec.test_files    = spec.files.grep(%r!^spec/!)
  spec.require_paths = ["lib"]
  spec.metadata      = { "yarn-add" => "bridgetown-plugin-tailwindcss@#{TailwindCss::VERSION}" }

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "bridgetown", ">= 0.15", "< 2.0"
  spec.add_dependency "thor", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubocop-bridgetown", "~> 0.2"
end
