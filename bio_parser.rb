class BioParser

  attr_accessor :organism_path
  attr_accessor :connector
  attr_accessor :result
  attr_accessor :state

  ORGANISMS = "organisms"
  TAX_KINGDOMS = "tax_kingdoms"
  TAX_GROUPS_1 = "tax_groups1"
  TAX_GROUPS_2 = "tax_groups2"
  START = "start"
  HEADERS = [ORGANISMS,TAX_KINGDOMS,TAX_GROUPS_1,TAX_GROUPS_2].map{ |val| "[#{val}]" }

  def initialize(organism_path, connector)
    self.organism_path = organism_path
    self.connector = connector
    self.state = START
    self.result = Hash.new { |hash, key| hash[key] = {} }
  end

  # set path to bio file and parse it
  # headers should be in the right order
  # tax_kingdom, tax_groups1, tax_groups_2
  def parse
    organism_bio_file = "#{organism_path}.bio"
    return result if !File.exist?(organism_bio_file)
    
    File.readlines(organism_bio_file).each do |line|
      if HEADERS.include?(line.strip)
        self.state = line.strip.gsub("[","").gsub("]","") 
        next
      end
      parse_line(line)
    end
    result["tax_groups_2_id"] = save_tax_data!
    return result.delete_if { |key| !["tax_groups_2_id",ORGANISMS].include?(key) } 
  end

  def parse_line(line)
    return if state == START
    splitted_data = line.strip.split('=').map(&:strip)
    return if splitted_data.empty?
    result[state]["#{splitted_data.first}"] = "'#{splitted_data.last}'"
  end

  def save_tax_data!
    bio_base = BioBase.new(result, connector)
    return bio_base.save!
  end

end

# saving parsed data to database

class BioBase

  attr_accessor :data
  attr_accessor :connector
  attr_accessor :inserted_ids

  def initialize(data, connector)
    self.data = data
    self.connector = connector
    self.inserted_ids = {}
  end

  # choose only tax data, because 'data' also store data 
  # for organism table
  # return id for tax_groups2. Organism needs it to store relation
  def save!
    data.keys.each do |table_name|
      next if !table_name.start_with?("tax")
      save_to_table!(table_name, data[table_name])
    end
    return inserted_ids['tax_groups2'] 
  end

  # first.first because Result class in pg returns chunk of array(matrix)
  # name is uniq, so first.first would fit
  def save_to_table!(table_name, table_data)
    id = record_exists(table_name, table_data)
    id = make_record(table_name, table_data) if id.empty?
    inserted_ids[table_name] = id.first.first.to_i
  end

  def record_exists(table_name, table_data)
    prepared_clauses = "name = #{table_data['name']}"
    command = "SELECT id FROM #{table_name} WHERE #{prepared_clauses}"
    result = (self.connector.exec command).values
    return result
  end

  def make_record(table_name, table_data)
    values, fields = get_values_fields(table_name,table_data)
    command = "INSERT INTO #{table_name}(#{fields}) VALUES(#{values}) RETURNING id"
    result = (self.connector.exec command).values
    return result
  end

  # special cases for cross table references
  # see UML diagramm
  def get_values_fields(table_name,table_data)
    values = []
    fields = []
    if table_name == "tax_groups1"
      fields = ["id_tax_kingdoms"]
      values = [self.inserted_ids["tax_kingdoms"]]
    elsif table_name == "tax_groups2"
      fields = ["id_tax_groups1", "id_tax_kingdoms"]
      values = [self.inserted_ids["tax_groups1"], self.inserted_ids["tax_kingdoms"]]
    end
    fields = (table_data.keys + fields).map { |val| val.gsub("'",'') } 
    return [table_data.values+values, fields ].map{|val| val.join(",") }
  end

end