module Mongoid
  module I18n
    class LocalizedCriteria < Mongoid::Criteria
      def where(selector = nil)
        super
        expand_localized_fields_in_selector if selector.is_a?(Hash)
        self
      end
      
      protected
      
      def expand_localized_fields_in_selector
        @klass.fields.select { |k,f| @selector.symbolize_keys!.keys.include?(k.to_sym) && f.type == LocalizedField }.each do |k,v|
          @selector["#{k}.#{::I18n.locale}"] = @selector.delete(k.to_sym)
        end
      end
    end
  end
end
