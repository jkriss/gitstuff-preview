begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gitstuff-preview"
    gem.summary = %Q{Handy gem for previewing Gitstuff sites.}
    gem.description = %Q{gitstuff-preview runs a local web server with template processing similar to gitstuff.com}
    gem.email = "jesse@jklabs.net"
    gem.homepage = "http://github.com/jkriss/gitstuff-preview"
    gem.authors = ["Jesse Kriss"]
    %w(sinatra rdiscount liquid hashie).each do |lib|
      gem.add_dependency lib
    end
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install   jeweler"
end