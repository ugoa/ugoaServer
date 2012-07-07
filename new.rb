class Song
	@@plays = 0
	def initialize(name, artist, duration)
		@name = name
		@artist = artist
		@duration = duration
		@plays = 0
	end

	def PlaySong
		@plays += 1
		@@plays += 1
		puts "THis song: #@plays times. Total #@@plays times."
	end
end

s1 = Song.new("Song1", "Artist1", 234)
s2 = Song.new("Song2", "Artist2", 236)

s1.PlaySong	
s2.PlaySong	
s1.PlaySong	
s1.PlaySong	


