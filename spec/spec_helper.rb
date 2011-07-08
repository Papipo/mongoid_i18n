$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'mongoid'
require 'mongoid/i18n'
require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|
  config.mock_with :mocha
  config.after :each do
    Mongoid.master.collections.reject { |c| c.name =~ /^system\./ }.each(&:drop)
  end
end

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('mongoid_i18n_test')
  config.allow_dynamic_fields = false
end