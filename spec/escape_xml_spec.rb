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
end
