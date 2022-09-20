require 'spec_helper'

describe Cms::Filters::SyntaxHighlight do
  let(:code_snippet) { 'const foo = "bar"' }

  it 'detects javascript language if not specified' do
    filter = Cms::Filters::SyntaxHighlight.new("<pre>#{code_snippet}</pre>")

    html = <<-HTML
<div class="highlight">
  <pre class="language-javascript">
    <code><span class="kd">const</span> <span class="nx">foo</span> <span class="o">=</span> <span class="dl">"</span><span class="s2">bar</span><span class="dl">"</span></code>
  </pre>
</div>
HTML

    expect(filter.call.to_xhtml).to eq(html.chop)
  end

  it 'detects html language if not specified' do
    filter = Cms::Filters::SyntaxHighlight.new("<pre>&lt;p&gt;Hello, world&lt;/p&gt;</pre>")

    html = <<-HTML
<div class="highlight">
  <pre class="language-html">
    <code><span class="nt">&lt;p&gt;</span>Hello, world<span class="nt">&lt;/p&gt;</span></code>
  </pre>
</div>
HTML

    expect(filter.call.to_xhtml).to eq(html.chop)
  end

  it 'uses specified language' do
    filter = Cms::Filters::SyntaxHighlight.new("<pre><div class=\"language-javascript\">#{code_snippet}</div></pre>")

    html = <<-HTML
<div class="highlight">
  <pre class="language-javascript">
    <code><span class="kd">const</span> <span class="nx">foo</span> <span class="o">=</span> <span class="dl">"</span><span class="s2">bar</span><span class="dl">"</span></code>
  </pre>
</div>
HTML

    expect(filter.call.to_xhtml).to eq(html.chop)
  end
end
