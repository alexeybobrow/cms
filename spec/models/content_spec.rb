require 'spec_helper'

describe Content do
  it { is_expected.to respond_to(:markup_language) }
  it { is_expected.to respond_to(:body) }

  context '.defaults' do
    its(:markup_language) { is_expected.to eq 'markdown' }
  end
end
