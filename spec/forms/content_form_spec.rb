require 'spec_helper'
require 'active_attr/rspec'

describe Cms::ContentForm do
  include Shoulda::Matchers::ActiveModel
  subject { Cms::ContentForm.new({}, Content.new) }

  it { is_expected.to have_attribute(:markup_language).with_default_value_of('markdown') }
  it { is_expected.to have_attribute(:body) }

  context 'validations' do
    it { is_expected.to validate_inclusion_of(:markup_language).in_array(Content.formats) }
    it { is_expected.not_to allow_value('').for(:markup_language) }
    it { is_expected.not_to allow_value(nil).for(:markup_language) }
  end
end
