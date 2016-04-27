require 'spec_helper'

describe Content do
  it { is_expected.to respond_to(:markup_language) }
  it { is_expected.to respond_to(:body) }

  context '.defaults' do
    its(:markup_language) { is_expected.to eq 'markdown' }
  end

  %i(content annotation).each do |content_type|
    it "touches the parent Page#updated_at on #{content_type} update" do
      Timecop.freeze('2016-01-01')
      page = create :page, :"#{content_type}_body" => 'Wellcome to my world of death and pain!'

      Timecop.freeze('2026-12-12')
      expect {
        page.public_send(content_type).update_attributes!(body: 'Sweet child o\' mine')
      }.to change { page.reload.updated_at }
    end
  end
end
