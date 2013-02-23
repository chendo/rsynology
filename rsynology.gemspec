# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rsynology/version'

Gem::Specification.new do |gem|
  gem.name          = "rsynology"
  gem.version       = RSynology::VERSION
  gem.authors       = ["Jack Chen (chendo)"]
  gem.email         = ["gems+rsynology@chen.do"]
  gem.description   = %q{A gem to access the API exposed by Synology DSM apps}
  gem.summary       = %q{A gem to access the API exposed by Synology DSM apps}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('faraday', '~> 0.8.5')
end
