# encoding: utf-8
require 'bundler'
require 'rspec'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'rdoc/task'
require "#{File.dirname(__FILE__)}/lib/mongoid/i18n/version"
Rake::RDocTask.new do |rdoc|
  version = Mongoid::I18n::Version::STRING

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mongoid_i18n #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
