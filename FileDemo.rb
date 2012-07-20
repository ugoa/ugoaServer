class File
    def File.open_and_process(*args)
        f = File.open(*args)
        yield f
        f.close()
    end

    def File.my_open(*args)
        result = file = File.new(*args)

        #If there is a block, pass in the file and close the file
        #when it returns.
        if block_given?
            result = yield file
            file.close
        end
        return result
    end
end

File.open_and_process("ArrayDemo.rb", "r") do |file|
    while line = file.gets
        puts line
    end
end

File.my_open("ArrayDemo.rb", "r") do |file|
    while line = file.gets
        puts line
    end
end
puts File.my_open("ArrayDemo.rb", "r")
