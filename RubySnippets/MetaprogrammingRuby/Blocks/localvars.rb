def my_method
  yield(2)  
end

x = 1
my_method do |x| end
puts x
