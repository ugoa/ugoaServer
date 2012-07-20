require 'test/unit'

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

class Logger
    private_class_method :new
    @@logger = nil
    def self.create
        @@logger = new unless @@logger
        @@logger
    end
end

#class TestSongList < Test::Unit::TestCase
#    def testDelete
#        list = SongList.new
#        s1 = Song.new('title1', 'artist1', 1)
#        s2 = Song.new('title2', 'artist2', 2)
#        s3 = Song.new('title3', 'artist3', 3)
#        s4 = Song.new('title4', 'artist4', 4)
#
#        list.append(s1).append(s2).append(s3).append(s4)
#
#        assert_equal(s1, list[0])
#        assert_equal(s3, list[2])
##        assert_equal(s2, list[2])
#        assert_nil(list[9])
#
#        assert_equal(s1, list.deleteFirst)
#        assert_equal(s2, list.deleteFirst)
#        assert_equal(s3, list.deleteFirst)
#        assert_equal(s4, list.deleteFirst)
#        assert_nil(list.deleteLast)
#    end
#end
#s1 = Song.new("Song1", "Artist1", 234)
#s2 = Song.new("Song2", "Artist2", 236)
#
#s1.PlaySong	
#s2.PlaySong	
#
#puts s1.duration
#
#s1.PlaySong	
#s2.duration = 278
#puts s2.duration
#
#SongList.IsTooLong(s2)
#
#puts Logger.create.object_id
#puts Logger.create.object_id
#
#person1 = "David"
#person1.freeze
#person2 = person1.dup
#person1[0] = "J"
#
#puts person1
#puts person2
#def three_times
#    yield
#    yield
#    yield
#end
#
#def fibonacci_up_to(max)
#    i1, i2 = 1, 1
#    while i1 <= max
#        yield i1
##        i1, i2 = i2, i1 + i2 
#        temp = i1
#        i1 = i2
#        i2 = temp + i2
#    end
#end
#fibonacci_up_to(1000) {|f| print f, " "}
#three_times {puts "Hello"}
