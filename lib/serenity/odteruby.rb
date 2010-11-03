module Serenity
  class OdtEruby
    include Debug

    EMBEDDED_PATTERN = /\{%([=%]+)?(.*?)-?%\}/m

    def initialize template
      @src = convert template
      if debug?
        File.open(debug_file_path, 'w') do |f|
          f << @src
        end
      end
    end

    def evaluate context
      eval(@src, context)
    end

    private

    def convert template
      src = "_buf = '';"
      buffer = []
      buffer_next = []

      template.each_node do |node, type|
        if !buffer_next.empty?
          if is_matching_pair?(buffer.last, node)
            buffer.pop
            next
          elsif is_nonpair_tag? node
            next
          else
            buffer << buffer_next
            buffer.flatten!
            buffer_next = []
          end
        end

        if type == NodeType::CONTROL
          buffer_next = process_instruction(node)
        else
          buffer << process_instruction(node)
          buffer.flatten!
        end
      end

      buffer.each { |line| src << line.to_buf }
      src << "\n_buf.to_s\n"
    end

    def process_instruction text
      #text = text.strip
      pos = 0
      src = []

      text.scan(EMBEDDED_PATTERN) do |indicator, code|
        m = Regexp.last_match
        middle = text[pos...m.begin(0)]
        pos  = m.end(0)
        src << Line.text(middle) unless middle.empty?

        if !indicator            # <% %>
          src << Line.code(code)
        elsif indicator == '='   # <%= %>
          src << Line.string(code)
        elsif indicator == '%'   # <%% %>
          src << Line.literal(code)
        end
      end

      rest = pos == 0 ? text : text[pos..-1]

      src << Line.text(rest) unless rest.nil? or rest.empty?
      src
    end

    def is_nonpair_tag? tag
      tag =~ /<.+?\/>/
    end

    def is_matching_pair? open, close
      open = open.to_s.strip
      close = close.to_s.strip

      close == "</#{open[1, close.length - 3]}>"
    end
  end
end
