load "Datasource.rb"

class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @datasource = data_source
  end

  def method_missing(method, *args)
    super if !@datasource.respond_to?("get_#{method}_info")
    info = @datasource.send("get_#{method}_info", args[0])
    price = @datasource.send("get_#{method}_price", args[0])
    result = "#{method.to_s.capitalize}: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end

  def respond_to?(method)
    @datasource.respond_to?("get_#{method}_info") || super
  end

  instance_methods.each do |m|
    undef_method m unless m.to_s =~ /^__|method_missing|respond_to?|object_id|inspect/
  end
end
