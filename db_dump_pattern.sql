USE test;

SELECT * INTO OUTFILE '/home/all/from_db/#/introns.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM introns;
SELECT * INTO OUTFILE '/home/all/from_db/#/exons.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM exons;
SELECT * INTO OUTFILE '/home/all/from_db/#/real_exons.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM real_exons;
SELECT * INTO OUTFILE '/home/all/from_db/#/isoforms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM isoforms;
SELECT * INTO OUTFILE '/home/all/from_db/#/orphaned_cdses.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM orphaned_cdses;
SELECT * INTO OUTFILE '/home/all/from_db/#/genes.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM genes;
SELECT * INTO OUTFILE '/home/all/from_db/#/sequences.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM sequences;
SELECT * INTO OUTFILE '/home/all/from_db/#/organisms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM organisms;
SELECT * INTO OUTFILE '/home/all/from_db/#/chromosomes.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM chromosomes;
SELECT * INTO OUTFILE '/home/all/from_db/#/intron_types.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM intron_types;
SELECT * INTO OUTFILE '/home/all/from_db/#/tax_groups2.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_groups2;
SELECT * INTO OUTFILE '/home/all/from_db/#/tax_groups1.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_groups1;
SELECT * INTO OUTFILE '/home/all/from_db/#/tax_kingdoms.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM tax_kingdoms;
SELECT * INTO OUTFILE '/home/all/from_db/#/orthologous_groups.csv'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM orthologous_groups;