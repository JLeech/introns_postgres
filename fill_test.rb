require 'pg'

class StabFiller

  attr_accessor :connection

  def initialize(dbname, user)
    self.connection = PG.connect :dbname => dbname, :user => user
  end

  def load_organism
    insert_organism
    3.times do 
      load_4000_smt("sequence")
    end
    puts "seq"
    5.times do 
      load_4000_smt("gene")
    end
    puts "gene"
    6.times do 
      load_4000_smt("isoform")
    end
    puts "iso"
    50.times do 
      load_4000_smt("exon")
    end
    puts "ex"
    46.times do 
      load_4000_smt("intron")
    end
    puts "int"
  end

  def insert_organism
    command = "INSERT INTO organisms VALUES #{get_organism_data} RETURNING id"
    command = "SELECT * FROM organisms "
    puts "#{(self.connection.exec command).values}"
  end

# USUAL INSERTIONS

  def insert_sequence
    command = "INSERT INTO sequences VALUES #{get_sequence_data}"
    self.connection.exec command
  end

  def insert_gene
    command = "INSERT INTO genes VALUES #{get_gene_data}"
    self.connection.exec command
  end

  def insert_isoform
    command = "INSERT INTO isoforms VALUES #{get_isoform_data}"
    self.connection.exec command
  end

  def insert_exon
    command = "INSERT INTO exons VALUES #{get_exon_data}"
    self.connection.exec command
  end

  def insert_intron
    command = "INSERT INTO introns VALUES #{get_intron_data}"
    self.connection.exec command
  end

  def get_organism_data
    id = "default"
    name = "'#{('a'..'z').to_a.shuffle[0,100].join}'"
    ref_seq_assembly_id = "'#{('a'..'z').to_a.shuffle[0,10].join}'"
    annotation_release = "'#{('a'..'z').to_a.shuffle[0,100].join}'"
    taxonomy_xref = "'#{('a'..'z').to_a.shuffle[0,40].join}'"
    taxonomy_list = "'#{('a'..'z').to_a.shuffle[0,200].join}'"
    id_tax_groups2 = rand(500)
    real_chromosome_count = rand(500)
    db_chromosome_count = rand(500)
    real_mitochondria = true
    db_mitochondria = true
    unknown_sequences_count = rand(500)
    total_sequences_length = rand(500)
    b_genes_count = rand(500)
    r_genes_count = rand(500) 
    cds_count = rand(500)
    rna_count = rand(500)
    unknown_prot_genes_count = rand(500) 
    unknown_prot_cds_count = rand(500)
    exons_count= rand(500)
    introns_count = rand(500)
    data = [id,name,ref_seq_assembly_id,annotation_release,taxonomy_xref,taxonomy_list,id_tax_groups2,real_chromosome_count,db_chromosome_count,real_mitochondria,db_mitochondria,unknown_sequences_count,total_sequences_length,b_genes_count,r_genes_count,cds_count,rna_count,unknown_prot_genes_count,unknown_prot_cds_count,exons_count,introns_count].join(",")
    return "(#{data})"
  end

  def get_sequence_data
    source_file_name = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    refseq_id = "'#{('a'..'z').to_a.shuffle[0,10].join}'"
    version = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    description = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    lengthh = rand(500)
    id_organisms = rand(50)
    id_chromosomes = rand(50)
    origin_file_name = "'#{('a'..'z').to_a.shuffle[0,50].join}'"
    data = [source_file_name,refseq_id,version,description,lengthh,id_organisms,id_chromosomes,origin_file_name].join(',')
    return "(#{data})"
  end

  def get_gene_data
    id_organisms = rand(500)
    id_sequences = rand(500)
    id_orthologous_groups = rand(500)
    name = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    backward_chain = true
    protein_but_not_rna = true
    pseudo_gene = true
    startt = rand(500)
    endd = rand(500)
    start_code = rand(500)
    end_code = rand(500)
    max_introns_count = rand(500)
    data = [id_organisms,id_sequences,id_orthologous_groups,name,backward_chain,protein_but_not_rna,pseudo_gene,startt,endd,start_code,end_code,max_introns_count].join(",")
    return "(#{data})"
  end

  def get_isoform_data
    id_genes = rand(500)
    id_sequences = rand(500)
    protein_xref = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    protein_id = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    product = "'#{('a'..'z').to_a.shuffle[0,130].join}'"
    note = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    cds_start = rand(500)
    cds_end = rand(500)
    mrna_start = rand(500)
    mrna_end = rand(500)
    mrna_length = rand(500)
    exons_cds_count = rand(500)
    exons_mrna_count = rand(500)
    exons_length = rand(500)
    start_codon = "'#{('a'..'z').to_a.shuffle[0,3].join}'"
    end_codon = "'#{('a'..'z').to_a.shuffle[0,3].join}'"
    maximum_by_introns = true

    error_in_length = true
    error_in_start_codon = true
    error_in_end_codon = true
    error_in_intron = true
    error_in_coding_exon = true
    error_main = true
    error_comment = "'#{('a'..'z').to_a.shuffle[0,30].join}'"
    
    data = [id_genes ,id_sequences ,protein_xref ,protein_id ,product ,note ,cds_start ,cds_end ,mrna_start ,mrna_end ,mrna_length ,exons_cds_count ,exons_mrna_count ,exons_length ,start_codon ,end_codon ,maximum_by_introns ,error_in_length ,error_in_start_codon ,error_in_end_codon ,error_in_intron ,error_in_coding_exon ,error_main ,error_comment].join(",")
    return "(#{data})"
  end

  def get_exon_data

    id_isoforms = rand(200)
    id_genes = rand(200)
    id_sequences = rand(200)

    startt = rand(200)
    endd = rand(200)
    lengthh = rand(200)
    typee = rand(500)
    start_phase = rand(500)
    end_phase = rand(500)
    length_phase = rand(500)
    indexx = rand(200)
    rev_index = rand(200)
    start_codon = "'#{('a'..'z').to_a.shuffle[0,3].join}'"
    end_codon = "'#{('a'..'z').to_a.shuffle[0,3].join}'"

    prev_intron = rand(200)
    next_intron = rand(200)

    error_in_pseudo_flag = true
    error_n_in_sequence = true

    data = [id_isoforms ,id_genes ,id_sequences ,startt ,endd ,lengthh ,typee ,start_phase ,end_phase ,length_phase ,indexx ,rev_index ,start_codon ,end_codon ,prev_intron ,next_intron ,error_in_pseudo_flag ,error_n_in_sequence].join(",")
    return "(#{data})"
  end

  def get_intron_data
    id_isoforms = rand(500)
    id_genes = rand(500)
    id_sequences = rand(500)

    prev_exon = rand(500)
    next_exon = rand(500)
    id_intron_types = rand(500)

    start_dinucleotide = "'#{('a'..'z').to_a.shuffle[0,2].join}'"
    end_dinucleotide = "'#{('a'..'z').to_a.shuffle[0,2].join}'"

    startt = rand(500)
    endd = rand(500)
    lengthh = rand(500)
    indexx = rand(500)
    rev_index = rand(500)
    length_phase = rand(200)
    phase = rand(200)

    error_start_dinucleotide = true
    error_end_dinucleotide = true
    error_main = true

    warning_n_in_sequence = true
    data = [id_isoforms ,id_genes ,id_sequences ,prev_exon ,next_exon ,id_intron_types ,start_dinucleotide ,end_dinucleotide ,startt ,endd ,lengthh ,indexx ,rev_index ,length_phase ,phase ,error_start_dinucleotide ,error_end_dinucleotide ,error_main ,warning_n_in_sequence ].join(",")
    return "(#{data})"
  end

