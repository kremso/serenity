require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe String do
  it 'should escape <' do
    '1 < 2'.escape_xml.should == '1 &lt; 2'
  end

  it 'should escape >' do
    '2 > 1'.escape_xml.should == '2 &gt; 1'
  end

  it 'should escape &' do
    '1 & 2'.escape_xml.should == '1 &amp; 2'
  end

  it 'should escape < > &' do
    '1 < 2 && 2 > 1'.escape_xml.should == '1 &lt; 2 &amp;&amp; 2 &gt; 1'
  end

  it 'should escape a frozen string without raising FrozenError' do
    '1 < 2'.freeze.escape_xml.should == '1 &lt; 2'
  end

  it 'should convert newlines on a frozen string without raising FrozenError' do
    "First line\nSecond line".freeze.convert_newlines.should == 'First line<text:line-break/>Second line'
  end
end
