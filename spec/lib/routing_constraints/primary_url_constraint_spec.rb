require 'spec_helper'

describe Cms::RoutingConstraints::PrimaryUrlConstraint do
  let!(:page) { create :page, url: '/home-page' }
  let(:request) { double }

  it 'matches primary urls' do
    expect(subject).to receive(:name_from).and_return('home-page')
    expect(subject.matches?(request)).to be_truthy
  end

  it 'dont matches url aliases' do
    page.urls.create(name: '/home-page-alias', primary: false)

    expect(subject).to receive(:name_from).and_return('home-page-alias')
    expect(subject.matches?(request)).to be_falsy
  end

  it 'returns nil if not found' do
    expect(subject).to receive(:name_from).and_return('non-existing-page')
    expect(subject.matches?(request)).to be_nil
  end
end
