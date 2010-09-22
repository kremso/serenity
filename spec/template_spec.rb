require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fileutils'

module Serenity

  describe Template do

    after(:each) do
      FileUtils.rm(Dir['*.odt'])
    end

    it "should process a document with simple variable substitution" do
      @name = 'Malcolm Reynolds'
      @title = 'captain'

      template = Template.new(fixture('variables.odt'), 'output_variables.odt')
      lambda {template.process binding}.should_not raise_error
    end

    it "should unroll a simple for loop" do
      @crew = %w{'River', 'Jayne', 'Wash'}

      template = Template.new(fixture('loop.odt'), 'output_loop.odt')
      lambda {template.process binding}.should_not raise_error
    end

    it "should unroll an advanced loop with tables" do
      @ships = [Ship.new('Firefly', 'transport'), Ship.new('Colonial', 'battle')]

      template = Template.new(fixture('loop_table.odt'), 'output_loop_table.odt')
      lambda {template.process binding}.should_not raise_error
    end

    it "should process an advanced document" do
      @persons = [Person.new('Malcolm', 'captain'), Person.new('River', 'psychic'), Person.new('Jay', 'gunslinger')]

      template = Template.new(fixture('advanced.odt'), 'output_advanced.odt')
      lambda {template.process binding}.should_not raise_error
    end

    it "should loop and generate table rows" do
      @ships = [Ship.new('Firefly', 'transport'), Ship.new('Colonial', 'battle')]

      template = Template.new(fixture('table_rows.odt'), 'output_table_rows.odt')
      lambda {template.process binding}.should_not raise_error
    end

    it "should parse the header" do
      @title = 'captain'

      template = Template.new(fixture('header.odt'), 'output_header.odt')
      template.process(binding)
      'output_header.odt'.should contain_in('styles.xml', 'captain')
    end
  end
end
