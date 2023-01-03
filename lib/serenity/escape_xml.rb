class String
  def escape_xml
    mgsub!([[/&/, '&amp;'], [/</, '&lt;'], [/>/, '&gt;']])
  end

  def convert_newlines
    if not self.frozen?
      gsub!("\n", '<text:line-break/>')
    end
    self
  end

  def mgsub!(key_value_pairs=[].freeze)
    regexp_fragments = key_value_pairs.collect { |k,v| k }
    if not self.frozen?
      gsub!(Regexp.union(*regexp_fragments)) do |match|
        key_value_pairs.detect{|k,v| k =~ match}[1]
      end
    end
    self
  end
end
