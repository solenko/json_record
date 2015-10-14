require 'spec_helper'

describe JsonRecord::Persistence do
  let(:test_class) {
    Class.new() do
      include JsonRecord::Model
      attribute :name
      attribute :value
    end
  }
  let(:attributes) { {name: 'some name', value: 'some value'} }

  subject { test_class.new(attributes) }

  describe '#save' do
    it 'save attributes to file' do
      subject.save
      persisted_data = JSON.parse(File.read(subject.file_path))
      attributes.each_pair do |name, value|
        expect(persisted_data[name.to_s]).to eq(value)
      end
    end

  end

  describe '.folder_name' do
    let(:config_folder) { '/some_folder_name' }
    before do
      allow(JsonRecord).to receive(:storage_path).and_return(config_folder)
      allow(test_class).to receive(:name).and_return('ModuleName::ClassName')
    end

    it 'use folder from config' do
      expect(test_class.folder_name).to include(config_folder)
    end

    it 'add model class to storage folder' do
      expect(test_class.folder_name).to eq("#{config_folder}/module_name/class_name")
    end

  end

  describe '#file_path' do
    let(:storage_folder) { '/some_folder_name' }
    before do
      allow(test_class).to receive(:folder_name).and_return(storage_folder)
      allow(subject).to receive(:primary_key).and_return('some-key')
    end

    it { expect(subject.file_path).to eq("/some_folder_name/some-key.json") }

  end

end