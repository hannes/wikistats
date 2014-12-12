drop table weekcountenf;
CREATE TABLE "sys"."weekcountenf" (
	"lang"  VARCHAR(2),
	"page"  VARCHAR(200),
	"year"  INT,
	"week"  INT,
	"count" BIGINT
);
copy into weekcountenf from '/export/scratch1/wikistats/data/wikistats-2008-enf.csv.bz2' using delimiters ',','\n','\"' locked;
copy into weekcountenf from '/export/scratch1/wikistats/data/wikistats-2009-enf.csv.bz2' using delimiters ',','\n','\"' locked;
copy into weekcountenf from '/export/scratch1/wikistats/data/wikistats-2010-enf.csv.bz2' using delimiters ',','\n','\"' locked;
copy into weekcountenf from '/export/scratch1/wikistats/data/wikistats-2011-enf.csv.bz2' using delimiters ',','\n','\"' locked;
copy into weekcountenf from '/export/scratch1/wikistats/data/wikistats-2012-enf.csv.bz2' using delimiters ',','\n','\"' locked;
copy into weekcountenf from '/export/scratch1/wikistats/data/wikistats-2013-enf.csv.bz2' using delimiters ',','\n','\"' locked;
copy into weekcountenf from '/export/scratch1/wikistats/data/wikistats-2014-enf.csv.bz2' using delimiters ',','\n','\"' locked;

