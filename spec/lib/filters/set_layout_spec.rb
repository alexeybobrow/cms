require 'spec_helper'

describe Cms::Filters::SetLayout do
  it 'wraps content into default layout if exists' do
    create :fragment, slug: 'default_layout', content_body: '<div class="wrap">{content}</div>'
    filter = Cms::Filters::SetLayout.new('test')
    expect(filter.call.squish).to eq('<div class="wrap">test</div>'.squish)
  end

  it 'does not wrap content if there is no layout' do
    filter = Cms::Filters::SetLayout.new('test')
    expect(filter.call).to eq('test')
  end

  it 'reads layout name from content body' do
    create :fragment, slug: 'blog', content_body: '<div class="wrap">{content}</div>'
    filter = Cms::Filters::SetLayout.new("{ layout = blog }\ntest")
    expect(filter.call.squish).to eq('<div class="wrap"> test</div>'.squish)
  end
end
