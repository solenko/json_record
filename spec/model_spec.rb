require 'spec_helper'

describe JsonRecord::Model do
  let(:test_class) {
    Class.new() do
      include JsonRecord::Model
    end
  }

  subject { test_class }

  it { is_expected.to respond_to(:attribute) }
  it { is_expected.to respond_to(:attribute_set) }

  describe '.attribute' do
    it 'add new attribute to attribute set' do
      expect { subject.attribute :first_name }.to change{subject.attribute_set.size}.by(1)
    end
  end

  describe '.attribute_set' do
    it { expect(subject.attribute_set).to be_instance_of(JsonRecord::AttributeSet) }
  end

  context 'with attributes' do
    let(:attribute_name)  { 'attr1' }
    let(:attribute_value)  { rand(100) }

    subject { test_class.new }

    before do
      test_class.attribute attribute_name
    end

    it 'define attribute reader' do
      expect(subject).to respond_to(attribute_name)
    end

    it 'define attribute writer' do
      expect(subject).to respond_to("#{attribute_name}=")
    end

    it 'add attribute to list of attributes' do
      expect(subject.class.attribute_names).to include(attribute_name)
    end

    it 'store attribute value' do
      subject.send("#{attribute_name}=", attribute_value)
      expect(subject.send(attribute_name)).to eq(attribute_value)
    end

    it "add attribute to attributes hash" do
      expect(subject.attributes).to have_key(attribute_name)
    end


  end

  context 'inheritance' do
    subject { Class.new(test_class) }
    it { is_expected.to respond_to(:attribute) }
    it { is_expected.to respond_to(:attribute_set) }

    it 'create new attribute set for child classes' do
      expect(subject.attribute_set).to_not equal(test_class.attribute_set)
    end
  end
end