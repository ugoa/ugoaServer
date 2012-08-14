my_var = "Sueccess"

MyClass = Class.new do
	puts "#{my_var} in the class difinition!"
	define_method :my_method do
	 	puts "#{my_var} in the method!"
	end
end

MyClass.new.my_method