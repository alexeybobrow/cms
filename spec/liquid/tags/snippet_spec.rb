require 'spec_helper'

describe Cms::Liquid::Tags::Snippet do
  let(:snippet_name) { 'contact_form' }
  let(:liquid_tag) { described_class.parse('snippet', snippet_name, '', []) }

  describe '.render' do
    it 'renders haml with snippet content' do
      content = 'some content'
      allow(liquid_tag).to receive(:template_content).and_return(content)
      expect(liquid_tag).to receive(:render_haml).with(content, {})

      liquid_tag.render({})
    end

    it 'reads template file from file system' do
      context = double('context').as_null_object

      expect(::Liquid::Template.file_system).to receive(:read_template_file)
        .with(snippet_name, anything).and_return('')

      liquid_tag.render(context)
    end
  end
end
