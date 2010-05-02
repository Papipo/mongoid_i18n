module Mongoid
  module I18n
    class LocalizedField < Hash
      def expand_complex_criteria
        raise self.inspect
      end
    end
  end
end