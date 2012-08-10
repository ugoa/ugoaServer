#def replace(array, from , to)
#    array.each_with_index do |e, i|
#        array[i] = to if e == from
#    end
#end
#
#def test_replace
#    topics = %w[html java css]
#    print replace(topics, 'java', 'ruby')
#    puts
#end
#
#test_replace

#version 2

class Array
    def replace(from , to)
        each_with_index do |e, i|
            self[i] = to if e == from
        end
    end
end

def test_replace
    topics = %w[html java css]
    print topics.replace('java', 'ruby')
    puts
end

test_replace
