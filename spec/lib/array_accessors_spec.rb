require 'spec_helper'

describe Cms::ArrayAccessors do
  let(:parent) { Class.new { attr_accessor :test; def set_test(value); @test = value; end } }
  let(:clazz_with_writer) { Class.new(parent) { extend Cms::ArrayAccessors; array_writer :test } }
  let(:clazz_with_reader) { Class.new(parent) { extend Cms::ArrayAccessors; array_reader :test } }
  let(:clazz_with_accessor) { Class.new(parent) { extend Cms::ArrayAccessors; array_accessor :test } }

  it 'allows to add writers' do
    expect(clazz_with_writer).to respond_to(:array_writer)
  end

  describe '.array_writer' do
    it 'adds a writer' do
      expect(clazz_with_writer.new).to respond_to(:"test=")
    end
  end

  describe '.array_reader' do
    it 'adds a writer' do
      expect(clazz_with_reader.new).to respond_to(:"test")
    end
  end

  describe '.array_accessor' do
    subject { clazz_with_accessor.new }

    it 'adds a writer' do
      is_expected.to respond_to(:"test")
      is_expected.to respond_to(:"test=")
    end
  end

  describe '#test' do
    subject { clazz_with_reader.new }

    it 'works for empty array' do
      subject.set_test([])
      expect(subject.test).to eq('')
    end

    it 'works for nil' do
      subject.set_test(nil)
      expect(subject.test).to eq('')
    end

    it 'works for boolean' do
      subject.set_test(true)
      expect(subject.test).to eq('true')
    end

    it 'returns a string if parent attr is an array' do
      subject.set_test([1, 2])
      expect(subject.test).to eq('1, 2')
    end

    it 'returns a string if parent attr is a string' do
      subject.set_test('1, 2, 5')
      expect(subject.test).to eq('1, 2, 5')
    end
  end

  describe '#test=' do
    subject { clazz_with_writer.new }

    it 'works for empty array' do
      expect { subject.test = [] }.to change { subject.test }.to []
    end

    it 'works for nil' do
      expect { subject.test = nil }.to change { subject.test }.to []
    end

    it 'works for boolean' do
      expect { subject.test = true }.to change { subject.test }.to ['true']
    end

    it 'takes an array' do
      expect { subject.test = [1, 2] }.to change { subject.test }.to [1, 2]
    end

    it 'works for empty string' do
      expect { subject.test = '' }.to change { subject.test }.to []
    end

    it 'takes a string' do
      expect { subject.test = "1, 2" }.to change { subject.test }.to ['1', '2']
    end
  end
end
