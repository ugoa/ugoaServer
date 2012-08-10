class VowelFinder
    include Enumerable

    def initialize(string)
        @string = string
    end

    def each
        @string.scan(/[aeiou]/) do |vowel|
            yield vowel
        end
    end
end

vf = VowelFinder.new("the quick brown fox jumped")
puts vf.inject{|v, n| v + n}

module Summable
    def sum
        inject {|v, n| v + n}
    end
end

class Array
    include Summable
end

class Range
    include Summable
end

class VowelFinder
    include Summable
end

puts [6, 7, 8, 9].sum
puts ('a'...'m').sum
