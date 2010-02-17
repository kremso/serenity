module Serenity
  Spec::Matchers.define :be_a_document do
    match do |actual|
      File.exists? actual
    end

    failure_message_for_should do |actual|
      "expected that a file #{actual} would exist"
    end

    failure_message_for_should_not do |actual|
      "expected that a file #{actual} would not exist"
    end

  end
end
