module I18n
  class << self
    def locale=(name)
      Mongoid::I18n.locale = name
      config.locale = name
    end
    
    def default_locale=(name)
      Mongoid::I18n.default_locale = name
      config.default_locale = name
    end
  end
end