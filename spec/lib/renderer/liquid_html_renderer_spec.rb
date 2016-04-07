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
  end
end
