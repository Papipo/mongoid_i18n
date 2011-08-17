module Mongoid
  module I18n
    class LocalizedField < Hash
      include Mongoid::Fields::Serializable

      # Return translated string
      def to_s
        # TODO: Add I18n.fallbacks support
        locale = ::I18n.locale.to_s
        self[locale]
      end

      # Compare using string as value
      def ==(value)
        to_s == value
      end

      # Assign new translation
      def <<(value)
        self[::I18n.locale.to_s] = value
      end

      # Return hash of all avliable translations
      def translations
        self.to_hash
      end
    end
  end
end