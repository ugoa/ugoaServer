class Loan
  def initialize(book)
    @book = book
    @time = Loan.time_class.now
  end

  def self.time_class
    @time_class || Time
  end

  def to_s
    "#{@book.upcase} loaned on #{@time}"
  end
end

class FakeTime
  def self.now
    'Mon Apr 12 12:15:40'
  end
end

require "test/unit"

class TestLoan < Test::Unit::TestCase
  # you need to add a 'test_' prefix if your ruby is older than 1.9.0
  # I learned this in a hard way.
  def conversion_to_string
    Loan.instance_eval { @time_class = FakeTime }
    loan = Loan.new('War and peace')

    assert_equal 'WAR AND PEACE loaned on Mon Apr 12 12:15:40', loan.to_s
  end
end
