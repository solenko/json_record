module JsonRecord
  class AttributeSet

    include Enumerable
    extend Forwardable

    attr_reader :definitions
    def_delegators :definitions, :each, :size

    attr_reader :model_class

    def self.setup(base)
      base.extend ClassMethods
      unless base.instance_variable_defined?(:"@_attribute_set")
        base.instance_variable_set(:"@_attribute_set", AttributeSet.new(base))
      end
    end

    def initialize(model_class)
      @model_class = model_class
      @definitions = []
    end

    def append(name)
      raise DuplicatedAttribute.new("Duplicated attribute `#{name}` for `#{model_class.name}`") if has_attribute?(name.to_sym)
      attribute = Attribute.new(name.to_sym)
      create_accessors_for(attribute)
      @definitions << attribute
    end

    def has_attribute?(name)
      definitions.any? { |attr| attr.name == name.to_sym }
    end

    def create_accessors_for(attribute)
      model_class.send(:define_method, attribute.name) do
        self.attributes[attribute.name.to_s]
      end

      model_class.send(:define_method, "#{attribute.name}=") do |value|
        self.attributes[attribute.name.to_s] = value
      end
    end



    module ClassMethods
      def attribute_set
        @_attribute_set
      end

      def attribute_names
        attribute_set.definitions.map {|attr| attr.name.to_s }
      end
    end
  end
end