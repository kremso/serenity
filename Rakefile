require 'rake'
require 'spec/rake/spectask'

task :default => [:spec]

Spec::Rake::SpecTask.new("spec")

spec = Gem::Specification.new do |s|
  s.name = %q{serenity}
  s.version = "1.0.0"

  s.authors = ["Tomas Kramar"]
  s.description = <<-EOF
    Embedded ruby for OpenOffice Text Document (.odt) files. You provide an .odt template
    with ruby code in a special markup and the data, and Serenity generates the document.
    Very similar to .erb files.
  EOF
  s.email = %q{kramar.tomas@gmail.com}
  s.files = Dir.glob('lib/**/*.rb') + %w{README.md Rakefile serenity.gemspec}
  s.has_rdoc = false
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Embedded ruby for OpenOffice Text Document (.odt) files}
  s.test_files = Dir.glob('spec/**/*.rb') + Dir.glob('fixtures/*.odt')
end

task :gemspec do
  File.open("serenity.gemspec", "w") { |f| f << spec.to_ruby }
end

task :gem => :gemspec do
  system "gem build serenity.gemspec"
end

