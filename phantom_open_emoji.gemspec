Gem::Specification.new do |s|
  s.name        = 'phantom_open_emoji'
  s.version     = '0.0.3'
  s.license     = "Source: MIT, Glyphs/Fonts: SIL, Images: CC-By 3.0"
  s.summary     = "Completely FOSS Emoji for everyone"
  s.description = "A completely free and open set of emoji that anybody can use in any project without a fee and without any restrictive conditions. Source at: https://github.com/Genshin/PhantomOpenEmoji"
  s.authors     = ["Rei Kagetsuki", "Jun Tohyama", "Rika Yoshida"]
  s.email       = 'info@genshin.org'
  s.files        = `git ls-files`.split("\n")
  s.homepage    = 'http://genshin.org'
  s.executables << 'poe-cli'

  s.add_dependency 'rsvg2'
end
