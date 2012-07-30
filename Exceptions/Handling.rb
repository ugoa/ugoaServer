begin
    string = 32
    eval string
rescue SyntaxError, NameError => boom
    puts "String doesn't compilr: " + boom.to_s
rescue StandardError => bang
    puts "Error running script, you idoit: " + bang.to_s
end
