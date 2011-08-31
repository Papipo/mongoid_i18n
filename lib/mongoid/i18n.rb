require 'mongoid/i18n/localized_field'
require 'mongoid/i18n/criterion/selector'
require 'mongoid/i18n/controller'
require 'mongoid/i18n/extension'
require 'mongoid/i18n/localized_validator'

# add english load path by default
I18n.load_path << File.join(File.dirname(__FILE__), "..", "..", "config", "locales", "en.yml")

module Mongoid
  module I18n
    extend ActiveSupport::Concern
    
    mattr_accessor :locale
    @@locale = ::I18n.locale
    
    def self.locale
      @@locale.to_s
    end
    
    mattr_accessor :default_locale
    @@default_locale = ::I18n.default_locale
    
    def self.default_locale
      @@default_locale.to_s
    end

    module ClassMethods
      def localized_field(name, options = {})
        field name, options.merge(:type => LocalizedField, :default => LocalizedField.new)
      end

      def validates_default_locale(names, options = {})
        validates_with LocalizedValidator, options.merge(:mode => :only_default, :attributes => names)
      end

      def validates_one_locale(names, options = {})
        validates_with LocalizedValidator, options.merge(:mode => :one_locale,   :attributes => names)
      end

      def validates_all_locales(names, options = {})
        validates_with LocalizedValidator, options.merge(:mode => :all_locales,  :attributes => names)
      end

      protected
      def create_accessors(name, meth, options = {})
        if options[:type] == LocalizedField
          if options[:use_default_if_empty]
            define_method(meth) { read_attribute(name)[Mongoid::I18n.locale] || read_attribute(name)[Mongoid::I18n.default_locale] rescue '' }
          else
            define_method(meth) { read_attribute(name)[Mongoid::I18n.locale] rescue '' }
          end
          
          define_method("#{meth}=") do |value|
            value = if value.is_a?(Hash)
              (@attributes[name] || {}).merge(value)
            else
              (@attributes[name] || {}).merge(Mongoid::I18n.locale => value)
            end
            value = value.delete_if { |key, value| value.blank? } if options[:clear_empty_values]
            write_attribute(name, value)
          end
          
          define_method("#{meth}_translations") { read_attribute(name) }
          
          if options[:clear_empty_values]
            define_method("#{meth}_translations=") { |value| write_attribute(name, value.delete_if { |key, value| value.blank? }) }
          else
            define_method("#{meth}_translations=") { |value| write_attribute(name, value) }
          end
        else
          super
        end
      end
    end
  end
end

# Include the controller helpers for localization
ActiveSupport.on_load(:action_controller) do
  include Mongoid::I18n::Controller
end
