Gem::Specification.new do |s|
  s.name        = "serenity-odt"
  s.version     = "0.2.2"
  s.authors     = "kremso"
  s.email       = ""
  s.homepage    = "https://github.com/kremso/serenity"
  s.summary     = "Parse ODT file and substitutes placeholders like ERb."
  s.description = "Embedded ruby for OpenOffice/LibreOffice Text Document (.odt) files. You provide an .odt template with ruby code in a special markup and the data, and Serenity generates the document. Very similar to .erb files."

  s.required_ruby_version = ">= 3.0"
  s.files = Dir["{lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.add_dependency "rubyzip", ">= 2.0"
  s.add_dependency "nokogiri", ">= 1.10"
  s.add_development_dependency "rspec", "~> 3.0"
end
