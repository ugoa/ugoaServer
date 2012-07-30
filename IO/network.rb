#require 'socket'
#
#client = TCPSocket.open("127.0.0.1", 'finger')
#client.send("mysql\n", 0)
#puts client.readlines()
#client.close

require 'net/http'

h = Net::HTTP.new('www.pragmaticprogrammer.com', 80)
response = h.get('/index.html', nil)
if response.message == "OK"
  puts response.body.scan(/<img src="(.*?)"/m).uniq
end
