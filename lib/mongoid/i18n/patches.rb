module Mongoid
  class Criteria
    def self.translate(*args)
      klass = args[0]
      params = args[1] || {}
      unless params.is_a?(Hash)
        return klass.criteria.id_criteria(params)
      end
      conditions = params.delete(:conditions) || {}
      if conditions.include?(:id)
        conditions[:_id] = conditions[:id]
        conditions.delete(:id)
      end
      return klass.criteria.where(conditions).extras(params)
    end
  end
end