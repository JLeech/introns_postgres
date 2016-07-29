require 'bio'

class SequenceParser

  attr_accessor :data
  attr_accessor :sequence_data
  attr_accessor :organism_name

  def initialize(data, source_file, organism_name)
    self.data = data
    self.sequence_data = {"source_file_name" => source_file}
    self.organism_name = organism_name
  end

  def parse
    self.sequence_data["refseq_id"] = data.locus.entry_id
    self.sequence_data["version"] = data.versions.join("\n")
    self.sequence_data["description"] = data.definition
    self.sequence_data["origin_file_name"] = "#{organism_name.downcase}/#{self.sequence_data["refseq_id"].downcase}.raw.txt"
    
    parse_genes
  end

  def parse_genes
    data.features.each_with_index do |feature, index|
        if feature.feature == "source"
          
        end

    end
  end


end