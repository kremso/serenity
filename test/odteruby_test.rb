require File.expand_path(File.dirname(__FILE__) + '/test_helper')

module Serenity
  class OdtErubyTest < Test::Unit::TestCase

    def assert_template_and_result_match expected, actual
      assert_equal expected, actual
    end


    def get_binding
      name = 'test_name'
      type = 'test_type'
      rows = []
      rows << Ship.new('test_name_1', 'test_type_1')
      rows << Ship.new('test_name_2', 'test_type_2')
      binding
    end


    context 'a content' do
      setup do
        @context = get_binding
      end

      should 'replace variables with values from context' do
        template = <<-EOF
          <text:p text:style-name="Text_1_body">{%= name %}</text:p>
          <text:p text:style-name="Text_1_body">{%= type %}</text:p>
          <text:p text:style-name="Text_1_body"/>
        EOF

        expected = <<-EOF
          <text:p text:style-name="Text_1_body">test_name</text:p>
          <text:p text:style-name="Text_1_body">test_type</text:p>
          <text:p text:style-name="Text_1_body"/>
        EOF

        content = OdtEruby.new template
        result = content.evaluate @context

        assert_equal expected, result
      end

      should 'replace multiple variables on one line' do
        template = '<text:p text:style-name="Text_1_body">{%= type %} and {%= name %}</text:p>'
        expected = '<text:p text:style-name="Text_1_body">test_type and test_name</text:p>'

        content = OdtEruby.new template
        result = content.evaluate @context

        assert_equal expected, result
      end

      should 'replace a LOOP construct with variables' do
        template = <<-EOF
          <text:p text:style-name="Text_1_body">{% for row in rows do %}</text:p>
            <text:p text:style-name="Text_1_body">{%= row.name %}</text:p>
            <text:p text:style-name="Text_1_body">{%= row.type %}</text:p>
          <text:p text:style-name="Text_1_body">{% end %}</text:p>
        EOF

        expected = <<-EOF
            <text:p text:style-name="Text_1_body">test_name_1</text:p>
            <text:p text:style-name="Text_1_body">test_type_1</text:p>
            <text:p text:style-name="Text_1_body">test_name_2</text:p>
            <text:p text:style-name="Text_1_body">test_type_2</text:p>
        EOF

        content = OdtEruby.new template
        result = content.evaluate @context
        assert_equal expected, result
      end
    end
  end
end
