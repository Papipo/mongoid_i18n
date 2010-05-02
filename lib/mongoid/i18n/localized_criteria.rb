module Mongoid
  module I18n
    class LocalizedCriteria < Mongoid::Criteria
      def where(selector = nil)
        case selector
        when String
          @selector.update("$where" => selector)
        else
          @selector.update(selector ? selector.expand_complex_criteria : {})
          expand_localized_fields_in_selector if @selector.is_a?(Hash)
        end
        self
      end
      
      protected
      
      def expand_localized_fields_in_selector
        @klass.fields.select { |k,f| @selector.keys.include?(k.to_sym) && f.type == LocalizedField }.each_key do |k|
          @selector["#{k}.#{::I18n.locale}"] = @selector.delete(k.to_sym)
        end
      end
    end
  end
end