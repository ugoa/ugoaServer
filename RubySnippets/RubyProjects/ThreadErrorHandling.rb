Thread.abort_on_exception = true

threads = []
4.times do |number|
    threads << Thread.new(number) do |i|
        raise "Boom! " if i == 2
        print "#{i}\n"
    end
end

threads.each { |t| t.join }

#threads.each do |t|
#    begin
#        t.join
#    rescue RuntimeError => ex
#        puts "Save yourself......#{ex.message}"
#    end
#end
#
