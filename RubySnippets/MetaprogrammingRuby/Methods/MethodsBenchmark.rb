class String
  def method_missing(method, *args)
    method == :ghosts_reverse ? reverse : super
  end
end

require "benchmark"

Benchmark.bm do |b|
  b.report 'Normal method' do
    1000000.times  { "abc".reverse }
  end
  b.report 'Ghost method' do
    1000000.times  { "abc".ghosts_reverse }
  end
end
