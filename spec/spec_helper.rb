$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'json_record'

RSpec.configure do |config|
  storage_path = File.expand_path('../tmp/db', __FILE__)
  cleanup_storage = !File.exists?(storage_path)
  config.before(:all) do
    FileUtils.mkdir_p(storage_path)
    JsonRecord.storage_path = storage_path
  end

  config.after(:all) do
    # FileUtils.rm_r(storage_path) if cleanup_storage
  end
end


