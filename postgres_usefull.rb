=> \i basics.sql read commands from basics.sql

CREATE TABLE weather (
    city            varchar(80),
    temp_lo         int,           -- low temperature
    temp_hi         int,           -- high temperature
    prcp            real,          -- precipitation
    date            date
);
DROP TABLE weather;

INSERT INTO weather VALUES ('San Francisco', 46, 50, 0.25, '1994-11-27');

INSERT INTO weather (city, temp_lo, temp_hi, prcp, date)
    VALUES ('San Francisco', 43, 57, 0.0, '1994-11-29');

COPY weather FROM '/home/user/weather.txt';  - массовая загрузка из файла

\d - таблицы
\l - базы
\d tablename - таблицы базы

mysql < /home/introns/src/introns-db-fill/create_database.sql 

sudo -u postgres psql - от рута

psql -h localhost test postgres - c админскими правами
psql -h localhost test pg - обычно

pg_dump test -h localhost --username=postgres --password > db.sql

DROP database template0 - удалить базу
alter database template1 is_template false; - снять шаблонность с базы

psql --host=localhost  --dbname=test --username=postgres --password --file=create_database.sql создать таблицы

psql --host=localhost  --dbname=test --username=postgres --password --file=append_tables.sql filling table

copy organisms from '/home/jleech/fuck_your_mom_apps/postgres_data/organisms.csv' WITH DELIMITER AS ',' CSV;


psql --host=localhost  --dbname=test --username=postgres --file=create_database.sql
sudo -u postgres psql || psql -h localhost test postgres
\connect introns
\i append_tables.sql

GRANT ALL PRIVILEGES ON origin.* TO 'introns'@'%' WITH GRANT OPTION;

SELECT COUNT(*) FROM genes WHERE id_organisms IN 
   (SELECT id FROM organisms WHERE common_name = 'human')


SELECT COUNT(t.*) FROM genes AS t 
   INNER JOIN organisms AS org
   ON t.id_organisms = org.id AND org.common_name = 'human'

copy genes_orgs from '/home/eve/Documents/introns_postgres/genes_fulltext.csv' WITH DELIMITER AS ',' CSV;

copy genes_orgs from '/home/jleech/fuck_your_mom_apps/postgres_data/genes_fulltext.csv' WITH DELIMITER AS ',' CSV;
CREATE INDEX genes_orgs_pattern_index ON genes_orgs USING GIN(name gin_trgm_ops);

CREATE INDEX gene_introns_count ON genes (max_introns_count);

DROP TABLE IF EXISTS report

CREATE TABLE report(
    id INT UNIQUE NOT NULL,
    uid VARCHAR(15) UNIQUE NOT NULL,
    start_time TIMESTAMP,
    state VARCHAR(20),
    result_path VARCHAR(100),
    type VARCHAR(10),
    request TEXT,
    error_text TEXT,
    load_times INT,
    email TEXT
);

 TIMESTEMP: 1999-01-08 04:05:06 -8:00

copy genes_ncbis from '/home/eve/Documents/introns_postgres/genes_ncbi_ids.csv' WITH DELIMITER AS ',' CSV;

copy genes_ncbis from '/home/jleech/fuck_your_mom_apps/postgres_data/genes_ncbi_ids.csv' WITH DELIMITER AS ',' CSV;
CREATE INDEX genes_ncbi_pattern_index ON genes_ncbis USING GIN(ncbi_id gin_trgm_ops);


CREATE INDEX exon_gene_id ON exons (id_genes);
CREATE INDEX introns_gene_id ON introns (id_genes);
CREATE INDEX isoforms_gene_id ON isoforms (id_genes);


ALTER TABLE exons ADD COLUMN main_error BOOLEAN DEFAULT FALSE;
ALTER TABLE introns ADD COLUMN main_error BOOLEAN DEFAULT FALSE;
ALTER TABLE isoforms ADD COLUMN main_error BOOLEAN DEFAULT FALSE;

SELECT genes.id_organisms,count(genes.id_organisms) FROM genes,introns WHERE ((max_introns_count < 50) AND 
    (id_organisms = 1 OR id_organisms = 2 OR id_organisms = 3 OR id_organisms = 5 OR id_organisms = 6 OR id_organisms = 7 OR id_organisms = 8 OR id_organisms = 9 OR id_organisms = 4) AND (introns.id_genes = genes.id)) GROUP BY genes.id_organisms

psql -d test -f db.sql