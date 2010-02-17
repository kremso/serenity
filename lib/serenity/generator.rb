require  'ruby-debug'

module Serenity
  module Generator
    def render_odt template_path, output_path = output_name(template_path)

      local_variables = {}
      instance_variables.each { |name| local_variables[name] = instance_variable_get(name) }

      locals = instance_variables.map { |name| "#{ival_name_to_local(name)} = local_variables['#{name}'];" }.join
      eval locals

      template = Template.new template_path, output_path
      template.process binding
    end

    private

    def ival_name_to_local ival_name
      ival_name[1, ival_name.length]
    end

    def output_name input
      if input =~ /(.+)\.odt\Z/
        "#{$1}_output.odt"
      else
        "#{input}_output.odt"
      end
    end
  end
end
