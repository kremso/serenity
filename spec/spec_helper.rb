$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rubygems'
require 'serenity'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

Ship = Struct.new(:name, :type)
Person = Struct.new(:name, :skill)

def fixture name
  File.join(File.dirname(__FILE__), '..', 'fixtures', name)
end
