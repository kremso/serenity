module Serenity
  class OdtEruby

    EMBEDDED_PATTERN = /\{%(=+|\#)?(.*?)-?%\}/m

    def initialize template, debug = false
      @src = convert template
      if debug
        File.open('serenity_debug.rb', 'a') do |f|
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

    def escape_text text
      text.gsub(/['\\]/, '\\\\\&')
    end

    def escape_code code
      code.gsub('&apos;', "'")
    end

  end
end
