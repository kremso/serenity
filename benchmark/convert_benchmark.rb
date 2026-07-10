# Micro-benchmark for Serenity::OdtEruby scaling.
#
# Builds synthetic ODT content of increasing node counts (no {% %} markers, to isolate the
# compile step) and reports how convert() and evaluate() scale with the number of nodes.
#
#   ruby benchmark/convert_benchmark.rb
#
# Read the "convert us/node" column: if it stays roughly constant, convert() is linear; if it
# grows with the node count, convert() is quadratic (which it was before switching the per-node
# `buffer << arr; buffer.flatten!` to `buffer.concat(arr)`).

# Only the template-compilation pipeline is needed here (not the ODT zip I/O in template.rb),
# so those files are required directly. This also sidesteps serenity.rb's `require 'zip/zip'`,
# which is incompatible with rubyzip >= 1.0.
lib = File.expand_path('../../lib', __FILE__)
%w[node_type escape_xml line debug xml_reader odteruby].each { |f| require File.join(lib, 'serenity', f) }
require 'benchmark'

STDOUT.sync = true

def build_template(n)
  s = String.new
  s << '<office:document-content><office:body><office:text>'
  n.times do |i|
    s << %Q{<text:p text:style-name="P#{i}"><text:span text:style-name="T#{i}">line #{i}</text:span></text:p>}
  end
  s << '</office:text></office:body></office:document-content>'
  s
end

context = binding

puts format('%-9s %-13s %-12s %-16s', 'nodes', 'convert(s)', 'eval(s)', 'convert us/node')
[250, 500, 1000, 2000].each do |n|
  template = build_template(n)

  nodes = 0
  Serenity::XmlReader.new(template.dup).each_node { |_node, _type| nodes += 1 }

  eruby = nil
  t_convert = Benchmark.realtime { eruby = Serenity::OdtEruby.new(Serenity::XmlReader.new(template.dup)) }
  t_eval    = Benchmark.realtime { eruby.evaluate(context) }

  puts format('%-9d %-13.3f %-12.3f %-16.2f', nodes, t_convert, t_eval, t_convert / nodes * 1_000_000)
end
