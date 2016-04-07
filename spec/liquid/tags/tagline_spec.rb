require 'spec_helper'

describe Tags::Tagline do
  let(:tagline_liquid) {
    <<-liq
      {% tagline %}
        This is a tagline
      {% endtagline %}
    liq
  }

  let(:tagline_html) {
    <<-html
      <div class="landing-tagline">
        This is a tagline
      </div>
    html
  }

  describe '.render' do
    it 'renders tagline tag' do
      expect(::Liquid::Template.parse(tagline_liquid).render().squish).to eq(tagline_html.squish)
    end
  end
end
