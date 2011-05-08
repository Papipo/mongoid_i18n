module Mongoid
  module I18n
    class LocalizedValidator < ActiveModel::EachValidator
      def validate_each record, attribute, value
        if options[:mode] == :only_default
          if record.send("#{attribute}_translations")[::I18n.default_locale.to_s].blank?
            record.errors.add(attribute, :locale_blank, options.except(:mode).merge(
              :cur_locale => ::I18n.t(:"locales.#{::I18n.default_locale}", :default => ::I18n.default_locale.to_s)
            ))
          end
        elsif options[:mode] == :one_locale
          record.errors.add(attribute, :all_locales_blank, options.except(:mode)) if record.send("#{attribute}_translations").empty?
        elsif options[:mode] == :all_locales
          #difference between available locales and stored locales
          diffloc = ::I18n.available_locales - record.send("#{attribute}_translations").keys.collect { |key| key.to_sym }

          #print an error for each missing locale
          diffloc.each do |locale| 
            record.errors.add(attribute, :locale_blank, options.except(:mode).merge(
              :cur_locale => ::I18n.t(:"locales.#{locale}", :default => locale.to_s)
            )) 
          end
        end
      end	
    end	
  end
end