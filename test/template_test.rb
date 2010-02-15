require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'fileutils'

module Serenity
  class TemplateTest < Test::Unit::TestCase

    def teardown
      FileUtils.rm(Dir['*.odt'])
    end

    context "a template" do
      should "replace simple variable in odt file" do
        name = 'Malcolm Reynolds'
        title = 'captain'

        assert_nothing_raised do
          template = Template.new(fixture('variables.odt'), 'output_variables.odt')
          template.process binding
        end
      end

      should "unroll a simple for loop" do
        crew = %w{'River', 'Jay', 'Wash'}

        assert_nothing_raised do
          template = Template.new(fixture('loop.odt'), 'output_loop.odt')
          template.process binding
        end
      end

      should "unroll an advanced loop with tables" do
        ships = [Ship.new('Firefly', 'transport'), Ship.new('Colonial', 'battle')]

        assert_nothing_raised do
          template = Template.new(fixture('loop_table.odt'), 'output_loop_table.odt')
          template.process binding
        end
      end

      should "process an advanced document" do
        persons = [Person.new('Malcolm', 'captain'), Person.new('River', 'psychic'), Person.new('Jay', 'gunslinger')]

        assert_nothing_raised do
          template = Template.new(fixture('advanced.odt'), 'output_advanced.odt')
          template.process binding
        end
      end
    end
  end
end
