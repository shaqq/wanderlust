# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wanderlust/version'

Gem::Specification.new do |spec|
  spec.name          = "wanderlust"
  spec.version       = Wanderlust::VERSION
  spec.authors       = ["Shaker Islam"]
  spec.email         = ["shakerislam@gmail.com"]

  spec.summary       = %q{MySQL Timezone support for your ActiveRecord specs}
  spec.homepage      = "https://github.com/shaqq/wanderlust"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "true"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "activerecord-mysql2-adapter"
  spec.add_development_dependency "activerecord"
end
