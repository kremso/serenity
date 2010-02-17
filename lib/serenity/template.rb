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
      Zip::ZipFile.open(@template) do |zipfile|
        content = zipfile.read('content.xml')
        odteruby = OdtEruby.new(XmlReader.new(content))
        out = odteruby.evaluate context

        file = Tempfile.new("serenity")
        file << out
        file.close

        zipfile.replace('content.xml', file.path)
      end
    end
  end
end
