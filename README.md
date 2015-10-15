# JsonRecord

One more code sample.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_record', github: 'solenko/json_record'
```

And then execute:

    $ bundle

## Configuration

```ruby

JsonRecord.configure do |config|
  # path to directory where your data will be stored. Default './db'
  config.storage_path = '/some/absolute/path'
  # Write keys with null values into json files or not. Default `true`
  config.write_empty_keys = true
  # File extension for data files. Default '.json'
  config.files_ext = '.my_json_db'
end
```

## Usage


#### Define model and attributes

```ruby
class Person
  include JsonRecord

  attribute :first_name
  attribute :last_name
  attribute :phone
end

#### Works with objects

person  = Person.new(first_name: 'John', last_name: 'Doe')
person.first_name
# => 'John'
person.last_name
# => 'Dou'
person.attributes
# => {"first_name" => "John", "last_name" => "Doe", "phone" => nil}
person['phone'] = 'unknown'
person.phone
# => "unknown"


#### Persisting objects

JsonRecord use UUID's for record_id/primary key by default, but you can override `primary_key` method to change this.

person  = Person.new(first_name: 'John', last_name: 'Doe')
person.primary_key
# => nil
person.persisted?
# => false

person.save

person.primary_key
# => '62936e70-1815-439b-bf89-8492855a7e6b'
person.persisted?
# => true

person_copy = Person.find('62936e70-1815-439b-bf89-8492855a7e6b')
person_copy.attributes
# => {"first_name" => "John", "last_name" => "Doe", "phone" => nil}
```

#### Filtering

```ruby
# by field values
Person.where(first_name: 'John', last_name: 'Doe')

# by field using callable object
Person.where(first_name: ->(name) { name.starts_with? 'J' })

# using callable object for record
Person.where(->(record) { record.name.starts_with? 'J' })

# #where calls are chainable
Person.where(first_name: 'John').where(last_name: 'Doe')
```