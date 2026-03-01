# encoding: utf-8

require "zip"

module Serenity
  RSpec::Matchers.define :contain_in do |xml_file, expected|
    match do |actual|
      content = Zip::File.open(actual) { |zip_file| zip_file.read(xml_file) }
      content.force_encoding("UTF-8")
      content =~ Regexp.new(".*#{Regexp.escape(expected)}.*")
    end

    failure_message do |actual|
      "expected #{actual} to contain the text #{expected}"
    end

    failure_message_when_negated do |actual|
      "expected #{actual} to not contain the text #{expected}"
    end
  end
end
