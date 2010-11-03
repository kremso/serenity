require 'rake'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

task :default => [:spec]

Spec::Rake::SpecTask.new("spec")

spec = Gem::Specification.new do |s|
  s.name = %q{serenity-odt}
  s.version = "0.2.1"

  s.authors = ["Tomas Kramar"]
  s.description = <<-EOF
    Embedded ruby for OpenOffice Text Document (.odt) files. You provide an .odt template
    with ruby code in a special markup and the data, and Serenity generates the document.
    Very similar to .erb files.
  EOF
  s.email = %q{kramar.tomas@gmail.com}
  s.files = Dir.glob('lib/**/*.rb') + %w{README.md Rakefile LICENSE}
  s.has_rdoc = false
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Embedded ruby for OpenOffice Text Document (.odt) files}
  s.test_files = Dir.glob('spec/**/*.rb') + Dir.glob('fixtures/*.odt')
  s.add_dependency('rubyzip', '>= 0.9.1')
  s.add_development_dependency('rspec', '>= 1.2.9')
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end
