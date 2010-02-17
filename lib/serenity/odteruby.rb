module Serenity
  class OdtEruby
    include Debug

    EMBEDDED_PATTERN = /\{%(=+)?(.*?)-?%\}/m

    CONTROL_NODES = ['table:table-row', 'p:text']

    def initialize template
      @src = convert template
      if debug?
        File.open(File.join(debug_dir, "serenity_debug_#{rand(1000)}.rb"), 'a') do |f|
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
          puts "We have next buffer, checking tags: #{buffer.last} and #{node}"
          if is_matching_pair?(buffer.last, node)
            puts "Tags match"
            buffer.pop
            next
          elsif is_nonpair_tag? node
            next
          else
            puts "No match, appending #{buffer_next} to buffer"
            buffer << buffer_next
            buffer.flatten!
            buffer_next = []
          end
        end

        puts "Node is #{node} of type #{type}"

        if type == NodeType::CONTROL
          buffer_next = process_instruction(node)
        else
          buffer << process_instruction(node)
          buffer.flatten!
        end
      end

      buffer.each { |line| src << line.to_buf }
      src << "\n_buf.to_s\n"

      puts "FINAAAAAAAAAAAAAAAL #{src}"
      src
    end

    def process_instruction text
      puts "Processing instruction #{text}"
      text = text.strip
      pos = 0
      src = []

      text.scan(EMBEDDED_PATTERN) do |indicator, code|
        m = Regexp.last_match
        middle = text[pos...m.begin(0)]
        pos  = m.end(0)
        puts "Found #{indicator} in code #{code}, middle is #{middle}, pos is #{pos}, match starts at #{m.begin(0)}"
        #src << " _buf << '" << escape_text(middle) << "';" unless middle.empty?
        src << Line.text(middle) unless middle.empty?

        if !indicator              # <% %>
          #src << escape_code(code) << ";"
          src << Line.code(code)
        else                       # <%= %>
          #src << " _buf << (" << code << ").to_s;"
          src << Line.string(code)
        end

        puts "Src is now #{src}"
      end

      puts "After a scan loop, src is #{src} and text is now #{text}"

      rest = pos == 0 ? text : text[pos..-1]

      puts "Rest is: #{rest}"
      #src << " _buf << '" << escape_text(rest) << "';" unless rest.nil? or rest.empty?
      src << Line.text(rest) unless rest.nil? or rest.empty?

      puts "Final src: #{src}"
      src
    end

    def is_nonpair_tag? tag
      tag =~ /<.+?\/>/
    end

    def is_matching_pair? open, close
      open = open.to_s.strip
      close = close.to_s.strip

      open = "</#{open[1, close.length - 3]}>"
      puts "Matching #{open} against #{close}."
      match = close == open

      puts "Match?: #{match}"
      match
    end

    def is_control_node node
      CONTROL_NODES.detect { |i| node[0, node + 1] == "<#{node}" }
    end

    def convert_bullshit template
      src = "_buf = '';"
      buffer = []
      flush_buffer = false

      template.each do |node|
        if flush_buffer and !buffer.empty?
          if is_matching_pair?(buffer.pop, node)
            next
          else
            buffer = []
            flush_buffer = false
          end
        else
          buffer << node
        end

        pos = 0
        append_rest = true

        node.scan(EMBEDDED_PATTERN) do |indicator, code|
          m = Regexp.last_match
          text = node[pos...m.begin(0)]
          pos  = m.end(0)

          if !indicator              # <% %>
            src << escape_code(code) << ";"
            buffer.pop
            flush_buffer = true
            append_rest = false
            break
          else
            src << " _buf << '" << escape_text(text) << "';" unless text.empty?
            if indicator == '#'     # <%# %>
              src << ("\n" * code.count("\n"))
            else                       # <%= %>
              src << " _buf << (" << code << ").to_s;"
            end
          end
        end

        if append_rest
          rest = pos == 0 ? node : node[pos..-1]
          src << " _buf << '" << escape_text(rest) << "';""</#{open[1, close.length]}>"
        else
          rest = pos == 0 ? node : node[pos..-1]
        end
      end
      src << "\n_buf.to_s\n"
    end


    def convert_old template
      src = "_buf = '';"
      template.each do |line|
        pos = 0
        append_rest = true
        line.scan(EMBEDDED_PATTERN) do |indicator, code|
          m = Regexp.last_match
          text = line[pos...m.begin(0)]
          pos  = m.end(0)
          if !indicator              # <% %>
            src << escape_code(code) << ";"
            append_rest = false
            break
          else
            src << " _buf << '" << escape_text(text) << "';" unless text.empty?
            if indicator == '#'     # <%# %>
              src << ("\n" * code.count("\n"))
            else                       # <%= %>
              src << " _buf << (" << code << ").to_s;"
            end
          end
        end

        if append_rest
          rest = pos == 0 ? line : line[pos..-1]
          src << " _buf << '" << escape_text(rest) << "';"
        else
          rest = pos == 0 ? line : line[pos..-1]
        end
      end
      src << "\n_buf.to_s\n"
    end


  end
end
