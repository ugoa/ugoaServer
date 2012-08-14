class Roulette
  def method_missing(method, *args)
    person = method.to_s.capitalize
    number = 0
    3.times do
      number = rand(10) + 1
      puts "#{number}..."
    end
    "#{person} gots a #{number}"
  end
end
