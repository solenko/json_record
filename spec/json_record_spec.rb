require 'spec_helper'

describe JsonRecord do
  subject { JsonRecord } 
  
  it 'has a version number' do
    expect(JsonRecord::VERSION).not_to be nil
  end

  it 'have configuration' do
    expect(subject.configuration).to be_instance_of(JsonRecord::Configuration)
  end
  
  describe '.configure' do
    it 'yield with configuration object' do
      expect { |b| subject.configure(&b) }.to yield_with_args(JsonRecord::Configuration)
    end
  end

  context 'delegate methods to configuration' do
    let(:random_method_name) { "method_#{rand(100)}"}
    before do
      method = random_method_name
      JsonRecord::Configuration.class_eval do
        attr_accessor method
      end
    end

    it { is_expected.to respond_to(random_method_name) }
    it 'call method on configuration instance' do
      expect(subject.configuration).to receive(random_method_name)
      subject.send(random_method_name)
    end

  end
end
