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
        field name, options.merge(:type => LocalizedField, :default => {})
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
        # Let Mongoid do all stuff
        super

        # Skip if create_accessors called on non LocalizedField field
        return if LocalizedField != options[:type]

        # Get field to retain incapsulation of LocalizedField class
        field = fields[name]

        generated_field_methods.module_eval do

          # Redefine writer method, since it's impossible to correctly implement
          # = method on field itself
          define_method("#{meth}=") do |value|
            hash = field.assign(read_attribute(name), value)
            write_attribute(name, hash)
          end

          # Return list of attribute translations
          define_method("#{meth}_translations") do
            field.to_hash(read_attribute(name))
          end

          # Mass-assign translations
          define_method("#{meth}_translations=") do |values|
            hash = field.replace(read_attribute(name), values)
            write_attribute(name, hash)
          end
        end

      end
    end
  end
end