require 'zip/zip'
require 'fileutils'

module Serenity
  class Template
    attr_accessor :template

    def initialize(template, output)
      FileUtils.cp(template, output)
      @template = output
    end

    def process context
      tmpfiles = []
      Zip::ZipFile.open(@template) do |zipfile|
        %w(content.xml styles.xml).each do |xml_file|
          content = zipfile.read(xml_file)
          odteruby = OdtEruby.new(XmlReader.new(content))
          out = odteruby.evaluate(context)

          tmpfiles << (file = Tempfile.new("serenity"))
          file << out
          file.close

          zipfile.replace(xml_file, file.path)
        end
      end
    end
  end
end
