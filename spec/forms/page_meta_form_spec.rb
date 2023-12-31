require 'spec_helper'
require 'active_attr/rspec'

describe Cms::PageMetaForm do
  include Shoulda::Matchers::ActiveModel

  let(:form) { described_class.new({}, Page.new) }
  subject { form }

  it { is_expected.to have_attribute(:title) }
  it { is_expected.to have_attribute(:name) }
  it { is_expected.to have_attribute(:posted_at) }
  it { is_expected.to have_attribute(:tags) }
  it { is_expected.to have_attribute(:authors) }
  it { is_expected.to have_attribute(:meta) }

  context 'validation' do
    context 'title' do
      it { is_expected.to allow_value('Page title').for(:title) }
      it { is_expected.to allow_value('').for(:title) }
    end

    context 'name' do
      it { is_expected.to allow_value('Page name').for(:name) }
      it { is_expected.to allow_value('').for(:name) }
    end
  end

  describe '#meta' do
    context 'empty values' do
      it 'skips values with empty property' do
        form = described_class.new({meta: [{'property' => 'test', 'content' => ''}]}, Page.new)
        expect(form.meta).to eq([])
      end

      it 'skips values with empty content' do
        form = described_class.new({meta: [{'property' => '', 'content' => 'test'}]}, Page.new)
        expect(form.meta).to eq([])
      end
    end

    context 'attributes normalization after initialize' do
      let(:array_attributes) { [{'property' => 'test', 'content' => 'test'}] }
      let(:hash_attributes) { {'0'=>{'property' => 'test', 'content' => 'test'}} }

      it 'takes an array' do
        form = described_class.new({meta: array_attributes}, Page.new)
        expect(form.meta).to eq(array_attributes)
      end

      it 'takes a hash' do
        form = described_class.new({meta: hash_attributes}, Page.new)
        expect(form.meta).to eq(array_attributes)
      end
    end
  end

  describe '#tags=' do
    it 'works with string' do
      form.tags = 'this, is, tags'
      expect(form.tags).to eq(%w(this is tags))
    end

    it 'strips string value' do
      form.tags = '    this ,  is ,tags    '
      expect(form.tags).to eq(%w(this is tags))
    end

    it 'works with array' do
      form.tags = %w(this is tags)
      expect(form.tags).to eq(%w(this is tags))
    end
  end

  describe '#authors=' do
    it 'works with string' do
      form.authors = 'this, is, authors'
      expect(form.authors).to eq(%w(this is authors))
    end

    it 'strips string value' do
      form.authors = '    this ,  is ,authors    '
      expect(form.authors).to eq(%w(this is authors))
    end

    it 'works with array' do
      form.authors = %w(this is authors)
      expect(form.authors).to eq(%w(this is authors))
    end
  end
end
