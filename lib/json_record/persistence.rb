require 'securerandom'

module JsonRecord
  module Persistence

    def self.included(base)
      base.extend ClassMethods
    end


    def initialize(*args)
      super(*args)
      @persisted = false
      @_uuid = nil
    end

    def record_id
      @_uuid
    end
    alias_method :primary_key, :record_id

    def persisted?
      @persisted
    end

    def save
      @_uuid ||= generate_new_id
      write_record
    end

    def destroy
      raise RecordNotPersisted.new unless persisted?
      File.unlink(file_path)
    end

    def file_path
      self.class.file_path_for(primary_key)
    end

    private

    def write_mutex
      self.class.write_mutex
    end

    def generate_new_id
      SecureRandom.uuid
    end

    def write_record
      write_mutex.synchronize do
        write_file_content
      end
      @persisted = true
    end

    def write_file_content
      File.open(file_path, 'w+') do |f|
        f.flock(File::LOCK_EX)
        f.write to_json
      end
    end

    module ClassMethods
      def write_mutex
        @write_mutex ||= Mutex.new
      end

      def file_name_for(id)
        "#{id}#{JsonRecord.files_ext}"
      end

      def folder_name
        File.join(JsonRecord.storage_path, Utils.underscore(name || ''))
      end

      def file_path_for(id)
        File.join(folder_name, file_name_for(id))
      end
    end


  end
end