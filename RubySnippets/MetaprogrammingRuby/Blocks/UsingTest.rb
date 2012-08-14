require 'using'
require 'test/unit'
class TestUsing < Test::Unit::TestCase
	class Resource
		@disposed = true
	end

	def disposed?
		@disposed
	end

	def test_dispose_of_resources
		r = Resource.new
		using(r) {}
		assert r.disposed?
	end

	def test_dispose_of_resource_in_case_of_exception
		r = Resource.new
		assert_raises(Exception) do
			using(r) {raise Exception}
		end
	end
end
