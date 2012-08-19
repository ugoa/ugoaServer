require 'active_record'
ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "dbfile"

class Duck < ActiveRecord::Base
  validates_length_of :name, :maximum => 6
end

duck = Duck.new
duck.name = 'Donaldd'
duck.valid?
