require "ruport"

table = Ruport::Data::Table.new :column_names => ["country", "wine"],
    	                          :data => [['France', 'Bordeaux'],
                                          ['Italy', 'Chianti'],
                                          ['France', 'Chabiles']]
puts table.to_text
found = table.rows_with_country('France')
found.each { |row| puts row.to_csv }


