require 'spec_helper'

describe JsonRecord::Finders do
  let(:test_class) {
    Class.new() do
      include JsonRecord::Model
      attribute :name
      attribute :value
    end
  }
  let(:attributes) { {name: "some name #{rand(100)}", value: rand(100) } }


  describe ".find_by_id" do
    let(:id) { 'test-id' }
    before do
      create_file_for(test_class, id, attributes)
    end

    subject {
      test_class.find_by_id(id)
    }

    it { is_expected.to be_instance_of(test_class) }
    it { is_expected.to be_persisted }
    it 'do not call #initialize' do
      expect_any_instance_of(test_class).to_not receive(:initialize)
      subject
    end

    %w(name value).each do |attr|
      it "populate #{attr} attribute" do
        expect(subject[attr]).to eq(attributes[attr.to_sym])
      end
    end
  end

  describe '.find' do
    it 'call .find_by_id for each passed id' do
      expect(test_class).to receive(:find_by_id).with(1).ordered
      expect(test_class).to receive(:find_by_id).with(2).ordered
      test_class.find [1,2]
    end
  end

  describe '.where' do
    let(:predicate) {  double("predicate").as_null_object }
    let(:conditions) { {name: 'some name'} }

    it 'returns Predicate instance' do
      expect(test_class.where(conditions)).to be_instance_of(JsonRecord::Finders::Predicate)
    end

    it 'instantiate predicate with link to self' do
      expect(JsonRecord::Finders::Predicate).to receive(:new).with(test_class) { predicate }
      test_class.where(conditions)
    end

    it 'call Predicate#where with same conditions' do
      allow(JsonRecord::Finders::Predicate).to receive(:new).with(test_class) { predicate }
      expect(predicate).to receive(:where).with(conditions)
      test_class.where(conditions)
    end
  end

  def create_file_for(klass, id, data = {})
    File.open(klass.file_path_for(id), 'w+') do |f|
      f.write JSON.dump(data)
    end
  end

end