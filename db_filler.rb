require 'pg'
require_relative 'bio_parser'
require_relative 'organism_parser'
class Dbfiller

  attr_accessor :organism_path
  attr_accessor :connection

  def initialize (organism_path, db_name, user_name)
    self.organism_path = organism_path
    self.connection = PG.connect :dbname => db_name, :user => user_name
  end

  def load_organism
    bio_parser = BioParser.new(organism_path,connection)
    additional_organism_data = bio_parser.parse
    gbk_parser = OrganismParser.new(organism_path, additional_organism_data, connection)
    gbk_parser.parse
  end


end

organism_path = "/home/eve/Документы/biology/load_data/Anolis_carolinensis"
#organism_path = "/home/eve/Документы/biology/load_data/Gorilla_gorilla"
db_filler = Dbfiller.new(organism_path, "mydb", "eve")
db_filler.load_organism