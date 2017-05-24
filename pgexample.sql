--
-- See http://www.gemmaonline.nl/images/gemmaonline/f/fa/Stuf0301.pdf
--
-- example in postgresql
--

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

-- setup dataset tabel 2.1

-- 5692  1 Poepenstaart         JP 19770807 ongehuwd 19770807
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid) values
	            (5692,       1,         'Poepenstaart',             'JP',        '1977-08-07',  'ongehuwd',       '1977-08-07'); 
-- 5692 40 Bergh        van den JP 19770807 ongehuwd 20010903
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid) values
	            (5692,      40,         'Bergh',       'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-03'); 
-- 5692 50 Bergh        van den JP 19770807 gehuwd   20050423
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid) values
	            (5692,      50,         'Bergh',       'van den',   'JP',        '1977-08-07',  'gehuwd',         '2005-04-23'); 
-- inhoud van tabel
select * from persoon;

-- matriele historie 
select * from persoon order by begingeldigheid;
woz=> select * from persoon order by begingeldigheid;
  id  | persoonid | volgnummer | volgnummernacorrectie | geslachtsnaam | voorvoegsel | voorletters | geboortedatum | burgerlijkestaat | begingeldigheid | eindgeldigheid | tijdstipregistratie 
------+-----------+------------+-----------------------+---------------+-------------+-------------+---------------+------------------+-----------------+----------------+---------------------
 1083 |      5692 |          1 |                       | Poepenstaart  |             | JP          | 1977-08-07    | ongehuwd         | 1977-08-07      |                | 
 1084 |      5692 |         40 |                       | Bergh         | van den     | JP          | 1977-08-07    | ongehuwd         | 2001-09-03      |                | 
 1085 |      5692 |         50 |                       | Bergh         | van den     | JP          | 1977-08-07    | gehuwd           | 2005-04-23      |                | 
(3 rows)

-- huidig geldige record
select * from persoon order by begingeldigheid desc limit 1;

-- setup dataset tabel 2.2
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
-- inhoud van tabel
select * from persoon;

-- matriele historie 
select * from persoon order by begingeldigheid;

-- huidig geldige record
select * from persoon order by begingeldigheid desc limit 1;

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

-- inhoud van de tabel
select * from persoon;
-- De matriele historie
select * from persoon order by begingeldigheid;
-- Het huidig geldige record
select * from persoon order by begingeldigheid desc limit 1;

-- setup dataset tabel 2.4
delete from persoon;
--  1 Poepenstaart          JP 19770807 ongehuwd 19770807 19770815
insert into persoon (persoonid, volgnummer, geslachtsnaam,              voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,       1,         'Poepenstaart',             'JP',        '1977-08-07',  'ongehuwd',       '1977-08-07',    '1977-08-15');
-- 10 Berg         van der  JP 19770807 ongehuwd 20010905 20010910  20
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie, volgnummernacorrectie) values
	                (5692,      10,         'Berg',        'van der',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-09-10',        20);
-- 20 Berg         van den  JP 19770807 ongehuwd 20010903 20011102
insert into persoon (persoonid, volgnummer, geslachtsnaam, voorvoegsel, voorletters, geboortedatum, burgerlijkestaat, begingeldigheid, tijdstipregistratie) values
	                (5692,      20,         'Berg',        'van den',   'JP',        '1977-08-07',  'ongehuwd',       '2001-09-05',    '2001-11-02');
-- inhoud van de tabel
select * from persoon;
-- De matriele historie
select * from persoon order by begingeldigheid;
-- Het huidig geldige record
select * from persoon where volgnummernacorrectie is null order by begingeldigheid desc limit 1;

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
select * from persoon;
-- De matriele historie
select * from persoon order by begingeldigheid;
-- Het huidig geldige record
select * from persoon where volgnummernacorrectie is null order by begingeldigheid desc limit 1;


-- setup dataset tabel 2.6
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
-- inhoud van tabel
select * from persoon;

-- formele historie
select * from persoon order by tijdstipregistratie;

-- matriele historie met correcties
select * from persoon order by begingeldigheid, eindgeldigheid;

-- matriele historie zonder correcties 
select * from persoon where volgnummernacorrectie is null order by begingeldigheid, eindgeldigheid;

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

-- inhoud van tabel
select * from persoon;

-- formele historie
select * from persoon order by tijdstipregistratie;

-- matriele historie met correcties
select * from persoon order by begingeldigheid, eindgeldigheid;

-- matriele historie zonder correcties 
select * from persoon where volgnummernacorrectie is null order by begingeldigheid, eindgeldigheid;

-- alle records in materiele view op een bepaalde peildatum 2001-10-01
select * from persoon  where begingeldigheid < '2001-10-01' and (eindgeldigheid is null or eindgeldigheid > '2001-10-01') order by begingeldigheid, eindgeldigheid ;

-- geldig record in materiele view op een bepaalde peildatum 2001-10-01
select * from persoon  where begingeldigheid < '2001-10-01' and (eindgeldigheid is null or eindgeldigheid > '2001-10-01') and volgnummernacorrectie is null order by begingeldigheid, eindgeldigheid ;


 

