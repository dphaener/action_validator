# frozen_string_literal: true

require_relative "lib/action_validator/version"

Gem::Specification.new do |spec|
  spec.name = "action_validator"
  spec.version = ActionValidator::VERSION
  spec.authors = ["Darin Haener"]
  spec.email = ["darin.haener@hey.com"]
  spec.homepage = "https://www.github.com/dphaener/action_validator"
  spec.summary = "Simple client and server side form validation."
  spec.description =
    "Validate your Rails forms remotely in real time using ActionCable. Also validate client side " \
      'using native HTML validations and present them in a much "prettier" format.'
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
    end

  spec.add_dependency "rails", ">= 7.0.4"

  spec.add_development_dependency "importmap-rails", "~> 1.1.5"
  spec.add_development_dependency "puma", "~> 5.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "sassc-rails", "~> 2.1"
  spec.add_development_dependency "stimulus-rails", "~> 1.1.1"
  spec.add_development_dependency "turbo-rails", "~> 1.3.2"
end
