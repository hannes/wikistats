drop view weekcountenfsmart;
drop table weekcountenfid;
drop table pagenames;
drop table pagessuggest;

create table pagenames as (select distinct lang,page from weekcountenf) with data;
alter table pagenames add column id int not null auto_increment;

create table weekcountenfid as (select id,"year","week","count" from weekcountenf join pagenames on weekcountenf.lang = pagenames.lang and weekcountenf.page=pagenames.page) with data;

create view weekcountenfsmart as select "lang","page","year","week","count" from weekcountenfid join pagenames on weekcountenfid.id=pagenames.id;

create table pagessuggest as (select lang,page,countsum from pagenames join (select id,sum("count") as countsum from weekcountenfid group by id) as countids on pagenames.id=countids.id) with data;
