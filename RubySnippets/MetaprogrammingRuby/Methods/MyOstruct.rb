class MyOstruct
  def initialize
    @attributes = {}
  end

  def method_missing(method, *args)
    attribute = method.to_s
    if attributes =~ /=$/
      @attributes[attribute.chop] = args[0]
    else
      @attributes[attribute]
    end
  end
end
