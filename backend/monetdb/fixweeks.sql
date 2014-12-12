-- fix shorter weeks
-- first and last week in year may be shorter
--First Week Days
--2008: 6
UPDATE weekcountenf SET "count"="count"*1.14 where "year"=2008 and "week"=1;
--2009: 4
UPDATE weekcountenf SET "count"="count"*1.42 where "year"=2009 and "week"=1;
--2010: 6
UPDATE weekcountenf SET "count"="count"*1.14 where "year"=2010 and "week"=1;
--2011: 7
--2012: 7
--2013: 6
UPDATE weekcountenf SET "count"="count"*1.14 where "year"=2013 and "week"=1;

--Last Week Days
--2008: 7 (52)
--2009: 4 (53)
UPDATE weekcountenf SET "count"="count"*1.42 where "year"=2009 and "week"=53;
--2010: 5 (52)
UPDATE weekcountenf SET "count"="count"*1.28 where "year"=2010 and "week"=52;
--2011: 6 (52)
UPDATE weekcountenf SET "count"="count"*1.14 where "year"=2011 and "week"=52;
--2012: 7 (52)
--2013: 7 (52)


