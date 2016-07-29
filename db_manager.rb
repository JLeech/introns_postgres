require 'pg'

# manage bulk loading and all db requests
class DbManager

  attr_accessor :connection
  attr_accessor :sequences_chunk
  attr_accessor :genes_chunk

  def initialize(db_name, user_name)
    self.connection = PG.connect :dbname => db_name, :user => user_name
    self.sequences_chunk = []
    self.genes_chunk = []
  end

  def fill_empty_fields
    
  end



end