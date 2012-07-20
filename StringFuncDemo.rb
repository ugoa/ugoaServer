class Song
	@@plays = 0

    attr_reader :name, :artist, :duration

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

    public
    def duration=(new_duration)
        @duration = new_duration
    end

    def to_s
    "Song: #@name--#@artist (#@duration)"
    end

end

class SongList
    MAX_TIME = 5 * 60

    def initialize
        @songs = Array.new
    end

    def append(song)
        @songs.push(song)
        self
    end

    def deleteFirst
        @songs.shift
    end

    def deleteLast
        @songs.pop
    end

    def [](index)
        @songs[index]
    end

    def withTitle(title)
        #for i in 0...@songs.length
        #    return @songs[i] if title == @songs[i].name
        #end
        #return nil
        @songs.find {|song| title == song.name }
    end
end

File.open("songLog") do |song_file|
    songs = SongList.new
    song_file.each do |line|
        file, length, name, title = line.chomp.split(/\s*\|\s*/)

        name.squeeze!(" ") if name != nil
        mins, secs = length.scan(/\d+/)
        len = mins.to_i * 60 + secs.to_i

        songs.append(Song.new(title, name, String(len) + ' \'s'))
    end
    puts songs[0]
end