# BULK INSERTIONS
  
  def load_4000_smt(smt)
    smt_data = ""
    get_smt_data = "get_#{smt}_data"
    3999.times do
      smt_data += "#{send(get_smt_data)},"
    end
    smt_data += send(get_smt_data)
    command = "INSERT INTO #{smt}s VALUES #{smt_data}"
    self.connection.exec command
  end
end


filler = StabFiller.new('mydb','eve')

filler.insert_organism

# 40.times do 
#   st = Time.now
#   filler.load_organism
#   puts "T : #{Time.now - st}"
# end




# begin
  
#   con = PG.connect :dbname => 'mydb', :user => 'eve'
  
#   puts "single insertion"
#   counter = 0
#   1000.times do 
#     insert_command = "INSERT INTO weather(city,temp_lo,temp_hi,prcp,date) VALUES "
#     st = Time.now
#     999.times do
#       insert_command += "('San Francisco', 46, 50, 0.25, '1994-11-27'),"
#     end
#     insert_command += "('San Francisco', 46, 50, 0.25, '1994-11-27')"
    
#     con.exec insert_command
#     puts "took : #{Time.now - st}"
#     counter += 1000
#     puts counter
#   end
  
# rescue PG::Error => e
#   puts e.message 
# ensure
#   con.close if con
# end

# INSERT INTO films (code, title, did, date_prod, kind) VALUES
#     ('B6717', 'Tampopo', 110, '1985-02-10', 'Comedy'),
#     ('HG120', 'The Dinner Game', 140, DEFAULT, 'Comedy');

    # con = PG.connect :dbname => 'testdb', :user => 'janbodnar'
    
    # con.exec "DROP TABLE IF EXISTS Cars"
    # con.exec "CREATE TABLE Cars(Id INTEGER PRIMARY KEY, 
    #     Name VARCHAR(20), Price INT)"
    # con.exec "INSERT INTO Cars VALUES(1,'Audi',52642)"
    # con.exec "INSERT INTO Cars VALUES(2,'Mercedes',57127)"
    # con.exec "INSERT INTO Cars VALUES(3,'Skoda',9000)"
    # con.exec "INSERT INTO Cars VALUES(4,'Volvo',29000)"
    # con.exec "INSERT INTO Cars VALUES(5,'Bentley',350000)"
    # con.exec "INSERT INTO Cars VALUES(6,'Citroen',21000)"
    # con.exec "INSERT INTO Cars VALUES(7,'Hummer',41400)"
    # con.exec "INSERT INTO Cars VALUES(8,'Volkswagen',21600)"