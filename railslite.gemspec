# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rake"

Gem::Specification.new do |spec|
  spec.name          = "railslite"
  spec.version       = "0.0.0"
  spec.authors       = ["Walter Tan"]
  spec.email         = ["waltertan12@gmail.com"]
  spec.description   = %q{A MVC web famework modeled after Ruby on Rails}
  spec.summary       = %q{Build shitty web applications fast-ish}
  spec.homepage      = "http://github.com/waltertan12/RailsLite"
  spec.license       = "MIT"

  # spec.files         = `git ls-files`.split($/)
  spec.files         = FileList[
                         "./action_view/lib/*",
                         "./active_record/lib/*"
                       ]
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  # spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_dependency "rake"
  spec.add_dependency "bundler"
  spec.add_dependency "webrick"
  spec.add_dependency "activesupport"
  spec.add_dependency "rspec", "~> 3.1.0"
  spec.add_dependency "sqlite3"
  spec.add_dependency "pry"
end