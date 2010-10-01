require 'mongoid/localizable/localized_field'
require 'mongoid/localizable/localized_criteria'

module Mongoid
  module Localizable
    extend ActiveSupport::Concern

    module ClassMethods
      def localized_field(name, options = {})
        field name, options.merge(:type => LocalizedField)
      end

      def criteria
        scope = scope_stack.last rescue nil
        scope || Localizable::LocalizedCriteria.new(self)
      end

      protected
      def create_accessors(name, meth, options = {})
        if options[:type] == LocalizedField
          if options[:use_default_if_empty]
            define_method(meth) do
              value = read_attribute(name)[::I18n.locale.to_s] rescue ''
              read_attribute(name)[::I18n.default_locale.to_s] if value.blank? && I18n.locale != I18n.default_locale
            end
          else
            define_method(meth) { read_attribute(name)[::I18n.locale.to_s] rescue '' }
          end
          define_method("#{meth}=") do |value|
            if value.is_a?(Hash)
              val = (@attributes[name] || {}).merge(value)
            else
              val = (@attributes[name] || {}).merge(::I18n.locale.to_s => value)
            end
            val.delete_if { |key, value| value.blank? } if options[:clear_empty_values]
            write_attribute(name, val)
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
