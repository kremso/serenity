require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Serenity
  describe Generator do
    after(:each) do
      FileUtils.rm(fixture('loop_output.odt'))
    end

    it 'makes context from instance variables and runs the provided template' do
      class GeneratorClient
        include Serenity::Generator

        def generate_odt
          @crew = ['Mal', 'Inara', 'Wash', 'Zoe']

          render_odt fixture('loop.odt')
        end
      end

      client = GeneratorClient.new
      expect { client.generate_odt }.not_to raise_error
      expect(fixture('loop_output.odt')).to be_a_document
    end
  end
end
