require 'test_helper'

module Serenity
  class TemplateTest < Test::Unit::TestCase

    context "a template" do
=begin
      should "replace simple variable in odt file" do
        name = 'Malcolm Reynolds'
        title = 'captain'

        template = Template.new '../fixtures/variables.odt', 'output.odt'
        template.process binding
      end

=end
      should "unroll a simple for loop" do
        crew = %w{'River', 'Jay', 'Wash'}

        template = Template.new '../fixtures/loop.odt', 'output_loop.odt'
        template.process binding
      end
    end
  end
end
