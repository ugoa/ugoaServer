require 'net/http'

pages = %w{ www.rubycentral.com slashdot.org www.google.com}
threads = []

for page_to_fatch in pages
  threads << Thread.new(page_to_fatch) do |url|
    h = Net::HTTP.new(url, 80)
    puts "Fetching: #{url}" 
    resp = h.get('/', nil)
    puts "Got #{url}: #{resp.message}"
  end
end

puts threads.each {|thr| thr.join}
