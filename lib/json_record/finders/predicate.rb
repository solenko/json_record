module JsonRecord
  module Finders
    class Predicate
      attr_reader :model_class

      include Enumerable
      extend Forwardable

      def_delegators :collection, :each, :size

      def initialize(model_class)
        @model_class = model_class
        @conditions = []
      end

      def where(conditions)
        @conditions += build_conditions(conditions)
        self
      end

      def collection
        @collection ||= model_class.all.select { |record| @conditions.all? { |c| c.call(record) } }
      end

      private

      def build_conditions(conditions)
        if conditions.is_a? Hash
          conditions.inject([]) do|memo, args|
            memo << build_field_condition(args.first, args.last)
          end
        elsif conditions.respond_to? :call
          [conditions]
        end
      end

      def build_field_condition(field, condition)
        if condition.respond_to? :call
          Proc.new { |record| condition.call(record[field]) }
        else
          Proc.new { |record| record[field] == condition }
        end

      end
    end
  end
end