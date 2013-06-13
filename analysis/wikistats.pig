-- Wikipedia Access Logs aggregator
-- data from http://dumps.wikimedia.org/other/pagecounts-raw/
--
-- Hannes Muehleisen <hannes@cwi.nl>
-- 2013-06-11
-- Pig version 0.11.1
--
-- register our udf that converts url-encoded strings to UTF-8

REGISTER 'wikistat.jar';

SET default_parallel 40;
SET job.name 'wikistats-$year';
SET mapred.max.map.failures.percent 1;

-- loading, conversions, filters
-- we need the file name as it contains the date
raw = LOAD 'hdfs:/user/hannes/wikistats/$year/*/pagecounts-*.gz' USING PigStorage(' ','-tagsource') AS (filename:chararray, lang:chararray, page:chararray, hits:long, size:long);
rawf =     FOREACH raw GENERATE filename, lang, page, hits;
onlywp =   FILTER rawf BY (NOT (lang MATCHES '.*\\..*') AND hits > 1);
decoded =  FOREACH onlywp GENERATE lang, nl.cwi.da.wikistat.UrlDecode(page) AS page, ToDate(SUBSTRING(filename,11,22),'yyyyMMdd-HH','UTC') AS date, hits; 
filtered = FILTER decoded BY NOT (page MATCHES '(.*(:|/|;|\\\\).*)');

-- groupings
basicgroup  = GROUP filtered  BY (lang, page, GetYear(date), GetMonth(date), GetWeek(date));
basiccount  = FOREACH basicgroup     GENERATE FLATTEN(group) AS (lang, page, year, month, week), SUM(filtered.hits) AS hits:long;

weekgroup = GROUP basiccount BY (lang, page, year, week);
monthgroup = GROUP basiccount BY (lang, page, year, month);
yeargroup  = GROUP basiccount BY (lang, page, year);

-- aggregations
weekcount = FOREACH weekgroup    GENERATE FLATTEN(group) AS (lang, page, year, week),       SUM(basiccount.hits) AS hits:long;
monthcount = FOREACH monthgroup    GENERATE FLATTEN(group) AS (lang, page, year, month),       SUM(basiccount.hits) AS hits:long;
yearcount  = FOREACH yeargroup     GENERATE FLATTEN(group) AS (lang, page, year),              SUM(basiccount.hits) AS hits:long;

-- write results
STORE weekcount  INTO 'hdfs:/user/hannes/results/$year/weekcount.gz'  USING PigStorage('	');
STORE monthcount INTO 'hdfs:/user/hannes/results/$year/monthcount.gz' USING PigStorage('	');
STORE yearcount  INTO 'hdfs:/user/hannes/results/$year/yearcount.gz'  USING PigStorage('	');

-- smaller result set: en and more than 1k hits
weekcountenf = FILTER weekcount BY (lang=='en' AND hits > 1000);
STORE weekcountenf  INTO 'hdfs:/user/hannes/results/$year/weekcountenf.gz'  USING PigStorage('	');