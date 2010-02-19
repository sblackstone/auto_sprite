spec = Gem::Specification.new do |s|

require 'fileutils'
  s.name = "auto_sprite"
  s.version = "1.1.0"
  s.author = "Stephen Blackstone"
  s.email = "sblackstone@gmail.com"
  s.homepage = "http://fargle.org/auto_sprite"
  s.platform = Gem::Platform::RUBY
  s.summary = "A fully-Automagic Sprite Builder"
  s.description = "CSS Sprites can get you down, don't let them.  This gem automatically creates the CSS, Sprite and HTML tags so you don't have to"
  s.files = ["./README.rdoc", "./auto_sprite.gemspec", "./MIT-LICENSE", "./rails", "./rails/init.rb", "./lib", "./lib/auto_sprite.rb"]
  s.require_path = "lib"
  s.has_rdoc = false
end

