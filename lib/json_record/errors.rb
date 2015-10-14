module JsonRecord
  class Error < StandardError; end

  # Persistence errors
  class RecordNotPersisted < Error; end

  # Attributes definition errors
  class DuplicatedAttribute < Error; end

  # Finder errors
  class RecordNotFound < Error; end

end