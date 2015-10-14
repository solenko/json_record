module JsonRecord
  module Model
    def self.included(base)
      base.class_eval do
        include Attributes
        include Serializable
        include Persistence
        include Finders
      end
    end
  end
end