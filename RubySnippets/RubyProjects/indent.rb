class Song
    def duration_in_minutes
        @duration / 60
    end
end

song = Song.new(250)
puts song.duration_in_minutes
