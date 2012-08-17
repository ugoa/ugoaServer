# -*- coding: utf-8 -*-
class C
  def a_method
    'C#a_method()'
  end
end

class C
  class << self
    def a_class_method
      'C.a_class_method'
    end
  end
end

class D < C
end

obj = D.new

# helper method to return the 独有类 of any objects.
class Object
  def get_eigenclass
    class << self
      self
    end
  end
end

class << obj
  def a_singleton_method
    'obj#a_singleton_method'
  end
end

# puts obj.get_eigenclass
# puts obj.get_eigenclass.superclass

puts C.get_eigenclass
puts D.get_eigenclass
puts C.get_eigenclass.superclass
puts D.get_eigenclass.superclass
