require "redis"
require 'csv'

class IdManager

  attr_accessor :redis

  def initialize
    self.redis = Redis.new
  end

  def clear_result_dir
    `rm /home/eve/Documents/postgres_filler/res/*`
  end

  def set_counters
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
    self.redis.flushall
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

st = Time.now

manager = IdManager.new
manager.set_counters
manager.clear_result_dir

f1 = Time.now

puts "#{(f1-st).round(2)}"
puts "starting"

manager.fix_tax_kingdoms("/home/eve/Documents/postgres_filler/Anolis_carolinensis/tax_kingdoms.csv")
manager.fix_tax_groups_1("/home/eve/Documents/postgres_filler/Anolis_carolinensis/tax_groups1.csv")
manager.fix_tax_groups_2("/home/eve/Documents/postgres_filler/Anolis_carolinensis/tax_groups2.csv")
manager.fix_organism("/home/eve/Documents/postgres_filler/Anolis_carolinensis/organisms.csv")
manager.fix_chromosomes("/home/eve/Documents/postgres_filler/Anolis_carolinensis/chromosomes.csv")
manager.fix_sequences("/home/eve/Documents/postgres_filler/Anolis_carolinensis/sequences.csv")
manager.fix_orphaned_cds("/home/eve/Documents/postgres_filler/Anolis_carolinensis/orphaned_cdses.csv")
manager.fix_genes("/home/eve/Documents/postgres_filler/Anolis_carolinensis/genes.csv")
manager.fix_isoforms("/home/eve/Documents/postgres_filler/Anolis_carolinensis/isoforms.csv")
manager.fix_exons("/home/eve/Documents/postgres_filler/Anolis_carolinensis/exons.csv")
manager.fix_introns("/home/eve/Documents/postgres_filler/Anolis_carolinensis/introns.csv")
manager.fix_exons_prev("/home/eve/Documents/postgres_filler/Anolis_carolinensis/exons.csv")
manager.fix_introns_prev("/home/eve/Documents/postgres_filler/Anolis_carolinensis/introns.csv")

f2 = Time.now
puts "#{(f2-f1).round(2)}"
puts "Anolis ready"

manager.fix_tax_kingdoms("/home/eve/Documents/postgres_filler/Mus_musculus/tax_kingdoms.csv")
manager.fix_tax_groups_1("/home/eve/Documents/postgres_filler/Mus_musculus/tax_groups1.csv")
manager.fix_tax_groups_2("/home/eve/Documents/postgres_filler/Mus_musculus/tax_groups2.csv")
manager.fix_organism("/home/eve/Documents/postgres_filler/Mus_musculus/organisms.csv")
manager.fix_chromosomes("/home/eve/Documents/postgres_filler/Mus_musculus/chromosomes.csv")
manager.fix_sequences("/home/eve/Documents/postgres_filler/Mus_musculus/sequences.csv")
manager.fix_orphaned_cds("/home/eve/Documents/postgres_filler/Mus_musculus/orphaned_cdses.csv")
manager.fix_genes("/home/eve/Documents/postgres_filler/Mus_musculus/genes.csv")
manager.fix_isoforms("/home/eve/Documents/postgres_filler/Mus_musculus/isoforms.csv")
manager.fix_exons("/home/eve/Documents/postgres_filler/Mus_musculus/exons.csv")
manager.fix_introns("/home/eve/Documents/postgres_filler/Mus_musculus/introns.csv")
manager.fix_exons_prev("/home/eve/Documents/postgres_filler/Mus_musculus/exons.csv")
manager.fix_introns_prev("/home/eve/Documents/postgres_filler/Mus_musculus/introns.csv")

f3 = Time.now
puts "#{(f3-f2).round(2)}"
puts "Mus ready"

