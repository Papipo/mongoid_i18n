module Mongoid
  module I18n
    class Controller
      def self.included(base)
        base.before_filter :set_mongoid_i18n_locale
      end
      
      protected
      
      # End user must override in their own controllers
      def mongoid_i18n_locale; end
      
      # Called before requests so subsequent database lookups use the correct locale
      def set_mongoid_i18n_locale
        return if mongoid_i18n_locale.nil?
        
        ::Mongoid::I18n.locale = mongoid_i18n_locale
      end
    end
  end
end
