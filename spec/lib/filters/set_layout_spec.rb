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

  it 'reads template variables from layout' do
    ctxt = { template_variables: {} }
    create :fragment, slug: 'blog', content_body: '{var = test}{content}'
    filter = Cms::Filters::SetLayout.new("{ layout = blog }\ntest", ctxt)
    filter.call
    expect(ctxt[:template_variables]).to eq({'var' => 'test', 'layout' => 'blog'})
  end

  context 'from path prefix' do
    before do
      create :fragment, slug: 'blog', content_body: '<div class="wrap">{content}</div>'
    end

    it 'takes layout' do
      filter = Cms::Filters::SetLayout.new("test")
      filter.context[:path] = '/blog/some/article'
      expect(filter.call.squish).to eq('<div class="wrap">test</div>'.squish)
    end

    it 'works for homepage' do
      filter = Cms::Filters::SetLayout.new("test")
      filter.context[:path] = '/'
      expect(filter.call).to eq('test')
    end

    it 'works for one-level paths' do
      filter = Cms::Filters::SetLayout.new("test")
      filter.context[:path] = '/blog'
      expect(filter.call.squish).to eq('<div class="wrap">test</div>'.squish)
    end

    it 'works for paths with locales' do
      filter = Cms::Filters::SetLayout.new("test")
      filter.context[:path] = '/en/blog/some/article'
      expect(filter.call.squish).to eq('<div class="wrap">test</div>'.squish)
    end
  end
end
