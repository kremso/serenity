module Serenity
  class XmlReader

    def initialize src
      @src = src
    end

    def each_node
      last_match_pos = 0

      @src.scan(/<.*?>/) do |node|
        m = Regexp.last_match
        if m.begin(0) > last_match_pos
          text = @src[last_match_pos...m.begin(0)]
          yield text, node_type(text) if text.gsub(/\s+/, '') != ''
        end

        last_match_pos = m.end(0)
        yield node, NodeType::TAG
      end
    end

    def node_type text
      if text =~ /\s*\{%[^=#].+?%\}\s*/
        NodeType::CONTROL
      else
        NodeType::TEMPLATE
      end
    end
  end
end
