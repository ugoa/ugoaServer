#require 'net/http'
#h = Net::HTTP.new('www.pragmaticprogrammer.com', 80)
#response = h.get('/index.html',nil)
#puts response
#if response.message == "OK"
#  puts response.body.scan(/<img src=*(.*?)*/m).uniq
#end

require 'open-uri'
#open('http://localhost/rhombus') do |f|
#  puts f.read.scan(/<IMG src="(.*?)"/m).uniq
#end

open('http://aww402-604/rhombus') do |f|
  puts f.read.scan(/<IMG src="(.*?)"/m).uniq
end
