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
        field name, options.merge(:type => LocalizedField, :default => LocalizedField.new)
        validates_with LocalizedValidator, options.merge(:mode => :check_availability, :attributes => name) if ::I18n.available_locales
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
            define_method(meth) {
              att = read_attribute(name)[::I18n.locale.to_s] || read_attribute(name)[::I18n.default_locale.to_s]

              if ! read_attribute(name).is_a?(Hash)
                att = (options[:downwards_compatible] ? read_attribute(name) : '')
              end

              att rescue ''
            }
          else
            define_method(meth) { read_attribute(name)[::I18n.locale.to_s] rescue '' }
          end
          define_method("#{meth}=") do |value|
            value = if value.is_a?(Hash)
              (@attributes[name] || {}).merge(value)
            else
              val = if options[:downwards_compatible]
                (@attributes[name].is_a?(Hash) ? @attributes[name] : {::I18n.locale.to_s => @attributes[name]})
              else
                @attributes[name]
              end
              (val || {}).merge(::I18n.locale.to_s => value)
            end

            # set field[default_locale] to existing (string)-value
            if options[:downwards_compatible] && ! value[::I18n.default_locale.to_s].present? && @attributes[name].is_a?(String)
              value[::I18n.default_locale.to_s] = @attributes[name]
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