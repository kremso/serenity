Serenity is an embedded ruby for OpenOffice documents (.odt files). You provide an .odt template with ruby code inside a special markup and the data and Serenity generates the document. If you know erb all of this should sound familiar.

Important Changes
=================

As of version 0.2.0 serenity is using instance variables in the templates. In previous versions, your instance variables would be converted to local before passing to the template, so while in the code you had `@title = 'Serenity'`, you had to put `{%= title }` in the template to get serenity to work. This has now changed and you need to use instance variables in the templates: `{%= @title }`. Honestly, I don't know why I did it this way in the first place, considering that people are used to instance variables in templates from rails.

Usage
======

Serenity is best demonstrated with an example. The first picture shows the template with the ruby code, next image shows the generated document. The template, output and the sample script can be found in the showcase directory.

![Serenity template](http://github.com/kremso/serenity/blob/master/showcase/imgs/serenity_template.png?raw=true)

The image above is a screenshot of showcase.odt from the [showcase](http://github.com/kremso/serenity/blob/master/showcase) directory. It's a regular OpenOffice document with ruby code embedded inside a special markup. That ruby code drives the document creation. You can use conditionals, loops, blocks &mdash; in fact, the whole ruby language and you can apply any OpenOffice formatting to the outputted variables or static text.

The second line in the template is `{%= @title%}` what means: output the value of variable title. It's bold and big, in fact, it's has the 'Heading 1' style applied. That variable will be replaced in the generated document, but it will still be a 'Heading 1'.

You can now take that template, provide the data and generate the final document:

    require 'rubygems'
    require 'serenity'

    class Showcase
      include Serenity::Generator

      Person = Struct.new(:name, :items)
      Item = Struct.new(:name, :usage)

      def generate_showcase
        @title = 'Serenity inventory'

        mals_items = [Item.new('Moses Brothers Self-Defense Engine Frontier Model B', 'Lock and load')]
        mal = Person.new('Malcolm Reynolds', mals_items)

        jaynes_items = [Item.new('Vera', 'Callahan full-bore auto-lock with a customized trigger, double cartridge and thorough gauge'),
                        Item.new('Lux', 'Ratatata'),
                        Item.new('Knife', 'Cut-throat')]
        jayne = Person.new('Jayne Cobb', jaynes_items)

        @crew = [mal, jayne]

        render_odt 'showcase.odt'
      end
    end

The key parts are `include Serenity::Generator` and `render_odt`. The data for the template must be provided as instance variables.

Following picture shows the generated document. It's a screenshot of the showcase_output.odt document from the [showcase](http://github.com/kremso/serenity/blob/master/showcase) directory.

![Generated document](http://github.com/kremso/serenity/blob/master/showcase/imgs/serenity_output.png?raw=true)

Installation
============

    gem install serenity-odt

Yeah, serenity is already taken on gemcutter.

Creating templates
===================

Templates are created directly in OpenOffice. Ruby code is enclosed in special markup:

+ `{%= %}` is for ruby code which should be output to the final document. `to_s` is applied to anything found inside this markup
+ `{% %}` is for everything else &mdash; loops, ifs, ends and any other non-outputting code

Any special formatting should by applied directly on the markup. E.g. if you need to ouput the value of variable title in bold font, write `{%= title %}`, select in in OpenOffice and make it bold. See the showcase.odt for more examples.

Contact
=======

kramar[dot]tomas[at]gmail.com

