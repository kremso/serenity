require 'rake'
require 'rake/testtask'

task :default => [:test_units]

Rake::TestTask.new("test_units") { |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = true
}
