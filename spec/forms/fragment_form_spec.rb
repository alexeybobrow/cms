require 'spec_helper'
require 'active_attr/rspec'

describe Cms::FragmentForm do
  include Shoulda::Matchers::ActiveModel

  subject { described_class.new({}, Fragment.new) }

  it { is_expected.to have_attribute(:content_attributes) }
  it { is_expected.to have_attribute(:slug) }
  it { is_expected.to respond_to(:content) }

  context 'validations' do
    let(:invalid_slugs) { %w[~slug !slug @slug #slug $slug %slug ^slug &slug *slug (slug )slug =slug +slug fragment\ slug] }
    let(:valid_slugs) { %w[slug slug01 slug_02 slug-03 SlUg04 ru/test] }

    it { is_expected.not_to allow_value('').for(:slug) }
    it { is_expected.not_to allow_value(nil).for(:slug) }

    it 'validates uniqueness' do
      create :fragment, slug: 'slug'
      is_expected.not_to allow_value('slug').for(:slug).ignoring_interference_by_writer
    end

    it 'validates format' do
      valid_slugs.each do |valid_slug|
        is_expected.to allow_value(valid_slug).for(:slug)
      end

      invalid_slugs.each do |invalid_slug|
        is_expected.not_to allow_value(invalid_slug).for(:slug)
      end
    end

    it 'validates content' do
      fragment = create :fragment, slug: 'slug'
      fragment.content.markup_language = 'invalid'
      form = described_class.new({}, fragment)

      expect(form.save).to be_nil
      expect(form.valid?).to be_falsy
    end
  end

  describe '#content' do
    it 'returns ContentForm instance' do
      expect(subject.content).to be_a Cms::ContentForm
    end

    it 'passes content_attributes to ContentForm' do
      form = described_class.new({ content_attributes: { body: 'TDD rules' } }, Fragment.new)
      expect(form.content.body).to eq('TDD rules')
    end

    it 'builds content for new fragment' do
      fragment = Fragment.new
      form = described_class.new({ content_attributes: { body: 'TDD rules' } }, fragment)
      form.content

      expect(fragment.content).not_to be_nil
      expect(fragment.content).to be_a Content
    end

    it 're-uses content for persisted fragment' do
      content = create :content
      fragment = create :fragment, content: content
      form = described_class.new({ content_attributes: { body: 'TDD rules' } }, fragment)

      expect(form.content.model).to eq(content)
    end
  end

  describe '#valid?' do
    it 'validates content form' do
      expect(subject.content).to receive(:valid?)
      subject.valid?
    end
  end
end
