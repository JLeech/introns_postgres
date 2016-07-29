# sequence per 

class IdManager

  attr_accessor :sequences_id
  attr_accessor :genes_id

  def initialize
    self.sequences_id = -1
    self.genes_id = -1
  end

  def inc_and_get_id(queue_name)
    send("#{queue_name}_id=", send("#{queue_name}_id") +  1)
    return send("#{queue_name}_id")
  end

  def add_and_get_chunk_of_ids(number_of_ids, queue)


  end

  #TODO make methods for getting ids in range
  # for chunk loads

end