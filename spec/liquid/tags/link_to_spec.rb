require 'spec_helper'

describe Cms::Liquid::Tags::LinkTo do
  include ActionView::TestCase::Behavior

  let(:link_to_markup) { "<a href=\"/services\">Services</a>" }
  let(:link_to_with_class) { "<a class=\"test-link\" href=\"/services\">Services</a>" }

  describe '.render' do
    let(:env) { OpenStruct.new(environments: [{ view: _view }]) }

    it 'draws link', type: :helper do
      rendered = described_class.parse('link_to', "'Services' path: /services", '', []).render(env)
      expect(rendered).to eq(link_to_markup)
    end

    it 'takes options', type: :helper do
      rendered = described_class.parse('link_to', "'Services' path: /services, class: test-link", '', []).render(env)
      expect(rendered).to eq(link_to_with_class)
    end
  end
end
