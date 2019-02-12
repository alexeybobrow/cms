require 'spec_helper'

describe Cms::Liquid::HtmlAttributesParser do
  describe '.transform' do
    shared_examples 'empty hash returner' do
      it 'returns empty hash' do
        expect(described_class.transform(attributes_string)).to eq({})
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
        %Q[{: .class.next__class.another--class, #id, style: "display: inline-block;", target: "_blank", \
               rel: "nofollow", data: {content: "test", handler: 'toggle'}, aria: {labelledby: 'ch1Tab'} :}]
      end
      let(:result_hash) do
        {
            class: 'class next__class another--class',
            id: 'id',
            style: 'display: inline-block;',
            target: '_blank',
            rel: 'nofollow',
            'data-content' => 'test',
            'data-handler' => 'toggle',
            'aria-labelledby' => 'ch1Tab'
        }
      end

      it 'returns the result hash' do
        expect(described_class.transform(attributes_string)).to eq(result_hash)
      end
    end

    context 'if syntax has unbalanced brackets' do
      let(:attributes_string) do
        %Q[{: data: {content: 'test', {handler: 'toggle'} :}]
      end
      it 'converts to id correctly' do
        expect {described_class.transform(attributes_string)}.to raise_error(described_class::AttributesSyntaxError, /unbalanced brackets/i)
      end
    end

    context 'if syntax has redundant brackets' do
      let(:attributes_string) do
        %Q[{: data: {content: 'test', {handler: 'toggle'},  test: 'test'} :}]
      end
      it 'converts to id correctly' do
        expect {described_class.transform(attributes_string)}.to raise_error(described_class::AttributesSyntaxError, /redundant brackets/i)
      end
    end

    context 'if syntax has missing comma' do
      let(:attributes_string) do
        %Q[{: data: {content: 'test', handler: 'toggle' test: 'test'} :}]
      end
      it 'converts to id correctly' do
        expect {described_class.transform(attributes_string)}.to raise_error(described_class::AttributesSyntaxError, /missing coma or quotes/i)
      end
    end

    context 'if syntax has missing quotes' do
      let(:attributes_string) do
        %Q[{: data: {content: 'test', handler: toggle, test: 'test'} :}]
      end
      it 'converts to id correctly' do
        expect {described_class.transform(attributes_string)}.to raise_error(described_class::AttributesSyntaxError, /missing coma or quotes/i)
      end
    end
  end
end
