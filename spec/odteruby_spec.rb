require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Serenity

  describe OdtEruby do
    before(:each) do
      name = 'test_name'
      type = 'test_type'
      rows = []
      rows << Ship.new('test_name_1', 'test_type_1')
      rows << Ship.new('test_name_2', 'test_type_2')
      @context = binding
    end

    def squeeze text
      text.each_char.inject('') { |memo, line| memo += line.strip } unless text.nil?
    end

    def run_spec template, expected, context=@context
      content = OdtEruby.new(XmlReader.new template)
      result = content.evaluate context

      squeeze(result).should == squeeze(expected)
    end

    it 'should escape single quotes properly' do
      expected = template = "<text:p>It's a 'quote'</text:p>"

      run_spec template, expected
    end

    it 'should properly escape special XML characters ("<", ">", "&")' do
      template = "<text:p>{%= description %}</text:p>"
      description = 'This will only hold true if length < 1 && var == true or length > 1000'
      expected = "<text:p>This will only hold true if length &lt; 1 &amp;&amp; var == true or length &gt; 1000</text:p>"

      run_spec template, expected, binding
    end

    it 'should replace variables with values from context' do
      template = <<-EOF
        <text:p text:style-name="Text_1_body">{%= name %}</text:p>
        <text:p text:style-name="Text_1_body">{%= type %}</text:p>
        <text:p text:style-name="Text_1_body"/>
      EOF

      expected = <<-EOF
        <text:p text:style-name="Text_1_body">test_name</text:p>
        <text:p text:style-name="Text_1_body">test_type</text:p>
        <text:p text:style-name="Text_1_body"/>
      EOF

      run_spec template, expected
    end

    it 'should replace multiple variables on one line' do
      template = '<text:p text:style-name="Text_1_body">{%= type %} and {%= name %}</text:p>'
      expected = '<text:p text:style-name="Text_1_body">test_type and test_name</text:p>'

      run_spec template, expected
    end

    it 'should remove empty tags after a control structure processing' do
      template = <<-EOF
        <table:table style="Table_1">
          <table:row style="Table_1_A1">
            <table:cell style="Table_1_A1_cell">
              {% for row in rows do %}
            </table:cell>
          </table:row>
            <text:p text:style-name="Text_1_body">{%= row.name %}</text:p>
            <text:p text:style-name="Text_1_body">{%= row.type %}</text:p>
          <table:row style="Table_1_A1">
            <table:cell style="Table_1_A1_cell">
              {% end %}
            </table:cell>
          </table:row>
        </table:table>
      EOF

      expected = <<-EOF
        <table:table style="Table_1">
            <text:p text:style-name="Text_1_body">test_name_1</text:p>
            <text:p text:style-name="Text_1_body">test_type_1</text:p>
            <text:p text:style-name="Text_1_body">test_name_2</text:p>
            <text:p text:style-name="Text_1_body">test_type_2</text:p>
        </table:table>
      EOF

      run_spec template, expected
    end

    it 'should replace \n with soft newlines' do
      text_with_newline = "First line\nSecond line"

      template = '<text:p text:style-name="P2">{%= text_with_newline %}</text:p>'
      expected = '<text:p text:style-name="P2">First line <text:line-break/>Second line</text:p>'

      run_spec template, expected, binding
    end
  end
end
