$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rubygems'
require 'shoulda'
require 'test/unit'
require 'serenity'

class SampleObject
  attr_accessor :name, :type

  def initialize name, type
    @name = name
    @type = type
  end
end

Ship = Struct.new(:name, :type)
Person = Struct.new(:name, :skill)

def load_from_file(file)
  content = ''
  File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', file), 'r') do |f|
    content = f.read
  end
  content
end
