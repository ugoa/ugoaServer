class Holder
    CONST = 100
    def call_block
        a = 101
        @a = 102
        @@a = 103
        yield
    end
end

class Creator
    CONST = 0
    def call_block
        a = 1
        @a = 2
        @@a = 3
        proc do
            puts "a = #{a}"
            puts "@a = #@a"
            puts "@@a = #@@a"
            puts yield
        end
    end
end

block = Creator.new.call_block { "original" }
puts Holder.new.call_block(&block)
