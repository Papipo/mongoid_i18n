module Mongoid
  module Criterion
    class Selector< Hash
      def []=(key, value)
        key = "#{key}.#{::I18n.locale}" if fields[key.to_s].try(:type) == Mongoid::I18n::LocalizedField
        super
      end
    end
  end
end