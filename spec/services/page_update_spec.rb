require 'spec_helper'

describe Cms::PageUpdate do
  let(:page) { build :page }
  subject { Cms::PageUpdate.new({}, page) }

  describe '#save' do
    context 'url' do
      it 'returns PageUrlForm instance' do
        subject.save('url'){|_, forms| expect(forms[:page_form]).to be_a Cms::PageUrlForm }
      end

      it 'saves page if valid' do
        subject.save('url'){|page| expect(page).to be_persisted }
      end

      it 'doesn\'t save page if invalid' do
        upd_service = Cms::PageUpdate.new({ page: { url: 'some invalid stuff' } }, page)
        upd_service.save('url') do |model, forms|
          expect(forms[:page_form].valid?).to be_falsy
          expect(page).not_to be_persisted
          expect(model).to be_nil
        end
      end

      it 'returns form kind' do
        subject.save('url'){|model, forms, form_kind| expect(form_kind).to eq('url') }
      end
    end

    context 'meta' do
      it 'returns PageMetaForm instance' do
        subject.save('meta'){|_, forms| expect(forms[:page_form]).to be_a Cms::PageMetaForm }
      end

      it 'saves page if valid' do
        subject.save('meta'){|page| expect(page).to be_persisted }
      end

      it 'doesn\'t save page if invalid' do
        page.title = ''
        subject.save('meta') do |model, forms|
          expect(forms[:page_form].valid?).to be_falsy
          expect(page).not_to be_persisted
          expect(model).to be_nil
        end
      end
    end

    context 'content' do
      it 'returns two form instances' do
        subject.save('content') do |_, forms|
          expect(forms[:page_form]).to be_a Cms::ContentForm
          expect(forms[:image_attachment_form]).to be_a Cms::ImageAttachmentForm
        end
      end

      it 'saves page content if valid' do
        subject.save('content'){|model| expect(model).to be_persisted }
      end

      it 'doesn\'t save page content if invalid' do
        page.content.markup_language = ''
        subject.save('content') do |model, forms|
          expect(forms[:page_form].valid?).to be_falsy
          expect(page).not_to be_persisted
          expect(model).to be_nil
        end
      end
    end

    context 'annotation' do
      it 'returns two form instances' do
        subject.save('annotation') do |_, forms|
          expect(forms[:page_form]).to be_a Cms::ContentForm
          expect(forms[:image_attachment_form]).to be_a Cms::ImageAttachmentForm
        end
      end

      it 'saves page annotation if valid' do
        subject.save('annotation'){|model| expect(model).to be_persisted }
      end

      it 'doesn\'t save page annotation if invalid' do
        page.annotation.markup_language = ''
        subject.save('annotation') do |model, forms|
          expect(forms[:page_form].valid?).to be_falsy
          expect(page).not_to be_persisted
          expect(model).to be_nil
        end
      end
    end
  end
end
