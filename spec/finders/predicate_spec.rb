require 'spec_helper'
require 'ostruct'

describe JsonRecord::Finders::Predicate do
  let(:collection) {
    [
        {name: 'name1', value: 'value1'},
        {name: 'name2', value: 'value2'},
        {name: 'name1', value: 'value2'},

    ].map { |row| OpenStruct.new(row) }
  }
  let(:model) { double('model', all: collection)}

  subject { JsonRecord::Finders::Predicate }

  it 'filter records by hash with value' do
    conditions = {name: 'name1'}
    filtered_collection = subject.new(model).where(conditions).collection
    expect(filtered_collection.size).to eq(2)
    expect(filtered_collection.all? { |r| r.name  == 'name1' } ).to be_truthy
  end

  it 'filter records by hash with multiple keys' do
    condition = {name: 'name1', value: 'value1'}
    filtered_collection = subject.new(model).where(condition).collection
    expect(filtered_collection.size).to eq(1)
    expect(filtered_collection.first.value).to eq(condition[:value])
    expect(filtered_collection.first.name).to eq(condition[:name])
  end

  it 'filter by hash with callable object' do
    conditions = {name: ->(name) { name == 'name2'} }
    filtered_collection = subject.new(model).where(conditions).collection
    expect(filtered_collection.size).to eq(1)
    expect(filtered_collection.first.name).to eq('name2')
  end

  it 'filter by callable object' do
    condition = ->(record) { record.name == 'name1' && record.value == 'value2' }
    filtered_collection = subject.new(model).where(condition).collection
    expect(filtered_collection.size).to eq(1)
    expect(filtered_collection.first.value).to eq('value2')
    expect(filtered_collection.first.name).to eq('name1')
  end
  
  it 'chain where calls' do
    filtered_collection = subject.new(model).where({name: 'name1'}).where(value: 'value2').collection
    expect(filtered_collection.size).to eq(1)
    expect(filtered_collection.first.value).to eq('value2')
    expect(filtered_collection.first.name).to eq('name1')
  end

end