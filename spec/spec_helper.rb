$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rubygems'
require 'serenity'

Ship = Struct.new(:name, :type)
Person = Struct.new(:name, :skill)

def fixture name
  File.join(File.dirname(__FILE__), '..', 'fixtures', name)
end
