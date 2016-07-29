require 'bio'
require_relative 'id_manager'
require_relative 'sequence_parser'

class OrganismParser

 TAXONOMY_LIST ="taxonomy_list"
 TAXONOMY_XREF = "taxonomy_xref"
 DB_XREF = "db_xref"

  attr_accessor :organism_path
  attr_accessor :organism_data
  attr_accessor :id_tax_groups2
  attr_accessor :connection
  attr_accessor :id_manager


  # TODO connection to DbManager
  # IdManager - to rule one-thread ids
  # use for one gbk file in butch load
  def initialize(organism_path, additional_organism_data, connection)
    self.organism_path = organism_path
    self.organism_data = additional_organism_data
    self.connection = connection
    self.id_manager = IdManager.new
  end

  def parse
    gbk_files = Dir["#{self.organism_path}/*"]
    gbk_files.each { |file| parse_file(file) if file.end_with?("1.gbk") }
  end

  # file_name, organism_name - necessary for fields in database
  # gb - genbank data, one sequence
  def parse_file(file)
    file_name = File.basename(file, ".gbk")
    organism_name = File.basename(self.organism_path)
    arr = []
    gen_bank = Bio::GenBank.open(file)
    gen_bank.each_entry do |gb|
      organism_data_from_gbk = gb.source
      organism_data[TAXONOMY_LIST] = organism_data_from_gbk["taxonomy"]
      self.organism_data[TAXONOMY_XREF] = extract_taxonomy_xref(gb)
      sequence_parser = SequenceParser.new(gb, file_name, organism_name)
      sequence_parser.parse
    end
  end

  # TODO implant this into one pass by features
  # mb in SequenceParser
  def extract_taxonomy_xref(gen_bank)
    gen_bank.features.each do |feature|
      if feature.feature == "source"
        feature_hash = feature.to_hash
        return feature_hash[DB_XREF].first if feature_hash.has_key?(DB_XREF)
      end
    end
  end

end