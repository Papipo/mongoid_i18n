gem 'mongoid', '2.0.0.beta4'
require 'mongoid'
require 'mongoid/i18n/localized_field'

module Mongoid
  module I18n
    extend ActiveSupport::Concern
    
    module ClassMethods
      def localized_field(name, options = {})
        field name, options.merge(:type => LocalizedField, :default => {})
      end
    
      protected
      def create_accessors(name, meth, options = {})
        if options[:type] == LocalizedField
          define_method(meth) { read_attribute(name)[::I18n.locale] }
          define_method("#{meth}=") do |value| 
            write_attribute(name, (@attributes[name] || {}).merge(::I18n.locale => value))
          end
          define_method("#{meth}_translations") { read_attribute(name) }
          define_method("#{meth}_translations=") { |value| write_attribute(name, value) }
        else
          super
        end
      end
    end
  end
end