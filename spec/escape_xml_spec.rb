require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe String do
  it 'escapes <' do
    expect('1 < 2'.escape_xml).to eq('1 &lt; 2')
  end

  it 'escapes >' do
    expect('2 > 1'.escape_xml).to eq('2 &gt; 1')
  end

  it 'escapes &' do
    expect('1 & 2'.escape_xml).to eq('1 &amp; 2')
  end

  it 'escapes < > &' do
    expect('1 < 2 && 2 > 1'.escape_xml).to eq('1 &lt; 2 &amp;&amp; 2 &gt; 1')
  end
end
