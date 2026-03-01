require 'zip'
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
      Zip::File.open(@template) do |zipfile|
        %w(content.xml styles.xml).each do |xml_file|
          content = zipfile.read(xml_file)

          # Images replacement
          images_replacements = ImagesProcessor.new(content, context).generate_replacements
          images_replacements.each do |r|
            zipfile.replace(r.first, r.last)
          end

          odteruby = OdtEruby.new(XmlReader.new(content))
          out = odteruby.evaluate(context)
          out.force_encoding Encoding.default_external

          tmpfiles << (file = Tempfile.new("serenity"))
          file << out
          file.close

          zipfile.replace(xml_file, file.path)
        end
      end
    end
  end
end
