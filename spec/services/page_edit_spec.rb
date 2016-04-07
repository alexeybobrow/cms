require 'spec_helper'

describe Cms::PageEdit do
  subject { Cms::PageEdit.new({}, build(:page)) }

  it { is_expected.to respond_to(:page) }
  it { is_expected.to respond_to(:params) }

  describe '#dispatch' do
    it 'returns PageUrlForm when form kind is url' do
      subject.dispatch('url'){|result| expect(result[:page_form]).to be_a Cms::PageUrlForm }
    end

    it 'returns PageUrlForm when form kind is meta' do
      subject.dispatch('meta'){|result| expect(result[:page_form]).to be_a Cms::PageMetaForm }
    end

    it 'returns two forms when form kind is content' do
      subject.dispatch('content') do |result|
        expect(result[:page_form]).to be_a Cms::ContentForm
        expect(result[:image_attachment_form]).to be_a Cms::ImageAttachmentForm
      end
    end

    it 'returns two forms when form kind is annotation' do
      subject.dispatch('annotation') do |result|
        expect(result[:page_form]).to be_a Cms::ContentForm
        expect(result[:image_attachment_form]).to be_a Cms::ImageAttachmentForm
      end
    end

    it 'returns form kind as a second parameter' do
      subject.dispatch('any_kind'){|result, form_kind| expect(form_kind).to eq 'any_kind' }
    end
  end
end
