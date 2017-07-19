# require 'csv'

# from_db_path = '/home/eve/Documents/introns_postgres/from_db'
# Dir.chdir(from_db_path)
# folders = Dir.glob('*').select {|f| File.directory? f}

# data = {}

# folders.sort.each do |folder_name|
#   next if !File.exists?("#{from_db_path}/#{folder_name}/tax_kingdoms.csv")
#   next if folder_name != "Bombus_terrestris"
#   puts "#{folder_name}"
#   # index = 0
#   # folder_num = 0
#   # CSV.foreach("#{from_db_path}/#{folder_name}/introns.csv", headers: false) do |row|
#   #     puts "---- #{folder_name} : #{index}" if row[9] == "\\N" 
#   #     index += 1
#   # end
#   count = 84260
#   CSV.foreach("#{from_db_path}/#{folder_name}/exons.csv", headers: false) do |row|
#     if data.has_key?("#{row[2]}_#{row[4]}_#{row[5]}")
#       count += 1
#     else
#       data["#{row[2]}_#{row[4]}_#{row[5]}"] = 1
#     end
#   end
#   puts "X: #{count}"
# end

def seq_check(seq)
  codons = seq.chars.each_slice(3).map(&:join)
  if (codons.include?("TAA") || codons.include?("TAG") || codons.include?("TGA"))
    puts "____"
    puts codons.index("TAA")
    puts codons.index("TAG")
    puts codons.index("TGA")
  end
end

