$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'serenity'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

Ship = Struct.new(:name, :type)
Person = Struct.new(:name, :skill, :col1, :col2, :col3)

def fixture(name)
  File.join(File.dirname(__FILE__), '..', 'fixtures', name)
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
