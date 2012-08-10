5.times do |i|
    File.open("_test.rb", "w") do |f|
        f.puts("module Temp")
        f.puts("    def Temp.var")
        f.puts("        #{i}")
        f.puts("    end")
        f.puts("end")
    end

    load "_test.rb"
    puts Temp.var
end
