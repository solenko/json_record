require 'json_record/version'

require 'json_record/utils'
require 'json_record/configuration'
require 'json_record/errors'
require 'json_record/attribute'
require 'json_record/attribute_set'
require 'json_record/attributes'
require 'json_record/serializable'
require 'json_record/persistence'
require 'json_record/finders'
require 'json_record/finders/predicate'
require 'json_record/model'

module JsonRecord
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def method_missing(name, *args)
      configuration.respond_to?(name) ? configuration.send(name, *args) : super(name, *args)
    end

    def respond_to?(name, include_all=false)
      configuration.respond_to?(name, include_all) || super(name, include_all)
    end
  end
end
