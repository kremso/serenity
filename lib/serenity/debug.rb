module Serenity
  module Debug
    def debug?
      false
    end

    def debug_file_path
      File.join(debug_dir, debug_file_name)
    end

    def debug_file_name
      "serenity_debug_#{rand(100)}.rb"
    end

    def debug_dir
      File.join(File.dirname(__FILE__), '..', '..', 'debug')
    end
  end
end
