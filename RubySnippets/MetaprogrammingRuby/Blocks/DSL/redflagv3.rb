class CleanRoom
  setups = []
  events = {}

  def setup(&block)
    setups << block
  end

  def event(name, &block)
    events[name] = block
  end

  def each_setup(&block)
    setups.each do |setup|
      block.call setup
    end
  end

  def each_event(&block)
    events.each_pair do |name, event|
      block.call name, event
    end
  end
end


Dir.glob('*events.rb').each do |file|
  clean_room = CleanRoom.new do 
    load file
  end
  clean_room.instance_eval do |name, event|
    each_event do |name, event|
      each.setup do |setup|
        clean_room.instance_eval &setup
      end
      puts "ALERT: #{name}" if clean_room.instance_eval &event
    end
  end
end
#  each_event do |name, event|
#    each_setup do |setup|
#      env.instance_eval &setup
#    end
#    puts "ALERT: #{name}" if env.instance_eval &event
#  end
#end
