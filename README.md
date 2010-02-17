Serenity is an embedded ruby for OpenOffice documents (.odt files). You provide an .odt template with ruby code inside a special markup and the data and Serenity generates the document. If you know erb all of this should sound familiar.

Serenity is best demonstrated with a picture. The first picture shows the template with the ruby code, next image shows the generated document. The template, output and the sample script can be found in the showcase directory.

![Serenity template](http://github.com/kremso/serenity/blob/master/showcase/imgs/serenity_template.png?raw=true)

![Generated document](http://github.com/kremso/serenity/blob/master/showcase/imgs/serenity_output.png?raw=true)

Installation
============

    gem install serenity-odt

Yeah, serenity is already taken on gemcutter.

Creating templates
===================

Templates are created directly in OpenOffice. Ruby code is enclosed in special markup:
* `{%= %}` is for ruby code which should be output to the final document. `to_s` is applied to anything found inside this markup
* `{% %}` is for everything else &mdash; loops, ifs, ends and any other non-outputting code

Any special formatting should by applied directly on the markup. E.g. if you need to ouput the value of variable title in bold font, write `{%= title %}`, select in in OpenOffice and make it bold. See the showcase.odt for more examples.

Generating documents
====================

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

The key parts are `include Serenity::Generator` and render_odt. The data for the template must be provided as instance variables.

Contact
=======

kramar[dot]tomas[at]gmail.com &mdash; I love the attention

