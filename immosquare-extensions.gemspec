require_relative "lib/immosquare-extensions/version"


Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MIT"
  spec.name          = "immosquare-extensions"
  spec.version       = ImmosquareExtensions::VERSION.dup

  spec.authors       = ["immosquare"]
  spec.email         = ["jules@immosquare.com"]
  spec.homepage      = "https://github.com/immosquare/immosquare-extensions"

  spec.summary       = "Utility extensions for Ruby core classes"
  spec.description   = "The immosquare-extensions gem provides a set of utility extensions for various Ruby core classes such as String, Hash, and Array. These extensions aim to enhance the standard functionality, offering more convenience and efficiency for Ruby developers."


  spec.files         = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.6")
end
