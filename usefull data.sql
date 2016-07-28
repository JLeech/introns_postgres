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

\d - show tables
\l - show databases
\d tablename - show table

mysql < /home/introns/src/introns-db-fill/create_database.sql 

62.325357156
63.086076135
61.1627809
61.231626229
61.743270996
65.619521661
65.335869113
65.610424028
65.500478927
66.145599406
65.520905505
66.0982881
65.188225304
67.315481278
66.426223683
65.686573267
65.392678879
65.650356049
65.545458462
65.332289702
66.170902836
67.565894219
65.32341517
67.848249146
67.455438885
64.474841684
63.720342573
66.088418705
63.86995224
64.441304196
64.729441846
69.492770865
67.720619926
64.504311154
64.101063941
70.686779061
70.585287035
63.703333371
63.598178177
63.461658352