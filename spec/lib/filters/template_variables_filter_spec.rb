require 'spec_helper'

describe Cms::Filters::TemplateVariablesFilter do
  it 'does not modifies text' do
    filter = Cms::Filters::TemplateVariablesFilter.new('test text')
    expect(filter.call).to eq('test text')
  end

  it 'extracts variables' do
    filter = Cms::Filters::TemplateVariablesFilter.new("{ header = false}\ntest text")
    expect(filter.call).to eq("\ntest text")
    expect(filter.instance_variable_get(:@variables)).to eq({ 'header' => 'false' })
  end

  it 'fills context with variables' do
    ctxt = { template_variables: {} }
    filter = Cms::Filters::TemplateVariablesFilter.new("{ header = false}\ntest text", ctxt)
    filter.call

    expect(ctxt[:template_variables]).to eq({ 'header' => 'false' })
  end
end
