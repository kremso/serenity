# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "serenity-odt"
  s.version     = "0.2.2"
  s.authors     = "kremso"
  s.email       = ""
  s.homepage    = "https://github.com/kremso/serenity"
  s.summary     = "Parse ODT file and substitutes placeholders like ERb."
  s.description = ""

  s.files = Dir["{lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
end
