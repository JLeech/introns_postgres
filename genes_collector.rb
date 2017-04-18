require 'csv'

# genes_path = '/home/eve/Documents/introns_postgres/from_db/res/genes.csv'
# genes = Hash.new { |hash, key| hash[key] = 0 }

# index = 0
# CSV.foreach(genes_path, headers: false) do |row|
#   index += 1
#   genes[row[4]] += 1

#   if (index%200000 == 0)
#     puts "#{index}/3026322"
#   end
# end
# puts "parsed"

# csv_path = "/home/eve/Documents/introns_postgres/genes_fulltext.csv"

# File.open(csv_path, 'w') do |csv|
#   genes.keys.each_with_index do |gene, index|
#     csv << [index, "#{gene}", "#{genes[gene]}"].join(",")+"\n"
#   end
# end


# CREATE TABLE genes_orgs(
#     id INT UNIQUE NOT NULL,
#     name VARCHAR(40) UNIQUE NOT NULL,
#     id_organisms TEXT
# );

# CREATE INDEX genes_names_pattern_index ON genes_orgs USING GIN(name gin_trgm_ops);

# def fix_common_names
#   from_db_path = '/home/eve/Documents/introns_postgres/from_db'
#   Dir.chdir(from_db_path)
#   folders = Dir.glob('*').select {|f| File.directory? f}  



#   folders.sort.each_with_index do |folder_name, index|
#     result_row = []
#     CSV.foreach("#{from_db_path}/#{folder_name}/organisms.csv", headers: false) do |row|  
#       result_row = row
#       result_row[2] = result_row[2].split("")[0].upcase + result_row[2].split("")[1..(-1)].join("")
#     end
#     File.open("#{from_db_path}/#{folder_name}/organisms.csv", 'w') do |organism_csv|
#       (1..7).each {|index| result_row[index] = "\"#{result_row[index]}\"" }
#       organism_csv.write(result_row.join(",")+"\n")
#     end
#   end
# end
# fix_common_names


def check_introns_errors
  from_db_path = '/home/eve/Documents/introns_postgres/from_db'
  Dir.chdir(from_db_path)
  folders = Dir.glob('*').select {|f| File.directory? f}


  CSV.foreach("#{from_db_path}/#{folder_name}/organisms.csv", headers: false) do |row|  
    result_row = row
    result_row[2] = result_row[2].split("")[0].upcase + result_row[2].split("")[1..(-1)].join("")
  end


  folders.sort.each_with_index do |folder_name, index|
    CSV.foreach("#{from_db_path}/#{folder_name}/isoforms.csv", headers: false) do |row|
      error_in_length = row[17]
      error_main = row[]
    end

  end


end
  
check_introns_errors