require 'json'

module JsonRecord
  module Serializable

    def to_hash(options = {})
      include_blank = options.fetch(:include_blank, JsonRecord.write_empty_keys)
      self.class.attribute_names.inject({}) do |hash, attr_name|
        value = self[attr_name]
        hash[attr_name] = value if include_blank || !value.nil?
        hash
      end
    end
    alias_method :as_json, :to_hash

    def to_json
      JSON.dump(as_json)
    end
  end
end