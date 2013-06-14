drop table pages;create table pages as (select page,sum(\"count\")  as countsum from weekcountenf group by page) with data;

create table pagenames as (select distinct page from weekcountenf) with data;
alter table pagenames add column id int not null auto_increment;

create table weekcountenfid as (select lang,id,"year","week","count" from sys.weekcountenf join pagenames on weekcountenf.page = pagenames.page) with data;

create view weekcountenfsmart as select "lang","page","year","week","count" from weekcountenfid join pagenames on weekcountenfid.id=pagenames.id;
