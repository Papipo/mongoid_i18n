module Mongoid
  module I18n
    class LocalizedField < ::Hash
      include Mongoid::Fields::Serializable

      # Deserialize type
      def deserialize(object)
        self.replace(object).to_s
      end

      # Return translated string
      def to_s
        lookups = [::I18n.locale.to_s]

        # TODO: Add I18n.fallbacks support instead of :use_default_if_empty
        if options[:use_default_if_empty]
          lookups.push ::I18n.default_locale.to_s
        end

        # HACK: Due unknown reason it's impossible to use [].
        #       In some cases it fails with weird error: "Wrong number of agruments 1 to 0"
        #       I have no idea why.

        # Find first localized value in lookup path
        self.fetch(lookups.find{|locale| self.fetch(locale, nil)}, nil)
      end

      # Assign new translation
      def <<(new_value)
        self[::I18n.locale.to_s] = new_value
      end

      # Return translations as keys, with
      def to_hash
        if options[:clear_empty_values]
          ::Hash[self].reject{|k,v| v.blank?}
        else
          ::Hash[self]
        end
      end
    end
  end
end