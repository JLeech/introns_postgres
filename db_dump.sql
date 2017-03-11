USE test;

SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/introns.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM introns;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/exons.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM exons;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/isoforms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM isoforms;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/orphaned_cdses.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM orphaned_cdses;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/genes.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM genes;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/sequences.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM sequences;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/organisms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM organisms;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/chromosomes.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM chromosomes;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/intron_types.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM intron_types;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/tax_groups2.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_groups2;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/tax_groups1.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_groups1;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/tax_kingdoms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_kingdoms;
SELECT * INTO OUTFILE '/tmp/from_db/Anolis_carolinensis/orthologous_groups.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM orthologous_groups;
