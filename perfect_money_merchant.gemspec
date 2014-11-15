# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'perfect_money_merchant/version'

Gem::Specification.new do |spec|
	spec.name = 'perfect_money_merchant'
	spec.version = PerfectMoneyMerchant::VERSION
	spec.authors = ['BroderickBrockman']
	spec.email = ['broderickbrockman@gmail.com']
	spec.summary = %q{blah blah}
	spec.description = %q{blah blah blah blah}
	spec.homepage = ''
	spec.license = 'MIT'

	spec.files = `git ls-files -z`.split("\x0")
	spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ['lib']

	spec.add_development_dependency 'bundler', '~> 1.6'
	spec.add_development_dependency 'rake'
	spec.add_development_dependency 'sqlite3', '~> 1.3.10'
	spec.add_development_dependency 'rspec-rails', '~> 3.1.0'
	spec.add_development_dependency 'pry', '~> 0.10.1'
	spec.add_development_dependency 'pry-byebug', '~> 2.0.0'

	spec.add_runtime_dependency 'faraday', '~> 0.9.0'
	spec.add_runtime_dependency 'faraday_middleware', '~> 0.9.1'
	spec.add_runtime_dependency 'nokogiri', '~> 1.6.4.1'
	spec.add_runtime_dependency 'hashie', '~> 3.3.1'
	spec.add_runtime_dependency 'rails', '~> 4.1.7'
end
