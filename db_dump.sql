USE test;

SELECT * INTO OUTFILE '/home/all/from_db/XXX/introns.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM introns;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/exons.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM exons;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/real_exons.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM real_exons;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/isoforms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM isoforms;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/orphaned_cdses.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM orphaned_cdses;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/genes.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM genes;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/sequences.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM sequences;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/organisms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM organisms;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/chromosomes.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM chromosomes;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/intron_types.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM intron_types;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/tax_groups2.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_groups2;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/tax_groups1.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_groups1;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/tax_kingdoms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_kingdoms;
SELECT * INTO OUTFILE '/home/all/from_db/XXX/orthologous_groups.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM orthologous_groups;