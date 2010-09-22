module Serenity
  module Generator
    def render_odt template_path, output_path = output_name(template_path)
      template = Template.new template_path, output_path
      template.process binding
    end

    private

    def output_name input
      if input =~ /(.+)\.odt\Z/
        "#{$1}_output.odt"
      else
        "#{input}_output.odt"
      end
    end
  end
end
