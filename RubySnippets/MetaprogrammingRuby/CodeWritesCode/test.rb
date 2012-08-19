module MyMixin
  def self.included(base)
    base.extend(self)
  end

#  module ClassMethods
#    def x
#      "x()"
#    end
#  end

  def y
    "y()"
  end
end

class MyClass
  include MyMixin
end

c = MyClass.new
puts c.methods.grep(/y/)
puts 
puts MyClass.methods.grep(/y/)


