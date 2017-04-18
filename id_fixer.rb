require "redis"
require 'csv'

class IdManager

  attr_accessor :redis
  attr_accessor :state_path


  def initialize
    self.redis = Redis.new
    self.state_path = "/home/eve/Documents/introns_postgres/state.csv"
  end

  def self.clear_result_dir
    `rm /home/eve/Documents/introns_postgres/from_db/res/*`
  end

  def set_counters()
    self.redis.flushall
    self.redis.set("max_id_intron_types",0)
    self.redis.set("max_id_tax_kingdoms",0)
    self.redis.set("max_id_tax_groups1",0)
    self.redis.set("max_id_tax_groups2",0)
    self.redis.set("max_id_orthologous_groups",0)
    self.redis.set("max_id_organisms",0)
    self.redis.set("max_id_chromosomes",0)
    self.redis.set("max_id_sequences",0)
    self.redis.set("max_id_orphaned_cdses",0)
    self.redis.set("max_id_genes",0)
    self.redis.set("max_id_isoforms",0)
    self.redis.set("max_id_exons",0)
    self.redis.set("max_id_introns",0)
  end

  def save_state
    File.open(self.state_path, 'w') do |state_csv|
      state_csv.write(["max_id_intron_types",self.redis.get("max_id_intron_types")].join(",") + "\n")
      state_csv.write(["max_id_tax_kingdoms",self.redis.get("max_id_tax_kingdoms")].join(",") + "\n")
      state_csv.write(["max_id_tax_groups1",self.redis.get("max_id_tax_groups1")].join(",") + "\n")
      state_csv.write(["max_id_tax_groups2",self.redis.get("max_id_tax_groups2")].join(",") + "\n")
      state_csv.write(["max_id_orthologous_groups",self.redis.get("max_id_orthologous_groups")].join(",") + "\n")
      state_csv.write(["max_id_organisms",self.redis.get("max_id_organisms")].join(",") + "\n")
      state_csv.write(["max_id_chromosomes",self.redis.get("max_id_chromosomes")].join(",") + "\n")
      state_csv.write(["max_id_sequences",self.redis.get("max_id_sequences")].join(",") + "\n")
      state_csv.write(["max_id_orphaned_cdses",self.redis.get("max_id_orphaned_cdses")].join(",") + "\n")
      state_csv.write(["max_id_genes",self.redis.get("max_id_genes")].join(",") + "\n")
      state_csv.write(["max_id_isoforms",self.redis.get("max_id_isoforms")].join(",") + "\n")
      state_csv.write(["max_id_exons",self.redis.get("max_id_exons")].join(",") + "\n")
      state_csv.write(["max_id_introns",self.redis.get("max_id_introns")].join(",") + "\n")
      
      keys = redis.keys
      keys.keep_if { |key| (key.start_with?("kingdoms_") || key.start_with?("group_1_") || key.start_with?("group_2_") ) }
      keys.each do |key|
        state_csv.write([key, self.redis.get(key)].join(",")+"\n") 
      end
    end
    self.redis.flushall
  end

  def load_state
    state_empty = true
    CSV.foreach(self.state_path, headers: false) do |row|
      self.redis.set(row[0], row[1])
      state_empty = false
    end
    set_counters if state_empty
  end

  def fix_tax_kingdoms(path)
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("kingdoms_n#{row[1]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_tax_kingdoms",1)
          redis.set("kingdoms_n#{row[1]}", new_id)
          redis.set("kingdoms_#{row[0]}", new_id)
        else
          redis.set("kingdoms_#{row[0]}", new_id)
          next
        end
        row[0] = new_id
        row[1] = "\"#{row[1]}\""
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_tax_groups_1(path)
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("group_1_n#{row[2]}_#{row[3]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_tax_groups1",1)
          redis.set("group_1_n#{row[2]}_#{row[3]}",new_id)
          redis.set("group_1_#{row[0]}",new_id)
        else
          redis.set("group_1_#{row[0]}",new_id)
          next
        end
        row[0] = new_id
        row[1] = redis.get("kingdoms_#{row[1]}")
        [2,3].each {|index| row[index] = "\"#{row[index]}\"" }
        csv.write(row.join(",")+"\n")
      end
    end    
  end

  def fix_tax_groups_2(path)
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        search_by_str = "group_2_n#{row[3]}_#{row[4]}"
        new_id = redis.get(search_by_str)
        if new_id.nil?
          new_id = redis.incrby("max_id_tax_groups2",1)
          redis.set(search_by_str,new_id)
          redis.set("group_2_#{row[0]}",new_id)
        else
          redis.set("group_2_#{row[0]}",new_id)
          next
        end
        row[0] = new_id
        row[1] = redis.get("group_1_#{row[1]}")
        row[2] = redis.get("kingdoms_#{row[2]}")
        [3,4].each {|index| row[index] = "\"#{row[index]}\"" }
        csv.write(row.join(",")+"\n")
      end
    end    
  end

  def fix_organism(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_organism_n#{row[1]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_organisms",1)
          redis.set("#{org_name}_organism_n#{row[1]}",new_id)
          redis.set("#{org_name}_organism_#{row[0]}",new_id)
        end
        row[0] = new_id
        (1..7).each {|index| row[index] = "\"#{row[index]}\"" }
        row[8] = redis.get("group_2_#{row[8]}")
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_chromosomes(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_chromosome_n#{row[2]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_chromosomes",1)
          redis.set("#{org_name}_chromosome_n#{row[2]}",new_id)
          redis.set("#{org_name}_chromosome_#{row[0]}",new_id)
        end
        row[0] = new_id
        row[2] = "\"#{row[2]}\""
        row[1] = redis.get("#{org_name}_organism_#{row[1]}")
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_sequences(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_sequence_n#{row[2]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_sequences",1)
          redis.set("#{org_name}_sequence_n#{row[2]}",new_id)
          redis.set("#{org_name}_sequence_#{row[0]}",new_id)
        end
        row[0] = new_id
        row[6] = redis.get("#{org_name}_organism_#{row[6]}")
        row[7] = redis.get("#{org_name}_chromosome_#{row[7]}")
        (1..4).each {|index| row[index] = "\"#{row[index]}\"" }
        row[8] = "\"#{row[8]}\""
        row[9] = "\"#{row[9]}\""
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_orphaned_cds(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_orph_#{row[0]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_orphaned_cdses",1)
          redis.set("#{org_name}_orph_#{row[0]}",new_id)
        end
        row[0] = new_id
        row[1] = "\"#{row[1]}\""
        row[4] = "\"#{row[4]}\""
        row[5] = "\"#{row[5]}\""
        row[6] = "\"#{row[6]}\""
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_genes(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_gene_#{row[0]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_genes",1)
          redis.set("#{org_name}_gene_#{row[0]}",new_id)
        end
        row[0] = new_id
        row[1] = redis.get("#{org_name}_organism_#{row[1]}")
        row[2] = redis.get("#{org_name}_sequence_#{row[2]}")
        row[3] = -1
        row[4] = "\"#{row[4]}\""
        row[5] = "\"#{row[5]}\""
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_isoforms(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_isoform_#{row[0]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_isoforms",1)
          redis.set("#{org_name}_isoform_#{row[0]}",new_id)
        end
        row[0] = new_id
        row[1] = redis.get("#{org_name}_gene_#{row[1]}")
        row[2] = redis.get("#{org_name}_sequence_#{row[2]}")
        (3..6).each {|index| row[index] = "\"#{row[index]}\"" }
        row[15] = "\"#{row[15]}\""
        row[16] = "\"#{row[16]}\""
        row[-1] = 0
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_exons(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open("#{result_path}_f", 'w') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_exon_#{row[0]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_exons",1)
          redis.set("#{org_name}_exon_#{row[0]}",new_id)
        end
        row[0] = new_id
        row[1] = redis.get("#{org_name}_isoform_#{row[1]}")
        row[2] = redis.get("#{org_name}_gene_#{row[2]}")
        row[3] = redis.get("#{org_name}_sequence_#{row[3]}")
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_introns(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open("#{result_path}_f", 'w') do |csv|
      CSV.foreach(path, headers: false) do |row|
        new_id = redis.get("#{org_name}_intron_#{row[0]}")
        if new_id.nil?
          new_id = redis.incrby("max_id_introns",1)
          redis.set("#{org_name}_intron_#{row[0]}",new_id)
        end
        row[0] = new_id
        row[1] = redis.get("#{org_name}_isoform_#{row[1]}")
        row[2] = redis.get("#{org_name}_gene_#{row[2]}")
        row[3] = redis.get("#{org_name}_sequence_#{row[3]}")
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_exons_prev(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach("#{result_path}_f", headers: false) do |row|
        row[15] = row[15] == "0" ? 0 : redis.get("#{org_name}_intron_#{row[15]}")
        row[16] = row[16] == "0" ? 0 : redis.get("#{org_name}_intron_#{row[16]}")
        row[13] = "\"#{row[13]}\""
        row[14] = "\"#{row[14]}\""
        csv.write(row.join(",")+"\n")
      end
    end
  end

  def fix_introns_prev(path)
    org_name = File.dirname(path).split("/").last
    result_path = ( path.split("/")[0..-3] + ["res"]).join("/") + "/#{File.basename(path)}"
    File.open(result_path, 'a') do |csv|
      CSV.foreach("#{result_path}_f", headers: false) do |row|
        row[4] = redis.get("#{org_name}_exon_#{row[4]}")
        row[5] = redis.get("#{org_name}_exon_#{row[5]}")
        row[7] = "\"#{row[7]}\""
        row[8] = "\"#{row[8]}\""
        csv.write(row.join(",")+"\n")
      end
    end
  end

end


from_db_path = '/home/eve/Documents/introns_postgres/from_db'
Dir.chdir(from_db_path)
folders = Dir.glob('*').select {|f| File.directory? f}

state = {}
IdManager.clear_result_dir

folders.sort.each_with_index do |folder_name, index|

  f1 = Time.now
  puts "#{index+1}/#{folders.length} : #{folder_name}"

  manager = IdManager.new
  manager.load_state
  next if !File.exists?("#{from_db_path}/#{folder_name}/tax_kingdoms.csv")
  next if folder_name == "res"
  manager.fix_tax_kingdoms("#{from_db_path}/#{folder_name}/tax_kingdoms.csv")
  manager.fix_tax_groups_1("#{from_db_path}/#{folder_name}/tax_groups1.csv")
  manager.fix_tax_groups_2("#{from_db_path}/#{folder_name}/tax_groups2.csv")
  manager.fix_organism("#{from_db_path}/#{folder_name}/organisms.csv")
  manager.fix_chromosomes("#{from_db_path}/#{folder_name}/chromosomes.csv")
  manager.fix_sequences("#{from_db_path}/#{folder_name}/sequences.csv")
  manager.fix_orphaned_cds("#{from_db_path}/#{folder_name}/orphaned_cdses.csv")
  manager.fix_genes("#{from_db_path}/#{folder_name}/genes.csv")
  manager.fix_isoforms("#{from_db_path}/#{folder_name}/isoforms.csv")
  manager.fix_exons("#{from_db_path}/#{folder_name}/exons.csv")
  manager.fix_introns("#{from_db_path}/#{folder_name}/introns.csv")
  manager.fix_exons_prev("#{from_db_path}/#{folder_name}/exons.csv")
  manager.fix_introns_prev("#{from_db_path}/#{folder_name}/introns.csv")

  f2 = Time.now
  puts "time: #{((f2-f1)/60.0).round(2)}"

  manager.save_state

end
