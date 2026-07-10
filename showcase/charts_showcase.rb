#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'serenity'

# Charts showcase.
#
# charts_showcase.odt embeds a chart inside a {% for person in @persons %} loop.
# Serenity (>= 0.3.0) duplicates that chart once per iteration, so every crew
# member ends up with their own chart filled with their own col1/col2/col3
# values. Run this script and open charts_showcase_output.odt to see one chart
# per person.
class ChartsShowcase
  include Serenity::Generator

  # name, skill and three numeric columns that feed the embedded chart
  Person = Struct.new(:name, :skill, :col1, :col2, :col3)

  def generate_showcase
    @title = 'Serenity crew stats'

    @persons = [
      Person.new('Malcolm Reynolds', 'captain',    10.5, 20.3, 30.1),
      Person.new('River Tam',        'psychic',    40.2, 50.7, 60.4),
      Person.new('Jayne Cobb',       'gunslinger', 70.8, 80.9, 90.6)
    ]

    render_odt File.join(__dir__, 'charts_showcase.odt')
  end
end

ChartsShowcase.new.generate_showcase
