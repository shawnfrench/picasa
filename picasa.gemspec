# -*- encoding: utf-8 -*-
require File.expand_path('../lib/picasa/version', __FILE__)

Gem::Specification.new do |gem|
  gem.author = "Wojciech Wnętrzak"
  gem.email = "w.wnetrzak@gmail.com"
  gem.description = %q{Ruby client for Google Picasa API}
  gem.summary = %q{Simple Google Picasa managment}
  gem.homepage = "https://github.com/morgoth/picasa"
  gem.license = "MIT"

  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name = "picasa"
  gem.require_paths = ["lib"]
  gem.version = Picasa::VERSION

  gem.add_dependency "httparty"

  gem.add_development_dependency "minitest", ">= 5.0.0"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "mocha", ">= 0.13.0"
  gem.add_development_dependency "vcr", ">= 2.4.0"

  gem.post_install_message = "Version 0.7.0 of picasa gem will require Ruby 1.9.3 or greater. If you still need 1.8.7 freeze gem version to ~> 0.6.7"
end
