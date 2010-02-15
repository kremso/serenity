module Serenity
  module Debug
    def debug?
      true
    end

    def debug_dir
      File.join(File.dirname(__FILE__), '..', '..', 'debug')
    end
  end
end
