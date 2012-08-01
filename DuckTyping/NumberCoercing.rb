# For git branch test
# v2 again fo git branch test
# V3 use verbose comments when  git commit
class Roman
  MAX_ROMAN = 4999

  attr_reader :value
  protected :value
  def initialize(value)
    if value <=  0 or value > MAX_ROMAN
      fail "Roman must be > 0 and < #{MAX_ROMAN}"
    end
    @value = value
  end

  def coerce(other)
    if Integer === other
      [other, @value]
    else
      [Float(other), Float(@value)]
    end
  end

  def +(other)
    if Roman === other
      other = other.value
    end
    if Fixnum === other and (other + @value) < MAX_ROMAN 
      Roman.new(@value + other)
    else
      x, y = other.coerce(@value)
      x + y
    end
  end

  FACTORS = [["m", 1000], ["cm", 900], ["d", 500], ["cd", 400],
            ["c", 100], ["xc", 90], ["l", 50], ["xl", 40], 
            ["x", 10], ["ix", 9], ["ix", 9], ["v", 5], ["iv", 4],["i", 1]]

  def to_s
    value = @value
    roman = ""

    for code, factor in FACTORS
      count, value = value.divmod(factor)
      roman << (code * count)
    end
    roman
  end
end
