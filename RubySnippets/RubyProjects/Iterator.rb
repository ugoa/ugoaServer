class Array
    def find
        for item in self
            return item if yield(item)
        end
        return nil
    end
end

puts [1, 3, 5, 7, 9].find { |i| i * i > 30 }

