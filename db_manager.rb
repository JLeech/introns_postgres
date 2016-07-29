require 'pg'

# manage bulk loading and all db requests
class DbManager

  attr_accessor :connection

  def initialize(db_name, user_name)
    self.connection = PG.connect :dbname => db_name, :user => user_name
  end



end