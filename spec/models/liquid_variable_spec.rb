require 'spec_helper'

describe LiquidVariable do
  subject { create :liquid_variable }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:value) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe '.as_hash' do
    it 'returns variables hash' do
      create :liquid_variable, name: 'width', value: '100px'
      create :liquid_variable, name: 'color', value: 'red'

      expect(LiquidVariable.as_hash).to eq({ 'width' => '100px', 'color' => 'red' })
    end
  end
end
