class Test
    def initialize()
    end
end

s = Test.new
print s.methods

class Test
    def to_the_world()
        puts 'I am apppended!'
    end
end
puts "\n\n"

print s.methods

puts "\n\n"
