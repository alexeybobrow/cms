require 'spec_helper'

describe Cms::ClearCache do
  before do
    # set default value
    described_class.around_perform = -> (options, &perform) { perform.call }
  end

  describe '.perform' do
    it 'clears Rails.cache' do
      expect(Rails.cache).to receive(:clear)
      described_class.perform
    end
  end

  describe '.configure' do
    it 'passes ClearCache class as args' do
      described_class.configure do |config|
        expect(config).to eq(described_class)
      end
    end
  end

  context 'around_perform' do
    it 'allows to stop perform' do
      expect_any_instance_of(described_class).not_to receive(:perform)
      described_class.around_perform = lambda do |options, &perform|
        # look ma, no perform
      end
      described_class.perform
    end

    it 'passes perform action as a param' do
      expect_any_instance_of(described_class).to receive(:perform)
      described_class.around_perform = lambda do |options, &perform|
        perform.call
      end
      described_class.perform
    end
  end
end
