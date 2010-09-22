require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Serenity
  describe Generator do
    after(:each) do
      FileUtils.rm(fixture('loop_output.odt'))
    end

    it 'should make context from instance variables and run the provided template' do
      class GeneratorClient
        include Serenity::Generator

        def generate_odt
          @crew = ['Mal', 'Inara', 'Wash', 'Zoe']

          render_odt fixture('loop.odt')
        end
      end

      client = GeneratorClient.new
      lambda { client.generate_odt }.should_not raise_error
      fixture('loop_output.odt').should be_a_document
    end
  end
end
