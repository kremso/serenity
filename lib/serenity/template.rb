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
        odteruby = OdtEruby.new(XmlReader.new(content), true)
        out = odteruby.evaluate context

        file = Tempfile.open("serenity_#{rand(1000000)}.xml") do |f|
          f << out
        end

        zipfile.replace('content.xml', file.path)
      end
    end
  end
end
