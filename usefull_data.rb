scp eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/organisms/Anolis_carolinensis.tar.gz Anolis_carolinensis

ssh jleech@212.47.226.240

Apis_mellifera

--------------------------------

scp test_fill eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/test_fill
scp db_dump.sql eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/db_dump.sql

scp eveleech@server4.lpm.org.ru:/tmp/from_db.tar.gz from_db.tar.gz

mysql < /home/introns/src/introns-db-fill/create_database.sql
./test_fill
ls -l /home/ipoverennaya/introns/input/*.log
rm /tmp/from_db/Anolis_carolinensis/*
mysql --user=root < /home/introns/ftp_loader/db_dump.sql
du -h /tmp/from_db/

cd /tmp/from_db
tar -zcvf Anolis_carolinensis.tar.gz Anolis_carolinensis

scp eveleech@server4.lpm.org.ru:/tmp/from_db/Anolis_carolinensis.tar.gz Anolis_carolinensis.tar.gz
tar xvzf Anolis_carolinensis.tar.gz Anolis_carolinensis
rm -rf Anolis_carolinensis.tar.gz

-------------------------------
ruby id_fixer.rb
-------------------------------

rails server --binding=0.0.0.0

tar -zcvf from_db.tar.gz from_db

scp create_database.sql eveleech@server4.lpm.org.ru:/home/introns/src/introns-db-fill/create_database.sql

tar -zcvf res.tar.gz res
scp res.tar.gz jleech@212.47.226.240:/home/jleech/res.tar.gz

scp create_database.sql jleech@212.47.226.240:/home/jleech/create_database.sql
scp append_tables.sql jleech@212.47.226.240:/home/jleech/append_tables.sql
scp intron_types.csv jleech@212.47.226.240:/home/jleech/res/intron_types.csv 

scp organisms.csv jleech@212.47.226.240:/home/jleech/fuck_your_mom_apps/postgres_data/organisms.csv

scp eveleech@server4.lpm.org.ru:/home/ipoverennaya/introns/input/Papio_anubis/Papio_anubis_NC_018169.1.gbk Papio_anubis_NC_018169.1.gbk

tar xvzf res.tar.gz res


psql --host=localhost  --dbname=test --username=postgres --file=create_database.sql
psql --host=localhost  --dbname=test --username=postgres --file=append_tables.sql
psql -h localhost test postgres
\i append_tables.sql


-------------------------------

redis-cli KEYS "Homo_sapiens*" | xargs redis-cli DEL

scp eveleech@server4.lpm.org.ru:/tmp/from_db/intron_types.csv intron_types.csv

"/home/introns/ftp_loader/organisms/Anolis_carolinensis.bio", "/home/introns/ftp_loader/organisms/Mus_musculus.bio", "/home/introns/ftp_loader/organisms/Musa_acuminata.bio", "/home/introns/ftp_loader/organisms/Homo_sapiens.bio", "/home/introns/ftp_loader/organisms/Apis_mellifera.bio"

declare -a FILES=( "/home/introns/ftp_loader/organisms/Mus_musculus.bio")


scp eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/organisms/Mus_musculus/mm_ref_GRCm38.p4_chr10.gbk mm_ref_GRCm38.p4_chr10.gbk

scp eveleech@server4.lpm.org.ru:/home/all/from_db.tar.gz from_db.tar.gz




sed -n 470,487p /home/introns/from_server2/input/Mus_musculus/mm_ref_GRCm38.p3_chrMT.gbk
sed -n 470,487p /home/introns/ftp_loader/organisms/Mus_musculus/mm_ref_GRCm38.p4_chrMT.gbk 

tar -zcvf from_db.tar.gz from_db - make archive
tar xvzf from_db.tar.gz from_db - decompress

sed -n 677610,677612p /home/eve/Documents/introns_postgres/genes_fulltext.csv
wc -l /home/eve//Documents/introns_postgres/from_db/Anolis_carolinensis/isoforms.csv
52815
wc -l /home/eve//Documents/introns_postgres/from_db/Anolis_carolinensis/introns.csv
374473

sed -n 132940,133000p /home/ipoverennaya/introns/input/Anolis_carolinensis/Anolis_carolinensis_NC_014778.1.gbk

grep -n "1054178" "/home/ipoverennaya/introns/input/Anolis_carolinensis/Anolis_carolinensis_NC_014778.1.gbk"
grep -n "GI:1033371415" *

sed -n 4940923,4941000p acr_ref_AnoCar2.0_chrUn.gbk

grep -n "complement(join(1054177,1058015..1058108," "/home/ipoverennaya/introns/input/Anolis_carolinensis/acr_ref_AnoCar2.0_chrUn.gbk"

declare -a FILES=("/home/ipoverennaya/introns/input/Anolis_carolinensis.bio")

copy genes from '/home/eve/Documents/introns_postgres/from_db/res/genes.csv' WITH DELIMITER AS ',' CSV;

scp /home/eve/Documents/introns_postgres/from_db/res/genes.csv jleech@212.47.226.240:/home/jleech/fuck_your_mom_apps/postgres_data/genes.csv
scp /home/eve/Documents/introns_postgres/genes_fulltext.csv jleech@212.47.226.240:/home/jleech/fuck_your_mom_apps/postgres_data/genes_fulltext.csv
scp /home/eve/Documents/introns_postgres/genes_ncbi_ids.csv jleech@212.47.226.240:/home/jleech/fuck_your_mom_apps/postgres_data/genes_ncbi_ids.csv


folders = ["Ziziphus_jujuba","Zea_mays","Xenopus_tropicalis","Xenopus_laevis","Vitis_vinifera","Vigna_radiata","Vigna_angularis","Tribolium_castaneum","Theobroma_cacao","Takifugu_rubripes","Taeniopygia_guttata","Sus_scrofa","Solanum_pennellii","Solanum_lycopersicum","Setaria_italica","Sesamum_indicum","Salmo_salar","Rattus_norvegicus","Prunus_mume","Pongo_abelii","Poecilia_reticulata","Parus_major","Papio_anubis","Pan_troglodytes","Pan_paniscus","Ovis_aries","Oryzias_latipes","Oryza_brachyantha","Oryctolagus_cuniculus","Ornithorhynchus_anatinus","Oreochromis_niloticus","Nothobranchius_furzeri","Nomascus_leucogenys","Nicotiana_attenuata","Nasonia_vitripennis","Mus_musculus","Musa_acuminata","Monodelphis_domestica","Microtus_ochrogaster","Meleagris_gallopavo","Malus_domestica","Macaca_mulatta"]
folders.each do | name|
    `tar -zcvf /home/eveleech/db_dump/#{name}.tar.gz #{name}`
end

folders = ["Anolis_carolinensis","Apis_mellifera","Arachis_duranensis","Arachis_ipaensis","Beta_vulgaris","Bombus_terrestris","Bos_indicus","Bos_taurus","Brachypodium_distachyon","Brassica_napus","Brassica_oleracea","Brassica_rapa","Callithrix_jacchus","Camelina_sativa","Canis_lupus","Capra_hircus","Capsicum_annuum","Chlorocebus_sabaeus","Chrysemys_picta","Cicer_arietinum","Ciona_intestinalis","Citrus_sinensis","Coturnix_japonica","Cucumis_sativus","Cynoglossus_semilaevis","Cyprinus_carpio","Danio_rerio","Daucus_carota","Drosophila_busckii","Drosophila_miranda","Elaeis_guineensis","Equus_caballus","Esox_lucius","Felis_catus","Ficedula_albicollis","Fragaria_vesca","Gallus_gallus","Glycine_max","Gorilla_gorilla","Gossypium_arboreum","Gossypium_hirsutum","Gossypium_raimondii","Homo_sapiens","Ictalurus_punctatus","Lepisosteus_oculatus","Lupinus_angustifolius","Macaca_fascicularis","Macaca_mulatta","Malus_domestica","Meleagris_gallopavo","Microtus_ochrogaster","Monodelphis_domestica","Musa_acuminata","Mus_musculus","Nasonia_vitripennis","Nicotiana_attenuata","Nomascus_leucogenys","Nothobranchius_furzeri","Oreochromis_niloticus","Ornithorhynchus_anatinus","Oryctolagus_cuniculus","Oryza_brachyantha","Oryza_sativa","Oryzias_latipes","Ovis_aries","Pan_paniscus","Pan_troglodytes","Papio_anubis","Parus_major","Poecilia_reticulata","Pongo_abelii","Prunus_mume","Rattus_norvegicus","Salmo_salar","Sesamum_indicum","Setaria_italica","Solanum_lycopersicum","Solanum_pennellii","Sus_scrofa","Taeniopygia_guttata","Takifugu_rubripes","Theobroma_cacao","Tribolium_castaneum","Vigna_angularis","Vigna_radiata","Vitis_vinifera","Xenopus_laevis","Xenopus_tropicalis","Zea_mays","Ziziphus_jujuba"]
folders.each do | name|
	`mkdir #{name}`
end

organisms = ["Macaca_mulatta","Malus_domestica","Meleagris_gallopavo","Microtus_ochrogaster","Monodelphis_domestica","Musa_acuminata","Mus_musculus","Nasonia_vitripennis","Nicotiana_attenuata","Nomascus_leucogenys","Nothobranchius_furzeri","Oreochromis_niloticus","Ornithorhynchus_anatinus","Oryctolagus_cuniculus","Oryza_brachyantha","Oryza_sativa","Oryzias_latipes","Ovis_aries","Pan_paniscus","Pan_troglodytes","Papio_anubis","Parus_major","Poecilia_reticulata","Pongo_abelii","Prunus_mume","Rattus_norvegicus","Salmo_salar","Sesamum_indicum","Setaria_italica","Solanum_lycopersicum","Solanum_pennellii","Sus_scrofa","Taeniopygia_guttata","Takifugu_rubripes","Theobroma_cacao","Tribolium_castaneum","Vigna_angularis","Vigna_radiata","Vitis_vinifera","Xenopus_laevis","Xenopus_tropicalis","Zea_mays","Ziziphus_jujuba"]

organisms.each do |org_name|
    puts "loading #{org_name}"
    `mysql < /home/introns/src/introns-db-fill/create_database.sql`    
    puts "db_cleared"
    t1 = Time.now
    `/home/introns/ftp_loader/test_fils/#{org_name}`
    t2 = Time.now
    puts "load time: #{t2-t1}"
    `rm /tmp/from_db/#{org_name}/*`
    puts "folder cleared"
    `mysql --user=root < /home/introns/ftp_loader/db_dumps/#{org_name}.sql`
    puts "db dumped"
    puts "---------"
end


scp /home/eve/Documents/introns_postgres/intron_types.csv jleech@212.47.226.240:/home/jleech/fuck_your_mom_apps/postgres_data/intron_types.csv
copy intron_types from '/home/jleech/fuck_your_mom_apps/postgres_data/intron_types.csv' WITH DELIMITER AS ',' CSV;