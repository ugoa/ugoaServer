class Laywer
  def method_missing(method, *args)
    puts "You called: #{method}(#{args.join(', ')})"
    puts "You also pass it with a block." if block_given?
  end
end

