puts
class_instance = Class.new
puts class_instance.class
puts class_instance.class.superclass
puts class_instance.superclass
puts
module_instance = Module.new
puts module_instance.class
puts module_instance.class.superclass
puts module_instance.class.class
#The following won't work.
#puts module_instance.superclass
