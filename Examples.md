# Examples

Zie [http://www.gemmaonline.nl/images/gemmaonline/f/fa/Stuf0301.pdf](http://www.gemmaonline.nl/images/gemmaonline/f/fa/Stuf0301.pdf) 
voor de beschrijving van het omgaan met historie

De voorbeelden maken gebruik van postgresql

# Aanmaken database tabellen
```postgres-sql
drop sequence if exists persoon_sequence;
drop table if exists persoon;

CREATE SEQUENCE persoon_sequence
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

SELECT pg_catalog.setval('persoon_sequence', 1000, false);

ALTER TABLE persoon_sequence OWNER TO bvpelt;

create table persoon (
	id bigint not NULL DEFAULT nextval('persoon_sequence'),
	persoonid bigint not NULL,
	volgnummer integer,
	volgnummernacorrectie integer,
	geslachtsnaam varchar(40),
	voorvoegsel varchar(12),
	voorletters varchar(12),
	geboortedatum date,
	burgerlijkestaat varchar(12),
	begingeldigheid date,
	eindgeldigheid date,
	tijdstipregistratie timestamp
);

ALTER TABLE persoon OWNER TO bvpelt;

ALTER TABLE ONLY persoon
    ADD CONSTRAINT persoon_pkey PRIMARY KEY (id);

CREATE INDEX CONCURRENTLY persoonid_idx ON persoon (persoonid);
```

# Example op grond van tabel 2.1

```postgres-sql
delete from persoon;

-- 5692  1 Poepenstaart         JP 19770807 ongehuwd 19770807
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid) values
	            (5692,       1,         'Poepenstaart',             'JP',        '1977-08-07',  'ongehuwd',       '1977-08-07'); 
-- 5692 40 Bergh        van den JP 19770807 ongehuwd 20010903
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid) values
	            (5692,      40,         'Bergh',       'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-03'); 
-- 5692 50 Bergh        van den JP 19770807 gehuwd   20050423
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid) values
	            (5692,      50,         'Bergh',       'van den',   'JP',        '1977-08-07',  'gehuwd',         '2005-04-23'); 
```
## De inhoud van tabel
```postgres-sql
select * from persoon;

  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1083 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 
 1084 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 
 1085 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 
(3 rows)
```
## De matriele historie 
```postgres-sql
select * from persoon order by begingeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1083 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 
 1084 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 
 1085 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 
(3 rows)
```
## Het huidig geldige record

```postgres-sql
select * from persoon order by begingeldigheid desc limit 1;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1085 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 
(1 row)
```

# Example op grond van tabel 2.2
```postgres-sql
delete from persoon;

-- 5692  1 Poepenstaart         JP 19770807 ongehuwd 19770807 19770815
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	            (5692,       1,         'Poepenstaart',             'JP',        '1977-08-07',  'ongehuwd',       '1977-08-07',    '1977-08-15'); 
-- 5692 10 Berg         van der JP 19770807 ongehuwd 20010903 20010910 
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	            (5692,      10,         'Berg',        'van der',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-03',    '2001-09-10'); 
-- 5692 40 Bergh        van den JP 19770807 ongehuwd 20010903 20011102
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	            (5692,      40,         'Bergh',       'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-03',    '2001-11-02'); 
-- 5692 50 Bergh        van den JP 19770807 gehuwd   20050423 20050425
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	            (5692,      50,         'Bergh',       'van den',   'JP',        '1977-08-07',  'gehuwd',         '2005-04-23',    '2005-04-25'); 
```
## De inhoud van tabel
```postgres-sql
select * from persoon;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1086 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1087 |      5692 |         10 |                       | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2001-09-10 00:00:00
 1088 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2001-11-02 00:00:00
 1089 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
(4 rows)
```
## De matriele historie 
```postgres-sql
select * from persoon order by begingeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1086 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1087 |      5692 |         10 |                       | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2001-09-10 00:00:00
 1088 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2001-11-02 00:00:00
 1089 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
(4 rows)
```
# Het huidig geldige record
```postgres-sql
select * from persoon order by begingeldigheid desc limit 1;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1089 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
(1 row)
```
# Example op grond van tabel 2.3
```postgres-sql
-- setup dataset tabel 2.3
delete from persoon;

--  1 Poepenstaart          JP 19770807 ongehuwd 19770807 19770815
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,       1,         'Poepenstaart',              'JP',        '1977-08-07',  'ongehuwd',       '1977-08-07',    '1977-08-15');
-- 10 Berg         van der  JP 19770807 ongehuwd 20010905 20010910  40
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	                (5692,      10,         'Berg',        'van der',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-09-10',        40);
-- 40 Bergh        van den  JP 19770807 ongehuwd 20010903 20011102
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,      40,         'Bergh',       'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-03',    '2001-11-02');
-- 50 Bergh        van den  JP 19770807 gehuwd   20050423 20050425
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,      50,         'Bergh',       'van den',   'JP',        '1977-08-07',  'gehuwd',         '2005-04-23',    '2005-04-25');
```
## De inhoud van tabel
```postgres-sql
select * from persoon;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1090 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1091 |      5692 |         10 |                    40 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1092 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2001-11-02 00:00:00
 1093 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
(4 rows)
```
## De matriele historie 
```postgres-sql
select * from persoon order by begingeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1090 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1092 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2001-11-02 00:00:00
 1091 |      5692 |         10 |                    40 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1093 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
(4 rows)
```
## Het huidig geldige record
```postgres-sql
select * from persoon order by begingeldigheid desc limit 1;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1093 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
(1 row)
```
# Example op grond van tabel 2.4
```postgres-sql
delete from persoon;
--  1 Poepenstaart          JP 19770807 ongehuwd 19770807 19770815
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,       1,         'Poepenstaart',              'JP',        '1977-08-07',  'ongehuwd',       '1977-08-07',    '1977-08-15');
-- 10 Berg         van der  JP 19770807 ongehuwd 20010905 20010910  20
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	                (5692,      10,         'Berg',        'van der',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-09-10',        20);
-- 20 Berg         van den  JP 19770807 ongehuwd 20010903 20011102
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,      20,         'Berg',        'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-11-02');
```
## De inhoud van tabel
```postgres-sql
select * from persoon;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1094 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1095 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1096 |      5692 |         20 |                       | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
(3 rows)
```
## De matriele historie 
```postgres-sql
select * from persoon order by begingeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1094 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1095 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1096 |      5692 |         20 |                       | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
(3 rows)

```
## Het huidig geldige record
```postgres-sql
select * from persoon where volgnummernacorrectie is null order by begingeldigheid desc limit 1;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1096 |      5692 |         20 |                       | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
(1 row)
```
# Example op grond van tabel 2.5
```postgres-sql
-- setup dataset tabel 2.5
delete from persoon;

-- 1 Poepenstaart          JP 19770807 ongehuwd 19770807 19770815
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,       1,         'Poepenstaart',             'JP',        '1977-08-07',  'ongehuwd',       '1977-08-07',    '1977-08-15');
-- 10 Berg          van der JP 19770807 ongehuwd 20010905 20010910 20
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	                (5692,      10,         'Berg',        'van der',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-09-10',        20);
-- 20 Berg          van den JP 19770807 ongehuwd 20010905 20011102 30
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	                (5692,      20,         'Berg',        'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-11-02',        30);
-- 30 Bergh         van den JP 19770807 ongehuwd 20010905 20011206 40
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	                (5692,      30,         'Bergh',       'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-12-06',        40);
-- 40 Bergh         van den JP 19770807 ongehuwd 20010903 20021007
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,      40,         'Bergh',       'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-03',    '2002-10-07');
```
## De inhoud van tabel
```postgres-sql
select * from persoon;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1097 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1098 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1099 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1100 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1101 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2002-10-07 00:00:00
(5 rows)
```
## De matriele historie 
```postgres-sql
select * from persoon order by begingeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1097 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 1977-08-15 00:00:00
 1101 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2002-10-07 00:00:00
 1098 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1099 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1100 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
(5 rows)
```
## Het huidig geldige record
```postgres-sql
select * from persoon where volgnummernacorrectie is null order by begingeldigheid desc limit 1;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1101 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 2002-10-07 00:00:00
(1 row)
```

# Example op grond van tabel 2.6
```postgres-sql
delete from persoon;
--  1 Poepenstaart   JP 19770807 ongehuwd 19770807 19770815 
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	            (5692,      1,          'Poepenstaart',             'JP',        '1997-08-07',  'ongehuwd',       '1997-08-07',    '1997-08-15'); 
-- 10 Berg                JP 19770807 ongehuwd 20010905 20010910 20
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
                    (5692,      10,         'Berg',        'van der',   'JP',        '1997-08-07',  'ongehuwd',       '2001-09-05',    '2001-09-10',        20);  
-- 20 Berg   van den JP 19770807 ongehuwd 20010905 20011102 30
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
                    (5692,      20,         'Berg',        'van den',   'JP',        '1997-08-07',  'ongehuwd',       '2001-09-05',    '2001-11-02',        30);  
-- 30 Bergh  van den JP 19770807 ongehuwd 20010905 20011206 40
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
                    (5692,      30,         'Bergh',       'van den',   'JP',        '1997-08-07',  'ongehuwd',       '2001-09-05',    '2001-12-06',        40);  
-- 40 Bergh  van den JP 19770807 ongehuwd 20010903 20021007
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
                    (5692,      40,         'Bergh',       'van den',   'JP',        '1997-08-07',  'ongehuwd',       '2001-09-03',    '2001-11-02');  
-- 50 Bergh van den JP 19770807 gehuwd 20050423 20050425 
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
                    (5692,      50,         'Bergh',       'van den',   'JP',        '1997-08-07',  'gehuwd',         '2005-04-23',    '2005-04-25');  
-- 60 Broek van den JP 19770807 gehuwd 20080301 20080307
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
                    (5692,      60,         'Broek',       'van den',   'JP',        '1997-08-07',  'gehuwd',         '2008-03-01',    '2008-03-07'); 
```
## De inhoud van tabel
```postgres-sql
select * from persoon;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1066 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1997-08-07    | ongehuwd         | 1997-08-07      |                | 1997-08-15 00:00:00
 1067 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1068 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1069 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1070 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-03      |                | 2001-11-02 00:00:00
 1071 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1997-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
 1072 |      5692 |         60 |                       | Broek         | van den     | JP          | 1997-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
(7 rows)
```
## De formele historie
```postgres-sql
select * from persoon order by tijdstipregistratie;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1066 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1997-08-07    | ongehuwd         | 1997-08-07      |                | 1997-08-15 00:00:00
 1067 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1070 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-03      |                | 2001-11-02 00:00:00
 1068 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1069 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1071 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1997-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
 1072 |      5692 |         60 |                       | Broek         | van den     | JP          | 1997-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
(7 rows)
```
## De matriele historie met correcties
```postgres-sql
select * from persoon order by begingeldigheid, eindgeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1066 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1997-08-07    | ongehuwd         | 1997-08-07      |                | 1997-08-15 00:00:00
 1070 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-03      |                | 2001-11-02 00:00:00
 1068 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1069 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1067 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1997-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1071 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1997-08-07    | gehuwd           | 2005-04-23      |                | 2005-04-25 00:00:00
 1072 |      5692 |         60 |                       | Broek         | van den     | JP          | 1997-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
(7 rows)
```
## De matriele historie zonder correcties 
Pagina 18: "Voor de records met de materiële historie is de kolom
volgnrNaCorrectie leeg en hierdoor zijn deze records eenvoudig te onderscheiden 
van de records voor de formele historie met een gevuld volgnrNaCorrectie."
```postgres-sql
select * from persoon where volgnummernacorrectie is null order by begingeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1106 |      5692 |         35 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-03     | 2002-10-07 00:00:00
 1107 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      | 2005-04-23     | 2002-10-07 00:00:00
 1110 |      5692 |         70 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2007-03-01     | 2008-06-12 00:00:00
 1111 |      5692 |         80 |                       | Werff         | van den     | JP          | 1977-08-07    | gehuwd           | 2007-03-01      | 2008-03-01     | 2008-06-13 00:00:00
 1109 |      5692 |         60 |                       | Broek         | van den     | JP          | 1977-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
(5 rows)
```
## De formele historie zonder correcties
```postgres-sql
select * from persoon where not volgnummernacorrectie is null order by tijdstipregistratie;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1102 |      5692 |          1 |                    35 | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-05     | 1997-08-15 00:00:00
 1103 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1104 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1105 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1108 |      5692 |         50 |                    70 | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2008-03-01     | 2005-04-25 00:00:00
(5 rows)
```
# Example op grond van tabel 2.7
```postgres-sql
-- setup dataset table 2.7
delete from persoon;

-- 1 Poepenstaart         JP ongehuwd 19770807 20010905 19770815  35
insert into persoon (persoonid, volgnummer, geslachtsnaam,               voorletters, burgerlijkestaat, geboortedatum, begingeldigheid, eindgeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	            (5692,      1,          'Poepenstaart',              'JP',        'ongehuwd',       '1977-08-07',  '1977-08-07',    '2001-09-05',   '1997-08-15',        35); 
-- 10 Berg         van der JP ongehuwd 20010905          20010910  20
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid,                 tijdstipregistratie, volgnummernacorrectie) values
	            (5692,     10,          'Berg',        'van der',    'JP',        'ongehuwd',       '1977-08-07',  '2001-09-05',                    '2001-09-10',        20); 
-- 20 Berg         van den JP ongehuwd 20010905          20011102  30
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid,                 tijdstipregistratie, volgnummernacorrectie) values
	            (5692,     20,          'Berg',        'van den',    'JP',        'ongehuwd',       '1977-08-07',  '2001-09-05',                    '2001-11-02',        30); 
-- 30 Bergh        van den JP ongehuwd 20010905          20011206  40
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid,                 tijdstipregistratie, volgnummernacorrectie) values
	            (5692,     30,          'Bergh',       'van den',    'JP',        'ongehuwd',       '1977-08-07',  '2001-09-05',                   '2001-12-06',         40); 
-- 35 Poepenstaart         JP ongehuwd 19770807 20010903 20021007 
insert into persoon (persoonid, volgnummer, geslachtsnaam,               voorletters, burgerlijkestaat, geboortedatum, begingeldigheid, eindgeldigheid, tijdstipregistratie) values
	            (5692,     35,          'Poepenstaart',              'JP',        'ongehuwd',       '1977-08-07',  '1977-08-07',    '2001-09-03',   '2002-10-07'); 
--40 Bergh        van den JP ongehuwd 20010903 20050423 20021007 
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid, eindgeldigheid, tijdstipregistratie) values
	            (5692,     40,          'Bergh',       'van den',    'JP',        'ongehuwd',       '1977-08-07',  '2001-09-03',    '2005-04-23',   '2002-10-07'); 
-- 50 Bergh        van den JP gehuwd   20050423 20080301 20050425 70
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid, eindgeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	            (5692,     50,          'Bergh',       'van den',    'JP',        'gehuwd',         '1977-08-07',  '2005-04-23',    '2008-03-01',   '2005-04-25',         70); 
-- 60 Broek        van den JP gehuwd   20080301          20080307
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid,                 tijdstipregistratie                       ) values
     	            (5692,     60,          'Broek',       'van den',    'JP',        'gehuwd',         '1977-08-07',  '2008-03-01',                    '2008-03-07'            ); 
-- 70 Bergh        van den JP gehuwd   20050423 20070301 20080613 
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid,eindgeldigheid,  tijdstipregistratie                       ) values
     	            (5692,     70,          'Bergh',       'van den',    'JP',        'gehuwd',         '1977-08-07',  '2005-04-23',    '2007-03-01',   '2008-06-12'            ); 
-- 80 Werff        van den JP gehuwd   20070301 20080301 20080613
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel,  voorletters, burgerlijkestaat, geboortedatum, begingeldigheid,eindgeldigheid,  tijdstipregistratie                       ) values
     	            (5692,     80,          'Werff',       'van den',    'JP',        'gehuwd',         '1977-08-07',  '2007-03-01',    '2008-03-01',   '2008-06-13'            ); 
```
## De inhoud van tabel
```postgres-sql
select * from persoon;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1056 |      5692 |          1 |                    35 | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-05     | 1997-08-15 00:00:00
 1057 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1058 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1059 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1060 |      5692 |         35 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-03     | 2002-10-07 00:00:00
 1061 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      | 2005-04-23     | 2002-10-07 00:00:00
 1062 |      5692 |         50 |                    70 | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2008-03-01     | 2005-04-25 00:00:00
 1063 |      5692 |         60 |                       | Broek         | van den     | JP          | 1977-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
 1064 |      5692 |         70 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2007-03-01     | 2008-06-12 00:00:00
 1065 |      5692 |         80 |                       | Werff         | van den     | JP          | 1977-08-07    | gehuwd           | 2007-03-01      | 2008-03-01     | 2008-06-13 00:00:00
(10 rows)
```

## De formele historie
```postgres-sql
select * from persoon order by tijdstipregistratie;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1056 |      5692 |          1 |                    35 | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-05     | 1997-08-15 00:00:00
 1057 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1058 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1059 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1060 |      5692 |         35 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-03     | 2002-10-07 00:00:00
 1061 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      | 2005-04-23     | 2002-10-07 00:00:00
 1062 |      5692 |         50 |                    70 | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2008-03-01     | 2005-04-25 00:00:00
 1063 |      5692 |         60 |                       | Broek         | van den     | JP          | 1977-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
 1064 |      5692 |         70 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2007-03-01     | 2008-06-12 00:00:00
 1065 |      5692 |         80 |                       | Werff         | van den     | JP          | 1977-08-07    | gehuwd           | 2007-03-01      | 2008-03-01     | 2008-06-13 00:00:00
(10 rows)
```
## De matriele historie met correcties
```postgres-sql
select * from persoon order by begingeldigheid, eindgeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1060 |      5692 |         35 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-03     | 2002-10-07 00:00:00
 1056 |      5692 |          1 |                    35 | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-05     | 1997-08-15 00:00:00
 1061 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      | 2005-04-23     | 2002-10-07 00:00:00
 1058 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1057 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1059 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
 1064 |      5692 |         70 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2007-03-01     | 2008-06-12 00:00:00
 1062 |      5692 |         50 |                    70 | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2008-03-01     | 2005-04-25 00:00:00
 1065 |      5692 |         80 |                       | Werff         | van den     | JP          | 1977-08-07    | gehuwd           | 2007-03-01      | 2008-03-01     | 2008-06-13 00:00:00
 1063 |      5692 |         60 |                       | Broek         | van den     | JP          | 1977-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
(10 rows)
```
## De matriele historie zonder correcties 
```postgres-sql
select * from persoon where volgnummernacorrectie is null order by begingeldigheid, eindgeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1060 |      5692 |         35 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      | 2001-09-03     | 2002-10-07 00:00:00
 1061 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      | 2005-04-23     | 2002-10-07 00:00:00
 1064 |      5692 |         70 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      | 2007-03-01     | 2008-06-12 00:00:00
 1065 |      5692 |         80 |                       | Werff         | van den     | JP          | 1977-08-07    | gehuwd           | 2007-03-01      | 2008-03-01     | 2008-06-13 00:00:00
 1063 |      5692 |         60 |                       | Broek         | van den     | JP          | 1977-08-07    | gehuwd           | 2008-03-01      |                | 2008-03-07 00:00:00
(5 rows)
```
## Alle records in materiele view op een bepaalde peildatum 2001-10-01
```postgres-sql
select * from persoon  where begingeldigheid < '2001-10-01' and (eindgeldigheid is null or eindgeldigheid > '2001-10-01') order by begingeldigheid, eindgeldigheid ;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1061 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      | 2005-04-23     | 2002-10-07 00:00:00
 1057 |      5692 |         10 |                    20 | Berg          | van der     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-09-10 00:00:00
 1058 |      5692 |         20 |                    30 | Berg          | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-11-02 00:00:00
 1059 |      5692 |         30 |                    40 | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-05      |                | 2001-12-06 00:00:00
(4 rows)
```
## Het geldig record in materiele view op een bepaalde peildatum 2001-10-01
```postgres-sql
select * from persoon  where begingeldigheid < '2001-10-01' and (eindgeldigheid is null or eindgeldigheid > '2001-10-01') and volgnummernacorrectie is null order by begingeldigheid, eindgeldigheid ;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1061 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      | 2005-04-23     | 2002-10-07 00:00:00
(1 row)
```
# Example op grond van tabel 2.8
Hierin wordt weergegeven hoe om te gaan met relaties.
Allereerst moet er een tabel gecreerd worden.
```postgres-sql
drop sequence if exists persadr_sequence;
drop table if exists persadr;

CREATE SEQUENCE persadr_sequence
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

SELECT pg_catalog.setval('persadr_sequence', 1000, false);

ALTER TABLE persadr_sequence OWNER TO bvpelt;

create table persadr (
	persadrid bigint not NULL DEFAULT nextval('persadr_sequence'),
	recordid integer,
	recordidnacorrectie integer,
	persoonid bigint not NULL,
	adresid bigint not NULL,
	beginrelatie date,
	eindrelatie date,
	tijdstipregistratie timestamp
);

ALTER TABLE persadr OWNER TO bvpelt;

ALTER TABLE ONLY persadr
    ADD CONSTRAINT perspersadr_pkey PRIMARY KEY (persadrid);

CREATE INDEX CONCURRENTLY persadr_persoonid_idx ON persadr (persoonid);
CREATE INDEX CONCURRENTLY persadr_adresid_idx ON persadr (adresid);
```
Vullen van de gegevens
```postgres-sql
-- 123 5692 456 19770708 19991108 19770815
insert into persadr (recordid, persoonid, adresid, beginrelatie, eindrelatie,  tijdstipregistratie) values
                    (123,      5692,      456,     '1977-07-08', '1999-11-08', '1977-08-15');
-- 130 5692 876 19991108          19991112 150
insert into persadr (recordid, persoonid, adresid, beginrelatie, eindrelatie,  tijdstipregistratie, recordidnacorrectie) values
                    (130,      5692,      876,     '1999-11-08', null,         '1999-11-12',        150);
-- 150 5692 877 19991108 20050601 19991208
insert into persadr (recordid, persoonid, adresid, beginrelatie, eindrelatie,  tijdstipregistratie) values
                    (150,      5692,      877,     '1999-11-08', '2005-06-01', '1999-12-08');
-- 170 5692 933 20060601          20060612
insert into persadr (recordid, persoonid, adresid, beginrelatie, eindrelatie,  tijdstipregistratie) values
                    (170,      5692,      933,     '2006-06-01', null,         '2006-06-12');
```
## De inhoud van tabel
```postgres-sql
select * from persadr;
 persadrid | recordid | recordidnacorrectie | persoonid | adresid | beginrelatie | eindrelatie | tijdstipregistratie 
-----------+----------+---------------------+-----------+---------+--------------+-------------+---------------------
      1000 |      123 |                     |      5692 |     456 | 1977-07-08   | 1999-11-08  | 1977-08-15 00:00:00
      1001 |      130 |                 150 |      5692 |     876 | 1999-11-08   |             | 1999-11-12 00:00:00
      1002 |      150 |                     |      5692 |     877 | 1999-11-08   | 2005-06-01  | 1999-12-08 00:00:00
      1003 |      170 |                     |      5692 |     933 | 2006-06-01   |             | 2006-06-12 00:00:00
(4 rows)
```
## De formele historie
```postgres-sql
select * from persadr order by tijdstipregistratie;
 persadrid | recordid | recordidnacorrectie | persoonid | adresid | beginrelatie | eindrelatie | tijdstipregistratie 
-----------+----------+---------------------+-----------+---------+--------------+-------------+---------------------
      1000 |      123 |                     |      5692 |     456 | 1977-07-08   | 1999-11-08  | 1977-08-15 00:00:00
      1001 |      130 |                 150 |      5692 |     876 | 1999-11-08   |             | 1999-11-12 00:00:00
      1002 |      150 |                     |      5692 |     877 | 1999-11-08   | 2005-06-01  | 1999-12-08 00:00:00
      1003 |      170 |                     |      5692 |     933 | 2006-06-01   |             | 2006-06-12 00:00:00
(4 rows)
```
## De matriele historie met correcties
```postgres-sql
select * from persadr order by beginrelatie, eindrelatie;
 persadrid | recordid | recordidnacorrectie | persoonid | adresid | beginrelatie | eindrelatie | tijdstipregistratie 
-----------+----------+---------------------+-----------+---------+--------------+-------------+---------------------
      1000 |      123 |                     |      5692 |     456 | 1977-07-08   | 1999-11-08  | 1977-08-15 00:00:00
      1002 |      150 |                     |      5692 |     877 | 1999-11-08   | 2005-06-01  | 1999-12-08 00:00:00
      1001 |      130 |                 150 |      5692 |     876 | 1999-11-08   |             | 1999-11-12 00:00:00
      1003 |      170 |                     |      5692 |     933 | 2006-06-01   |             | 2006-06-12 00:00:00
(4 rows)
```
## Huidige waarde voor de relatie
```postgres-sql
select * from persadr where recordidnacorrectie is null order by beginrelatie desc limit 1;
 persadrid | recordid | recordidnacorrectie | persoonid | adresid | beginrelatie | eindrelatie | tijdstipregistratie 
-----------+----------+---------------------+-----------+---------+--------------+-------------+---------------------
      1003 |      170 |                     |      5692 |     933 | 2006-06-01   |             | 2006-06-12 00:00:00
(1 row)
```
# Adres gegevens
Deze zijn te vinden op pagina 13

```postgres-sql
drop sequence if exists adres_sequence;
drop table if exists adres;

CREATE SEQUENCE adres_sequence
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

SELECT pg_catalog.setval('adres_sequence', 1000, false);

ALTER TABLE adres_sequence OWNER TO bvpelt;

create table adres (
	adrid bigint not NULL DEFAULT nextval('adres_sequence'),
	adresid bigint not NULL,
	volgnummer integer,
	volgnummernacorrectie integer,
	straat varchar(24),
	huisnummer int,
	huisnummertoevoeging char(4),
	postcode char(6),
	woonplaats varchar(48),
	begingeldigheid date,
	eindgeldigheid date,
	tijdstipregistratie timestamp
);

ALTER TABLE adres OWNER TO bvpelt;

ALTER TABLE ONLY adres
    ADD CONSTRAINT adres_adrid_pkey PRIMARY KEY (adrid);

CREATE INDEX CONCURRENTLY adres_adresid_idx ON persadr (adresid);
```


## Vullen van de data
```postgres-sql

-- pagina 13
-- adresid, volgnummer, volgnummernacorrectie, straat,         huisnummer, huisnummertoevoeging, postcode, woonplaats, begingeldigheid, eindgeldigheid, tijdstipregistratie
--  456        10                              Beatrixstraat    105                              5686 AF   Nuenen      1990-01-01                       2001-02-01
--  876        10                              Vallestap        32                               5654 BX   Nuenen      1990-01-01                       2001-02-01
--  877        10                              Vallestap        33                               5654 BX   Nuenen      1990-01-01                       2001-02-01
--  880        10                              Vallestap        64                               5654 BX   Nuenen      1990-01-01                       2001-02-01
--  880        10                              Vallestap        65                               5654 BX   Nuenen      1990-01-01                       2001-02-01
--  933        10                              Donk             24                               5612 BF   Eindhoven   1990-01-01                       2001-01-01
--  934        10                              Donk             19      
                         5612 BF   Eindhoven   1990-01-01                       2001-01-01
insert into adres (adresid, volgnummer, straat,          huisnummer, postcode, woonplaats,  begingeldigheid, tijdstipregistratie) values
                  (456,     10,         'Beatrixstraat', 105,        '5686AF', 'Nuenen',    '1960-01-01',    '2001-02-01');
insert into adres (adresid, volgnummer, straat,          huisnummer, postcode, woonplaats,  begingeldigheid, tijdstipregistratie) values
                  (876,     10,         'Vallestap',     32,         '5654BX', 'Nuenen',    '1965-01-01',    '2001-02-01');
insert into adres (adresid, volgnummer, straat,          huisnummer, postcode, woonplaats,  begingeldigheid, tijdstipregistratie) values
                  (877,     10,         'Vallestap',     33,         '5654BX', 'Nuenen',    '1965-01-01',    '2001-02-01');
insert into adres (adresid, volgnummer, straat,          huisnummer, postcode, woonplaats,  begingeldigheid, eindgeldigheid, tijdstipregistratie) values
                  (880,     10,         'Vallestap',     64,         '5654BX', 'Nuenen',    '1965-01-01',    '2007-05-10', '2007-05-10');
insert into adres (adresid, volgnummer, straat,          huisnummer, postcode, woonplaats,  begingeldigheid, tijdstipregistratie) values
                  (880,     10,         'Vallestap',     65,         '5654BX', 'Nuenen',    '2007-05-10',    '2007-08-12');
insert into adres (adresid, volgnummer, straat,          huisnummer, postcode, woonplaats,  begingeldigheid, tijdstipregistratie) values
                  (933,     10,         'Donk',          24,         '5612BF', 'Eindhoven', '1970-01-01',    '2001-02-01');
insert into adres (adresid, volgnummer, straat,          huisnummer, postcode, woonplaats,  begingeldigheid, tijdstipregistratie) values
                  (934,     10,         'Donk',          19,         '5612BF', 'Eindhoven', '1970-01-01',    '2001-02-01');
```
