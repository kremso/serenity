#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

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

showcase = Showcase.new
showcase.generate_showcase
