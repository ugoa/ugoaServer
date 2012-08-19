require "test/unit"

class Person; end

class TestCheckedAttributes < Test::Unit::TestCase
  def setup
    add_checked_attributes(Person, :age) { |v| v >= 18 }
    @bob = Person.new
  end

  def test_accept_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_rufuses_invaild_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = 17
    end
  end

#   def add_checked_attributes(clazz, attribute)
#     eval <<B
# class #{clazz}
#   def #{attribute}=(value)
#     raise 'Invalid attribute' unless value
#     @#{attribute} = value
#   end

#   def #{attribute}()
#     @#{attribute}
#   end
# end
# B
#   end

# another way to generate reader and writer method
  def add_checked_attributes(clazz, attribute, &validation)
    clazz.class_eval do
      define_method "#{attribute}=" do |value|
        raise 'Invalid attribute' unless yield(value)
        instance_variable_set("@#{attribute}", value)
      end

      define_method attribute do
        instance_variable_get "@#{attribute}"
      end
    end
  end
end
