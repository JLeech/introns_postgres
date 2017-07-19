require 'csv'


# class Statistics

	# 	attr_accessor :gene_id_hash	

	# 	attr_accessor :path	

	# 	def initialize(path)
	# 		self.path = path
	# 		self.gene_id_hash = Hash.new { |hash, key| hash[key] = empty_record }
	# 	end	

	# 	def fill_and_save
	# 		puts "filling exons"
	# 		fill_exons
	# 		puts "filling introns"
	# 		fill_introns
	# 		puts "saving"
	# 		save
	# 	end	

	# 	def fill_exons
	# 		counter = 0
	# 		CSV.foreach("#{self.path}/exons.csv", headers: false) do |row|
	# 			gene_id = row[2]
	# 			phase = row[10]
	# 			gene_id_hash[gene_id]["exon_all"] += 1
	# 			gene_id_hash[gene_id]["exon_phase_#{phase}"] += 1
	# 			counter += 1
	# 			puts "#{counter}/35449402" if (counter%1000000 == 0)
	# 		end
	# 	end	

	# 	def fill_introns
	# 		counter = 0
	# 		CSV.foreach("#{self.path}/introns.csv", headers: false) do |row|
	# 			gene_id = row[2]
	# 			phase = row[14]
	# 			error = row[18].to_i
	# 			if (error == 1)
	# 				gene_id_hash[gene_id]["intron_with_error"] += 1
	# 				gene_id_hash[gene_id]["intron_err_phase_#{phase}"] += 1
	# 			end
	# 			gene_id_hash[gene_id]["intron_all"] += 1
	# 			gene_id_hash[gene_id]["intron_phase_#{phase}"] += 1
	# 			counter += 1
	# 			puts "#{counter}/31499836" if (counter%1000000 == 0)
	# 		end
	# 	end	

	# 	def empty_record
	# 		return ({"exon_phase_0"=>0,"exon_phase_1"=>0,"exon_phase_2"=>0,"exon_all"=>0,
	# 				 "intron_phase_0"=>0,"intron_phase_1"=>0,"intron_phase_2"=>0,"intron_all"=>0,"intron_err_phase_0"=>0,"intron_err_phase_1"=>0,"intron_err_phase_2"=>0,"intron_with_error"=>0})
	# 	end	

	# 	def save
	# 		`rm #{path}/gene_stat.csv`
	# 		File.open("#{self.path}/gene_stat.csv", 'w') do |state_csv|
	# 			gene_id_hash.each do |key, value|
	# 				state_csv.write(([key] + value.values).join(",") + "\n")
	# 			end
	# 		end
	# 	end

# end


class OrthoGroupSetter

	attr_accessor :ortho_counter
	attr_accessor :ortho_hash

	def initialize(ortho_path)
		self.ortho_counter = Hash.new { |hash, key| hash[key] = 0 }
		self.ortho_hash = Hash.new { |hash, key| hash[key] = false }
		CSV.foreach(ortho_path, headers: false, col_sep: ";") do |row| 
			ortho_hash[row[1]] = row[2]
			ortho_counter[row[2]] = 0
		end
	end

	def set_ortho(path)

		gene_hash = Hash.new { |hash, key| hash[key] = 0 }
		counter = 0
		fixed_gene_path = "#{path}/fixed_genes.csv"
		File.open(fixed_gene_path, 'a') do |csv|
			CSV.foreach("#{path}/genes.csv", headers: false) do |row| 
				if ortho_hash[row[5]] != false
					ortho_counter[ortho_hash[row[5]]] += 1
					row[3] = ortho_hash[row[5]]
				end
				row[4] = "\"#{row[4]}\""
        		row[5] = "\"#{row[5]}\""
        		csv.write(row.join(",")+"\n")
				
				puts "#{counter}/1096698" if counter%100000 == 0
				counter += 1
			end
		end
		#puts "N: #{(ortho_gr.keys.length - (ortho_hash.keys & gene_hash.keys).length)}"
	end

	def set_ortho_res_genes(path)
		CSV.foreach("#{path}/genes.csv", headers: false) { |row| ortho_hash[row[5]] += 1 }
	end

end

res_path = '/home/eve/Documents/introns_postgres/from_db/res'
ortho_path = '/home/eve/Documents/introns_postgres/common_ortho_table.csv'

ortho_setter = OrthoGroupSetter.new(ortho_path)
ortho_setter.set_ortho(res_path)

# Dir.chdir(res_path)
# folders = Dir.glob('*').select {|f| File.directory? f}
# folders.sort.each do |folder|
# 	next if !File.exist?("#{folder}/genes.csv")
# 	next if folder == "res"
	
# end






# stat = Statistics.new(res_path)
# stat.fill_and_save


# wc -l from_db/res/introns.csv

# 35449402

# 31499836