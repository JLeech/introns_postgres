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

DROP database template0 - удалить базу
alter database template1 is_template false; - снять шаблонность с базы

psql --host=localhost  --dbname=test --username=postgres --password --file=create_database.sql создать таблицы

psql --host=localhost  --dbname=test --username=postgres --password --file=append_tables.sql

scp eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/organisms/Anolis_carolinensis.tar.gz Anolis_carolinensis

ssh jleech@212.47.226.240

/usr/share/webapps/adminer/index.php

Apis_mellifera

--------------------------------

scp test_fill eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/test_fill
scp db_dump.sql eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/db_dump.sql

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

scp create_database.sql eveleech@server4.lpm.org.ru:/home/introns/src/introns-db-fill/create_database.sql

tar -zcvf res.tar.gz res
scp res.tar.gz jleech@212.47.226.240:/home/jleech/res.tar.gz

scp create_database.sql jleech@212.47.226.240:/home/jleech/create_database.sql
scp append_tables.sql jleech@212.47.226.240:/home/jleech/append_tables.sql

tar xvzf res.tar.gz res


psql --host=localhost  --dbname=introns --username=introns --file=create_database.sql
sudo -u postgres psql
\connect introns
\i append_tables.sql


-------------------------------

redis-cli KEYS "Homo_sapiens*" | xargs redis-cli DEL

scp eveleech@server4.lpm.org.ru:/tmp/from_db/intron_types.csv intron_types.csv

"/home/introns/ftp_loader/organisms/Apis_mellifera.bio" 

"/home/introns/ftp_loader/organisms/Anolis_carolinensis.bio", "/home/introns/ftp_loader/organisms/Mus_musculus.bio", "/home/introns/ftp_loader/organisms/Musa_acuminata.bio", "/home/introns/ftp_loader/organisms/Homo_sapiens.bio", "/home/introns/ftp_loader/organisms/Apis_mellifera.bio"

declare -a FILES=( "/home/introns/ftp_loader/organisms/Mus_musculus.bio")



/home/introns/ftp_loader/organisms/Mus_musculus/mm_ref_GRCm38.p4_chr10.gbk

scp eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/organisms/Mus_musculus/mm_ref_GRCm38.p4_chr10.gbk mm_ref_GRCm38.p4_chr10.gbk



GRANT ALL PRIVILEGES ON origin.* TO 'introns'@'%' WITH GRANT OPTION;

SELECT COUNT(*) FROM genes WHERE id_organisms IN 
   (SELECT id FROM organisms WHERE common_name = 'human')


SELECT COUNT(t.*) FROM genes AS t 
   INNER JOIN organisms AS org
   ON t.id_organisms = org.id AND org.common_name = 'human'

sed -n 470,487p /home/introns/from_server2/input/Mus_musculus/mm_ref_GRCm38.p3_chrMT.gbk
sed -n 470,487p /home/introns/ftp_loader/organisms/Mus_musculus/mm_ref_GRCm38.p4_chrMT.gbk 