module Mongoid
  module I18n
    class LocalizedField < ::Hash
      include Mongoid::Fields::Serializable

      # Return translated string
      def to_s
        lookups = [::I18n.locale.to_s]

        # TODO: Add I18n.fallbacks support instead of :use_default_if_empty
        if options[:use_default_if_empty]
          lookups.push ::I18n.default_locale.to_s
        end

        # Find first localized value in lookup path
        self[lookups.find{|locale| self[locale]}]
      end

      alias_method :eqal, :==
      # Compare localized string against string, or if target is Hash, agains translations
      def ==(target)
        target.is_a?(Hash) ? eqal(target) : (to_s == target)
      end

      # Assign new translation
      def <<(new_value)
        self[::I18n.locale.to_s] = new_value
      end

      # HACK: Due unknown reason it's impossible to use [].
      #       In some cases it fails with weird error: "Wrong number of agruments 1 to 0"
      #       I have no idea why.
      def [](value = nil)
        self.fetch(value, nil)
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