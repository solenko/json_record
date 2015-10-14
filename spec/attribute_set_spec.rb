require 'spec_helper'

describe JsonRecord::AttributeSet do
  let(:model_class) { Class.new }

  context 'class methods' do
    subject { JsonRecord::AttributeSet }

    describe '.setup' do
      before { JsonRecord::AttributeSet.setup(model_class) }
      it 'create instance for model class' do
        expect(model_class.attribute_set).to be_instance_of(subject)
      end

      %w(attribute_set attribute_names).each do |method|
        it "add .#{method} class method" do
          expect(model_class).to respond_to(method)
        end
      end
    end
  end

  context 'instance methods' do
    subject { JsonRecord::AttributeSet.new(model_class) }

    describe '#model_class' do
      it 'store model class passed to constructor' do
        expect(subject.model_class).to equal(model_class)
      end
    end

    describe '#append' do
      let(:first_attribute_name) { "first_name" }
      let(:second_attribute_name) { "second_name" }

      before { subject.append(first_attribute_name) }

      it 'raise error for duplicated attribute name' do
        expect {subject.append(first_attribute_name) }.to raise_error(JsonRecord::DuplicatedAttribute)
      end

      it 'add new attribute to set' do
        expect {subject.append(second_attribute_name) }.to change { subject.size }.by(1)
      end

      it 'instantiate new Attribute' do
        expect(subject.definitions.size).to eq(1)
        expect(subject.definitions.first).to be_instance_of(JsonRecord::Attribute)
        expect(subject.definitions.first.name).to eq(first_attribute_name.to_sym)
      end


    end

    describe '#has_attribute?' do
      let(:first_attribute_name) { "first_name" }
      let(:second_attribute_name) { "second_name" }

      before { subject.append(first_attribute_name) }

      it 'return true for existed attributes' do
        expect(subject.has_attribute?(first_attribute_name)).to eq(true)
      end

      it 'return false for non existed attributes' do
        expect(subject.has_attribute?(second_attribute_name)).to eq(false)
      end

    end
  end





end