# encoding: utf-8
require "#{File.dirname(__FILE__)}/lib/mongoid/i18n/version"

Gem::Specification.new do |s|
  s.name = 'mongoid_i18n'
  s.version = Mongoid::I18n::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.authors = [%q{Rodrigo Álvarez}]
  s.date = %q{2011-10-17}
  s.summary = %q{Mongoid plugin to deal with localizable fields}
  s.description = %q{This gem aims to be a transparent way to deal with localizable fields.
      Basically use localized_field() instead of field() and that's it.
      It will take care of locales for you when using find or criteria.
      }
  s.email = %q{papipo@gmail.com}
  s.extra_rdoc_files = %w(LICENSE README.rdoc)
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.homepage = %q{http://github.com/Papipo/mongoid_i18n}
  s.require_paths = %w(lib)

  s.add_runtime_dependency "mongoid", ">= 2.1.0"
  s.add_development_dependency "bson_ext", ">= 0"
  s.add_development_dependency "rspec", ">= 0"
  s.add_development_dependency "mocha", ">= 0"
  s.add_development_dependency "bundler", ">= 0"
end

