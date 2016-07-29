require 'bio'

#parse one sequence and start parsing genes

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
    self.sequence_data["origin_file_name"] = origin_file_name 
    parse_genes
  end


  # Suddenly parse gene in sequence parser.
  # TODO move in separate class
  def parse_genes
    gene_data = {}
    data.features.each_with_index do |feature, index|
      if feature.feature == "gene"
        feature_data = feature.assoc
        gene_data["name"] = feature_data["gene"]
        gene_data["pseudo_gene"] = !(feature_data.keys & ["pseudo","pseudogene"]).empty?
        location = Bio::Locations.new(feature.position)
        gene_data["startt"] = location.first.from
        gene_data["endd"] = location.last.to
        gene_data["backward_chain"] = -1 == location.first.strand

      end
    end
  end

  def origin_file_name
    return "#{self.organism_name.downcase}/#{self.sequence_data["refseq_id"].downcase}.raw.txt"
  end

end