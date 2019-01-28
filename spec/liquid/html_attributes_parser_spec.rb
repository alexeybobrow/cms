require 'spec_helper'

describe Cms::Liquid::HtmlAttributesParser do
  describe '.transform' do
    shared_examples 'empty hash returner' do
      it 'returns empty hash' do
        expect(described_class.transform(str: attributes_string)).to eq({})
      end
    end

    context 'if nothing to transform' do
      it 'returns empty hash' do
        expect(described_class.transform).to eq({})
      end
    end

    context 'if not string is tried to transform' do
      it_behaves_like 'empty hash returner' do
        let(:attributes_string) { 1 }
      end
    end

    context 'if string is nil' do
      it_behaves_like 'empty hash returner' do
        let(:attributes_string) { nil }
      end
    end

    context 'if string is empty' do
      it_behaves_like 'empty hash returner' do
        let(:attributes_string) { '' }
      end
    end

    context 'if string is present' do
      let(:attributes_string) do
        %Q[{: .class.next__class.another--class, #id, data:{content: "test"}, \
           style: "display: inline-block;", target: "_blank", rel: "nofollow" :}]
      end
      let(:result_hash) do
        {
          class: 'class next__class another--class',
          id: 'id',
          style: 'display: inline-block;',
          target: '_blank',
          rel: 'nofollow',
          'data-content' => 'test'
        }
      end

      it 'returns the result hash' do
        expect(described_class.transform(str: attributes_string)).to eq(result_hash)
      end
    end
  end
end
