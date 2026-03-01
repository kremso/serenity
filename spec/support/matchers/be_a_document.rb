module Serenity
  RSpec::Matchers.define :be_a_document do
    match do |actual|
      File.exist? actual
    end

    failure_message do |actual|
      "expected that a file #{actual} would exist"
    end

    failure_message_when_negated do |actual|
      "expected that a file #{actual} would not exist"
    end
  end
end
