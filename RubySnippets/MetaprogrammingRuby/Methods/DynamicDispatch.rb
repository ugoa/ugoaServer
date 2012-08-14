load 'Datasource.rb'

class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @datasource = data_source
  end

  def mouse
    component :mouse
  end

  def cpu
    component :cpu
  end

  def keyboard
    component :keyboard
  end

  def component(name)
    info = @datasource.send "get_#{name}_info", @id
    price = @datasource.send "get_#{name}_price", @id
    result = "#{name.to_s.capitalize}: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
end

