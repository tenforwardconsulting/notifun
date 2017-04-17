# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'notifun/version'

Gem::Specification.new do |spec|
  spec.name          = "notifun"
  spec.version       = Notifun::VERSION
  spec.authors       = ["Brett Samson"]
  spec.email         = ["brett@tenforwardconsulting.com"]
  spec.summary       = %q{Notification management.}
  spec.description   = "Notification management."
  spec.homepage      = "https://github.com/tenforwardconsulting/notifun/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 3.0'
end
