require 'spec_helper'

describe Cms::Liquid::HtmlRenderer do
  let(:renderer) { described_class.new }

  context 'paragraphs' do
    it 'doesnt wrap at the begining' do
      doc = CommonMarker.render_doc("{% layout %}\n\n inner content")
      expect(renderer.render(doc)).to eq("{% layout %}\n<p>inner content</p>\n")
    end

    it 'doesnt wrap at the end' do
      doc = CommonMarker.render_doc("inner content\n\n{% layout %}")
      expect(renderer.render(doc)).to eq("<p>inner content</p>\n{% layout %}")
    end

    it 'doesnt wrap when used in the middle' do
      doc = CommonMarker.render_doc("outer content\n\n{% layout %}\n\nouter content")
      expect(renderer.render(doc)).to eq("<p>outer content</p>\n{% layout %}\n<p>outer content</p>\n")
    end

    it 'wraps when there is no newline between tag and content' do
      doc = CommonMarker.render_doc("{% layout %}\n inner content")
      expect(renderer.render(doc)).to eq("<p>{% layout %}\ninner content</p>\n")
    end

    it 'wraps when there is no newlines' do
      doc = CommonMarker.render_doc("outer content\n{% link %}\nouter content")
      expect(renderer.render(doc)).to eq("<p>outer content\n{% link %}\nouter content</p>\n")
    end

    it 'doesnt wrap with options' do
      doc = CommonMarker.render_doc("{% form_for 'user', url: '/users' %}\n\n inner content")
      expect(renderer.render(doc)).to eq("{% form_for 'user', url: '/users' %}\n<p>inner content</p>\n")
    end

    it 'doesnt wrap when there is two tags at the beginning' do
      doc = CommonMarker.render_doc("{% layout %} {% contact_button %}\n\ninner content")
      expect(renderer.render(doc)).to eq("{% layout %} {% contact_button %}\n<p>inner content</p>\n")
    end

    it 'doesnt wrap when there is two tags at the end' do
      doc = CommonMarker.render_doc("inner content\n\n{% end_layout %} {% contact_button %}")
      expect(renderer.render(doc)).to eq("<p>inner content</p>\n{% end_layout %} {% contact_button %}")
    end

    it 'doesnt wrap in the middle with content' do
      doc = CommonMarker.render_doc("{% layout %}\n\ninner content\n\n{% fragment 'contact_form' %}\n\n{% end_layout %}")
      expect(renderer.render(doc)).to eq("{% layout %}\n<p>inner content</p>\n{% fragment 'contact_form' %}{% end_layout %}")
    end

    it 'add html attributes to node :paragraph' do
      doc = CommonMarker.render_doc("{: .paragraph, #test, data: {test: 'test'} :}\ntest text")
      expect(renderer.render(doc)).to eq("<p id=\"test\" class=\"paragraph\" data-test=\"test\">\ntest text</p>\n")
    end

    it 'doesnt add html attributes to parent node if :link node with style tag placed inside this one' do
      doc = CommonMarker.render_doc("inner content [name](https://www.test.com){: .link :}\nanother content\n\ninner content [name](https://www.test.com){: .test :}\nanother content")
      expect(renderer.render(doc)).to eq("<p>inner content <a href=\"https://www.test.com\" class=\"link\">name</a>\nanother content</p>\n<p>inner content <a href=\"https://www.test.com\" class=\"test\">name</a>\nanother content</p>\n")
    end

    it ':link node wo html attributes ' do
      doc = CommonMarker.render_doc("[name](https://www.test.com)")
      expect(renderer.render(doc)).to eq("<p><a href=\"https://www.test.com\">name</a></p>\n")
    end

    it 'add html attributes to :link node' do
      doc = CommonMarker.render_doc("[name](https://www.test.com){: .link.test, #test, target: '_blank', rel: 'nofollow', data: {handler: 'toggle', content: 'test'}, aria: {labelledby: 'ch1Tab'} :}")
      expect(renderer.render(doc)).to eq("<a href=\"https://www.test.com\" id=\"test\" class=\"link test\" target=\"_blank\" rel=\"noopener noreferrer nofollow\" data-handler=\"toggle\" data-content=\"test\" aria-labelledby=\"ch1Tab\">name</a>")
    end

    it ':header node wo html attributes' do
      doc = CommonMarker.render_doc("# test text")
      expect(renderer.render(doc)).to eq("<h1>test text</h1>\n")
    end

    it 'add html attributes to :header node' do
      doc = CommonMarker.render_doc("{: .paragraph, #test, data: {test: 'test'} :}\n# test text")
      expect(renderer.render(doc)).to eq("<h1 id=\"test\" class=\"paragraph\" data-test=\"test\">test text</h1>\n")
    end
  end
end
