module Serenity
  class XmlReader
    include Enumerable

    def initialize src
      @src = src
    end

    def each
      last_match_pos = 0

      @src.scan(/<.*?>/) do |node|
        m = Regexp.last_match
        if m.begin(0) > last_match_pos + 1
          text = @src[last_match_pos...m.begin(0)]
          yield text if text.gsub(/\s+/, '') != ''
        end

        last_match_pos = m.end(0)
        yield node
      end
    end
  end
end
