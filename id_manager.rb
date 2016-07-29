class IdManager

  attr_accessor :sequence_id
  attr_accessor :gene_id

  def initialize
    self.sequence_id = -1
    self.gene_id = -1
  end

  def inc_and_get_seq_id
    self.sequence_id += 1
    return self.sequence_id
  end

  def inc_and_get_gene_id
  	self.gene_id += 1
  	return self.gene_id
  end

end