manager.fix_tax_kingdoms("/home/eve/Documents/postgres_filler/Musa_acuminata/tax_kingdoms.csv")
manager.fix_tax_groups_1("/home/eve/Documents/postgres_filler/Musa_acuminata/tax_groups1.csv")
manager.fix_tax_groups_2("/home/eve/Documents/postgres_filler/Musa_acuminata/tax_groups2.csv")
manager.fix_organism("/home/eve/Documents/postgres_filler/Musa_acuminata/organisms.csv")
manager.fix_chromosomes("/home/eve/Documents/postgres_filler/Musa_acuminata/chromosomes.csv")
manager.fix_sequences("/home/eve/Documents/postgres_filler/Musa_acuminata/sequences.csv")
manager.fix_orphaned_cds("/home/eve/Documents/postgres_filler/Musa_acuminata/orphaned_cdses.csv")
manager.fix_genes("/home/eve/Documents/postgres_filler/Musa_acuminata/genes.csv")
manager.fix_isoforms("/home/eve/Documents/postgres_filler/Musa_acuminata/isoforms.csv")
manager.fix_exons("/home/eve/Documents/postgres_filler/Musa_acuminata/exons.csv")
manager.fix_introns("/home/eve/Documents/postgres_filler/Musa_acuminata/introns.csv")
manager.fix_exons_prev("/home/eve/Documents/postgres_filler/Musa_acuminata/exons.csv")
manager.fix_introns_prev("/home/eve/Documents/postgres_filler/Musa_acuminata/introns.csv")

f4 = Time.now
puts "#{(f4-f3).round(2)}"
puts "Musa ready"

manager.fix_tax_kingdoms("/home/eve/Documents/postgres_filler/Homo_sapiens/tax_kingdoms.csv")
manager.fix_tax_groups_1("/home/eve/Documents/postgres_filler/Homo_sapiens/tax_groups1.csv")
manager.fix_tax_groups_2("/home/eve/Documents/postgres_filler/Homo_sapiens/tax_groups2.csv")
manager.fix_organism("/home/eve/Documents/postgres_filler/Homo_sapiens/organisms.csv")
manager.fix_chromosomes("/home/eve/Documents/postgres_filler/Homo_sapiens/chromosomes.csv")
manager.fix_sequences("/home/eve/Documents/postgres_filler/Homo_sapiens/sequences.csv")
manager.fix_orphaned_cds("/home/eve/Documents/postgres_filler/Homo_sapiens/orphaned_cdses.csv")
manager.fix_genes("/home/eve/Documents/postgres_filler/Homo_sapiens/genes.csv")
manager.fix_isoforms("/home/eve/Documents/postgres_filler/Homo_sapiens/isoforms.csv")
manager.fix_exons("/home/eve/Documents/postgres_filler/Homo_sapiens/exons.csv")
manager.fix_introns("/home/eve/Documents/postgres_filler/Homo_sapiens/introns.csv")
manager.fix_exons_prev("/home/eve/Documents/postgres_filler/Homo_sapiens/exons.csv")
manager.fix_introns_prev("/home/eve/Documents/postgres_filler/Homo_sapiens/introns.csv")

f5 = Time.now
puts "#{(f5-f4).round(2)}"
puts "Homo ready"

manager.fix_tax_kingdoms("/home/eve/Documents/postgres_filler/Apis_mellifera/tax_kingdoms.csv")
manager.fix_tax_groups_1("/home/eve/Documents/postgres_filler/Apis_mellifera/tax_groups1.csv")
manager.fix_tax_groups_2("/home/eve/Documents/postgres_filler/Apis_mellifera/tax_groups2.csv")
manager.fix_organism("/home/eve/Documents/postgres_filler/Apis_mellifera/organisms.csv")
manager.fix_chromosomes("/home/eve/Documents/postgres_filler/Apis_mellifera/chromosomes.csv")
manager.fix_sequences("/home/eve/Documents/postgres_filler/Apis_mellifera/sequences.csv")
manager.fix_orphaned_cds("/home/eve/Documents/postgres_filler/Apis_mellifera/orphaned_cdses.csv")
manager.fix_genes("/home/eve/Documents/postgres_filler/Apis_mellifera/genes.csv")
manager.fix_isoforms("/home/eve/Documents/postgres_filler/Apis_mellifera/isoforms.csv")
manager.fix_exons("/home/eve/Documents/postgres_filler/Apis_mellifera/exons.csv")
manager.fix_introns("/home/eve/Documents/postgres_filler/Apis_mellifera/introns.csv")
manager.fix_exons_prev("/home/eve/Documents/postgres_filler/Apis_mellifera/exons.csv")
manager.fix_introns_prev("/home/eve/Documents/postgres_filler/Apis_mellifera/introns.csv")

f6 = Time.now
puts "#{(f6-f5).round(2)}"
puts "Apis ready"