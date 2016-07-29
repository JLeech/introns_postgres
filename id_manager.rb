class IdManager

  attr_accessor :sequence_id

  def initialize
    sequence_id = -1
  end

  def inc_and_get_seq_id
    self.sequence_id += 1
    return self.sequence_id
  end

end