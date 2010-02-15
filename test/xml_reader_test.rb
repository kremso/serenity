require 'test_helper'

module Serenity
  class XmlReaderTest < Test::Unit::TestCase
    context "an xml reader" do
      should "stream the xml, tag by tag" do
        xml  = <<-EOF
          <?xml version="1.0" encoding="UTF-8"?><office:document-content><office:scripts/>
          <office:body><text:p style="Standard">This is a sentence</text:p><text:s>Yeah</text:s></office:body>
          </office:document-content>
        EOF

        expected = ['<?xml version="1.0" encoding="UTF-8"?>', '<office:document-content>',
                    '<office:scripts/>', '<office:body>', '<text:p style="Standard">',
                    'This is a sentence', '</text:p>', '<text:s>', 'Yeah', '</text:s>',
                    '</office:body>', '</office:document-content>']

        result = []

        reader = XmlReader.new xml
        reader.each do |node|
          result << node
        end

        assert_equal expected, result
      end
    end
  end
end

