require 'spec_helper'

describe Tags::BlogPosts do
  let(:liquid_tag) { Tags::BlogPosts.parse('blog_posts', '', '', []) }

  describe '.posts_limit' do
    it 'returns value provided through tag arguments' do
      liquid_tag = Tags::BlogPosts.parse('blog_posts', 'limit: 42', '', [])
      expect(liquid_tag.send(:posts_limit)).to eq(42)
    end

    it 'has default value 4' do
      expect(liquid_tag.send(:posts_limit)).to eq(4)
    end
  end

  describe ".render" do
    let(:content) { 'some content' }
    let(:posts) { [] }

    it 'renders haml with blog posts' do
      allow(liquid_tag).to receive(:template_content).and_return(content)

      expect(liquid_tag).to receive(:posts).and_return(posts)
      expect(liquid_tag).to receive(:render_haml)
        .with(content, hash_including(posts: posts))

      liquid_tag.render({})
    end

    it 'reads template file from file system' do
      context = double('context').as_null_object

      allow(liquid_tag).to receive(:posts).and_return(posts)

      expect(::Liquid::Template.file_system).to receive(:read_template_file)
        .with('blog_posts', anything).and_return('')

      liquid_tag.render(context)
    end
  end
end
