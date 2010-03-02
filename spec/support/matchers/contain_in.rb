require "zip/zip"

module Serenity
  Spec::Matchers.define :contain_in do |xml_file, expected|

    match do |actual|
      content = Zip::ZipFile.open(actual) { |zip_file| zip_file.read(xml_file) }
      content =~ Regexp.new(".*#{Regexp.escape(expected)}.*")
    end

    failure_message_for_should do |actual|
      "expected #{actual} to contain the text #{expected}"
    end

    failure_message_for_should_not do |actual|
      "expected #{actual} to not contain the text #{expected}"
    end

  end
end
