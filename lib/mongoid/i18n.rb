require 'mongoid/i18n/localized_field'
require 'mongoid/i18n/criterion/selector'
require 'mongoid/i18n/localized_validator'

# add english load path by default
I18n.load_path << File.join(File.dirname(__FILE__), "..", "..", "config", "locales", "en.yml")

module Mongoid
  module I18n
    extend ActiveSupport::Concern

    module ClassMethods
      def localized_field(name, options = {})
        field name, options.merge(:type => LocalizedField, :default => LocalizedField.new(name, options))
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
        # Let Mongoid do all stuff, then redefine methods
        super

        generated_field_methods.module_eval do

          # Reader method
          define_method(meth) do
            read_attribute(name).to_s
          end

          # Redefine writer method, since it's impossible to correctly implement
          # = method on field itself
          define_method("#{meth}=") do |value|
            read_attribute(name) << value
          end

          # Return list of attribute translations
          define_method("#{meth}_translations") do
            read_attribute(name).to_hash
          end

          # Mass-assign translations
          define_method("#{meth}_translations=") do |values|
            read_attribute(name).replace(values)
          end
        end
      end
    end
  end
end