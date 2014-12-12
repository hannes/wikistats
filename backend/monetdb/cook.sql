drop view weekcountenfsmart;
drop table pagenames;
drop table pagessuggest;
drop table weekcountenfid;

create table pagenames as select page_id as id, page_title as page from page 
	where page_namespace=0 and page_is_redirect=0 with data;

create table weekcountenfid as 
select real_page_id as id, "year", week, sum(count) as count from (
	select page_id, page_is_redirect, case when page_is_redirect = 0 THEN page_id ELSE rd_to END as real_page_id, "year", week, count from (
		select page_id, page_is_redirect, "year" , week, count from weekcountenf join page on page=page_title and page_namespace=0) as withids 
	left join (
		select rd_from, page_id as rd_to from redirect join page on rd_title=page_title and rd_namespace=page_namespace) as redirectid on page_id=rd_from) as withredirects 
where real_page_id is not null 
group by real_page_id, "year", week order by real_page_id 
with data;

create view weekcountenfsmart as select 'en' as "lang","page","year","week","count" from weekcountenfid join pagenames on weekcountenfid.id=pagenames.id;

create table pagessuggest as (select 'en' as lang,page,countsum from pagenames join (select id,sum("count") as countsum from weekcountenfid group by id) as countids on pagenames.id=countids.id) with data;