class BrokenAmplifier
    attr_accessor :left_channel, :right_channel
    def volume=(vol)
        #we don't put self for the left_channel so ruby see
        #it as a local variable rather than a method to an
        #attribute writer
        left_channel = self.right_channel = vol
    end
end

ba = BrokenAmplifier.new
ba.left_channel = ba.right_channel = 99
ba.volume = 5
puts ba.left_channel 
puts ba.right_channel 
