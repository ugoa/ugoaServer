def unescapeHTML(string)
    str = string.dup
    str.gsub!(/&(.*?);/n) { #the ? mark here means this is a  non-greedy match :-)
        match = $1.dup
        case match
        when /\Aamp\z/ni            then '&'
        when /\Aquot\z/ni           then '"'
        when /\Agt\z/ni             then '>'
        when /\Alt\z/ni             then '<'
        when /\A#(\d+)\z/n          then Integer($1).chr
        when /\A#x([0-9a-f]+)\z/ni  then $1.hex.chr
        end
    }
    str
end
puts unescapeHTML("1&lt;2 &amp;&amp; 4 &gt; 3")
puts unescapeHTML("&quot;A&quot; = &#65; = &#x41;")

class TaxCalculator
    def initialize(name, &block)
        @name, @block = name, block
    end
    def get_tax(amount)
        print @block.class
        " #@name on #{amount} = #{ @block.call(amount)}"
    end
end

tc = TaxCalculator.new("Sales tax") {|amt| amt * 0.075}

puts tc.get_tax(100)
puts tc.get_tax(250)

alias old_backquote `
def `(cmd)
    result = old_backquote(cmd)
    if $? != 0
        fail  "Command #{cmd} failed : #$?"
    end
    result
end

print `date`
print `data`
