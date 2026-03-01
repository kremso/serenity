# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fileutils'

module Serenity
  describe Template do
    after(:each) do
    #  FileUtils.rm(Dir['*.odt'])
    end

    it "processes a document with simple variable substitution" do
      @name = 'Malcolm Reynolds'
      @title = 'captain'

      template = Template.new(fixture('variables.odt'), 'output_variables.odt')
      template.process binding

      expect('output_variables.odt').to contain_in('content.xml', 'Malcolm Reynolds')
      expect('output_variables.odt').to contain_in('content.xml', 'captain')
    end

    it "unrolls a simple for loop" do
      @crew = %w{'River', 'Jayne', 'Wash'}

      template = Template.new(fixture('loop.odt'), 'output_loop.odt')
      template.process binding
    end

    it "unrolls an advanced loop with tables" do
      @ships = [Ship.new('Firefly', 'transport'), Ship.new('Colonial', 'battle')]

      template = Template.new(fixture('loop_table.odt'), 'output_loop_table.odt')
      template.process binding

      ['Firefly', 'transport', 'Colonial', 'battle'].each do |text|
        expect('output_loop_table.odt').to contain_in('content.xml', text)
      end
    end

    it "processes an advanced document" do
      @persons = [Person.new('Malcolm', 'captain'), Person.new('River', 'psychic'), Person.new('Jay', 'gunslinger')]

      template = Template.new(fixture('advanced.odt'), 'output_advanced.odt')
      template.process binding

      ['Malcolm', 'captain', 'River', 'psychic', 'Jay', 'gunslinger'].each do |text|
        expect('output_advanced.odt').to contain_in('content.xml', text)
      end
    end

    it "processes a greek document" do
      @h = {'ελληνικο' => 'κειμενο'}
      template = Template.new(fixture('greek.odt'), 'output_greek.odt')
      template.process binding
      expect('output_greek.odt').to contain_in('content.xml', 'κειμενο')
    end

    it "loops and generates table rows" do
      @ships = [Ship.new('Firefly', 'transport'), Ship.new('Colonial', 'battle')]

      template = Template.new(fixture('table_rows.odt'), 'output_table_rows.odt')
      template.process binding

      ['Firefly', 'transport', 'Colonial', 'battle'].each do |text|
        expect('output_table_rows.odt').to contain_in('content.xml', text)
      end
    end

    it "parses the header" do
      @title = 'captain'

      template = Template.new(fixture('header.odt'), 'output_header.odt')
      template.process(binding)
      expect('output_header.odt').to contain_in('styles.xml', 'captain')
    end

    it 'parses the footer' do
      @title = 'captain'

      template = Template.new(fixture('footer.odt'), 'output_footer.odt')
      template.process(binding)
      expect('output_footer.odt').to contain_in('styles.xml', 'captain')
    end
  end
end
