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
      
      def where(selector = nil)
        if selector && selector.is_a?(Hash)
          super(expand_localized_fields_in_selector(selector))
        else
          super
        end
      end
    
      protected
      def expand_localized_fields_in_selector(selector)
        fields.select { |k,f| selector.keys.include?(k.to_sym) && f.type == LocalizedField }.each_key do |k|
          selector["#{k}.#{::I18n.locale}"] = selector.delete(k.to_sym)
        end
        selector
      end
      
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