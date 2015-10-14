module JsonRecord
  module Attributes

    def self.included(base)
      AttributeSet.setup(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      extend Forwardable

      def attributes
        @_attributes
      end

      def_delegators :attributes, :[], :[]=

      def initialize(*args)
        attrs = args.size > 0 && args.first.is_a?(Hash) ? args.first : {}
        init_with_attributes(nil, attrs)
      end

      def init_with_attributes(id, attrs)
        @_uuid = id
        @persisted = !id.nil?
        @_attributes = {}.tap do |memo|
          self.class.attribute_names.each do |name|
            memo[name] = attrs.fetch(name, attrs.fetch(name.to_sym, nil))
          end
        end
        self
      end

    end



    module ClassMethods
      def attribute(name)
        attribute_set.append(name)
      end
    end
  end
end