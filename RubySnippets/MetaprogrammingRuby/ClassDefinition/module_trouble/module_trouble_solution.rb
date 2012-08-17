module MyModule
  def module_method
    'Hello.'
  end
end

class MyClass
  # class << self
  #   include MyModule
  # end
  # or another way
  extend MyModule
end

# puts MyClass.module_method

# class MyClass
#   alias :mm :module_method
# end

puts MyClass.instance_methods
