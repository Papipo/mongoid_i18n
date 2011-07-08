# encoding: utf-8
require 'rubygems'
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mongoid_i18n"
    gem.summary = %Q{Mongoid plugin to deal with localizable fields}
    gem.description = %Q{This gem aims to be a transparent way to deal with localizable fields.
      Basically use localized_field() instead of field() and that's it.
      It will take care of locales for you when using find or criteria.
      }
    gem.email = "papipo@gmail.com"
    gem.homepage = "http://github.com/Papipo/mongoid_i18n"
    gem.authors = ["Rodrigo Álvarez"]
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mongoid_i18n #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
