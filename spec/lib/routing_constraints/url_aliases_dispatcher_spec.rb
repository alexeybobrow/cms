require 'spec_helper'

describe Cms::RoutingConstraints::UrlAliasesDispatcher do
  let!(:page) { create :page, url: '/home-page' }
  let(:router) { double }
  let(:env) { double }

  subject { Cms::RoutingConstraints::UrlAliasesDispatcher.new(router) }

  it 'redirects to primary url' do
    page.urls.create(name: '/home-page-alias', primary: false)

    expect(subject).to receive(:url_from).and_return('home-page-alias')
    expect(subject).to receive(:redirect_to).with('/home-page', env)

    subject.call(env)
  end

  it 'calls failure app if not found' do
    Cms.failure_app = double

    expect(subject).to receive(:url_from).and_return('non-existing-page')
    expect(Cms.failure_app).to receive(:call).with(env)

    subject.call(env)
  end
end
