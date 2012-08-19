require "erb"

erb = ERB.new(File.read('template.html'))
erb.run
