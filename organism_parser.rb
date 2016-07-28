require 'bio'

class OrganismParser

 TAXONOMY_LIST ="taxonomy_list"
 TAXONOMY_XREF = "taxonomy_xref"
 DB_XREF = "db_xref"

  attr_accessor :organism_path
  attr_accessor :organism_data
  attr_accessor :id_tax_groups2
  attr_accessor :connection

  def initialize(organism_path, additional_organism_data, connection)
    self.organism_path = organism_path
    self.organism_data = additional_organism_data
    self.connection = connection
  end

  def parse
    gbk_files = Dir["#{self.organism_path}/*"]
    gbk_files.each { |file| parse_file(file) if file.end_with?("1.gbk") }
  end

  def parse_file(file)
    arr = []
    gen_bank = Bio::GenBank.open(file)
    gen_bank.each_entry do |gb|
      organism_data_from_gbk = gb.source
      organism_data[TAXONOMY_LIST] = organism_data_from_gbk["taxonomy"]
      self.organism_data[TAXONOMY_XREF] = extract_taxonomy_xref(gb)
    end
    puts "#{organism_data}"
  end

  def extract_taxonomy_xref(gen_bank)
    gen_bank.features.each do |feature|
      if feature.feature == "source"
        feature_hash = feature.to_hash
        return feature_hash[DB_XREF].first if feature_hash.has_key?(DB_XREF)
      end
    end
  end

end