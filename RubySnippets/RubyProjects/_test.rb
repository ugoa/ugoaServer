module Temp
    def Temp.var
        4
    end
end

File.open("_test.rb") do |file|
    while line = file.gets
        line.each_byte { |ch| putc ch }
    end
end
