psql mydb - enter mydb database

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

psql --host=localhost  --dbname=test --username=pg --password --file=create_database.sql создать таблицы

scp eveleech@server4.lpm.org.ru:/home/introns/ftp_loader/organisms/chrs.txt chrs.txt
