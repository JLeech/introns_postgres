# sequence per 

class IdManager

  attr_accessor :sequences_id
  attr_accessor :genes_id

  def initialize
    self.sequences_id = -1
    self.genes_id = -1
  end

  def inc_and_get_id(queue)
    queue_id = "#{queue}_id"
    send("#{queue_id}=", send(queue_id) + 1)
    return send(queue_id)
  end

  def add_and_get_chunk_of_ids(number_of_ids, queue)
    queue_id = "#{queue}_id"
    start_id = send(queue_id) + 1
    ids = (start_id..(number_of_ids + start_id-1))
    send("#{queue_id}=", start_id + number_of_ids-1)
    return ids.to_a
  end

end