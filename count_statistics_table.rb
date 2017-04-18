require 'csv'

class OrgStat

  attr_accessor :id
  attr_accessor :name
  attr_accessor :common_name
  attr_accessor :tax
  attr_accessor :version
  attr_accessor :date
  attr_accessor :gene_count
  attr_accessor :iso_count
  attr_accessor :exon_count
  attr_accessor :intron_count
  attr_accessor :intron_with_error
  attr_accessor :phase_0_count
  attr_accessor :phase_1_count
  attr_accessor :phase_2_count
  attr_accessor :phase_0_persent
  attr_accessor :phase_1_persent
  attr_accessor :phase_2_persent

  def initialize(id=0)
    self.id = id
    self.iso_count = 0
    self.intron_count = 0
    self.intron_with_error = 0
    self.phase_0_count = 0
    self.phase_1_count = 0
    self.phase_2_count = 0
  end

  def print
    puts self.name
    puts self.common_name
    puts self.version
    puts self.date
    puts self.gene_count
    puts self.iso_count
    puts "exon_count: #{self.exon_count}"
    puts "intron_count: #{self.intron_count}"
    puts "intron_with_error: #{self.intron_with_error}"
    puts "phase_0_count: #{self.phase_0_count}"
    puts "phase_1_count: #{self.phase_1_count}"
    puts "phase_2_count: #{self.phase_2_count}"
    puts "phase_0_persent: #{self.phase_0_persent}"
    puts "phase_1_persent: #{self.phase_1_persent}"
    puts "phase_2_persent: #{self.phase_2_persent}"
  end

  def print_for_table
   puts "{id: #{self.id}, name: \"#{self.name}\", common_name: \"#{self.common_name}\", tax: \"#{self.tax}\", version: \"#{self.version}\", date: \"#{self.date}\", gene_count: \"#{self.gene_count}\", iso_count: \"#{self.iso_count}\", exon_count: \"#{self.exon_count}\" , intron_count: \"#{self.intron_count}\" , intron_with_error: \"#{self.intron_with_error}\" , phase_0_count: \"#{self.phase_0_count}\" , phase_1_count: \"#{self.phase_1_count}\" , phase_2_count: \"#{self.phase_2_count}\" , phase_0_persent: \"#{self.phase_0_persent}\" , phase_1_persent: \"#{self.phase_1_persent}\" , phase_2_persent: \"#{self.phase_2_persent}\" },"
  end

  def inc_ph_0
    self.phase_0_count += 1
  end

  def inc_ph_1
    self.phase_1_count += 1
  end

  def inc_ph_2
    self.phase_2_count += 1
  end

end

class Statistic

  attr_accessor :path
  attr_accessor :org_stat

  def initialize(path,index)
    self.path = path
    self.org_stat = OrgStat.new(index)
  end

  def parse
    parse_org
    parse_counts
    #self.org_stat.print
  end

  def parse_org
    CSV.foreach("#{path}/organisms.csv", headers: false) do |row|
      self.org_stat.name = row[1]
      self.org_stat.common_name = row[2]
      self.org_stat.version = row[4].split(" ")[-2..-1].join(" ")
      self.org_stat.date = row[5]
    end
    self.org_stat.tax = CSV.read( "#{path}/tax_groups1.csv", headers: false)[0][2]
  end

  def parse_counts
    self.org_stat.gene_count = CSV.read( "#{path}/genes.csv", headers: false).length
    #self.org_stat.iso_count = CSV.read( "#{path}/isoforms.csv", headers: false).length
    CSV.foreach("#{path}/isoforms.csv", headers: false) do |row|
      next if row[7] == "0"
      self.org_stat.iso_count += 1
    end
    self.org_stat.exon_count = CSV.read( "#{path}/exons.csv", headers: false).length
    CSV.foreach("#{path}/introns.csv", headers: false) do |row|
      if row[18] == "1"
        self.org_stat.intron_with_error += 1
        # next
      end
      self.org_stat.intron_count += 1
      self.org_stat.send("inc_ph_#{row[15]}")
    end
    
    self.org_stat.phase_0_persent = ((self.org_stat.phase_0_count.to_f/self.org_stat.intron_count)*100).round(1)
    self.org_stat.phase_1_persent = ((self.org_stat.phase_1_count.to_f/self.org_stat.intron_count)*100).round(1)
    self.org_stat.phase_2_persent = ((self.org_stat.phase_2_count.to_f/self.org_stat.intron_count)*100).round(1)
  end

  def print_for_table
    self.org_stat.print_for_table
  end

end

from_db_path = '/home/eve/Documents/introns_postgres/from_db'
Dir.chdir(from_db_path)
folders = Dir.glob('*').select {|f| File.directory? f}

index = 1
folders.each do |folder_name|
  folder = "#{from_db_path}/#{folder_name}"
  next if !File.exist?("#{folder}/exons.csv")
  next if !(folder_name == "Bombus_terrestris")
  st = Statistic.new(folder, index)
  st.parse
  st.print_for_table
  puts "I : #{st.iso_count}"
  puts "E : #{st.exon_count}"
  puts "IN: #{st.intron_count}"
  puts "DI: #{st.exon_count - st.intron_count}"
  index += 1
end
# id = 1
# st = Statistic.new("/home/eve/Documents/postgres_filler/Mus_musculus", id)
# st.parse
