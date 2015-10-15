module JsonRecord
  module Finders
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find(ids)
        Array(ids).map do |id|
          find_by_id(id)
        end
      end

      def find_by_id(id)
        path = file_path_for(id)
        raise RecordNotFound.new unless File.exists?(path)
        instantiate_from_file(path)
      end

      def instantiate_from_file(file)
        allocate.init_with_attributes(id_from_filename(file), JSON.parse(File.read(file)))
      end

      def all
        enum_for(:all) unless block_given?
        Dir.glob["#{folder_name}/*#{JsonRecord.files_ext}"].map { |f| instantiate_from_file(f) }
      end

      def where(conditions)
        Predicate.new(self).where(conditions)
      end

      private

      def id_from_filename(filename)
        File.basename(filename, JsonRecord.files_ext)
      end
    end
  end
end