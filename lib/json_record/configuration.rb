module JsonRecord
  class Configuration
    attr_accessor :storage_path
    attr_accessor :write_empty_keys
    attr_accessor :files_ext

    def initialize
      @store_path = default_store_path
      @write_empty_keys = true
      @files_ext = '.json'
    end

    private

    def default_store_path
      File.expand_path(File.join(Dir.pwd, 'db'))
    end
  end
end