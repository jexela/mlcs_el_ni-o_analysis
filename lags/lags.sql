--Calculation of correlation coefficients of different time lags (between 1-12 months)
--Preparing table for calculations:

DROP TABLE IF EXITS data;

CREATE TABLE data (id,month,year,date,longditude,laditude,average_monthly_precipitation,long_term_month_average,percipitation_anomaly,oni) as

WITH temp as (
		SELECT p.id, 
		EXTRACT(MONTH FROM p.date) as month,
		EXTRACT(YEAR FROM p.date) as year, p.date, 
		p.longditude, p.laditude, 
		p.average_monthly_precipitation
		FROM precipitation_worldwide as p ORDER BY p.id),--LIMIT 100 OFFSET 100000;

--Calculate long term month precipitation averages 1981-2010 precipitation for every location
	 averages as (
		SELECT t.month, t.longditude, t.laditude, AVG(t.average_monthly_precipitation) as long_term_month_average
		FROM temp as t 
		WHERE t.year BETWEEN 1981 AND 2010
		GROUP BY t.month,t.longditude,t.laditude
		ORDER BY t.month),
--Calculate precipitation anomolies for each location by subtracting long term month precipitation averages (1979-2021) from measured averaged precipitation 
	anomalies as (
		SELECT t.*, a.long_term_month_average, t.average_monthly_precipitation-a.long_term_month_average as percipitation_anomaly
		FROM averages as a, temp as t 
		WHERE a.month = t.month AND a.longditude = t.longditude AND a.laditude = t.laditude
		ORDER BY t.id),
--Join precipitation anamolies table with oci index table to match every location with the corresponding oci values
	oni as(
		SELECT a.*,e.oni
		FROM anomalies as a, enso_events as e
		WHERE a.month = e.month AND a.year = e.year)

SELECT * FROM data as d ORDER BY d.longditude,d.laditude,d.month,d.year;

--Creation of different time lags with the help of window functions

CREATE TABLE timelags (month,year,date,longditude,laditude,oni,lagged_anomoly,following_date,lag) as (
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 1 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 2 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 3 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 4 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 4 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 5 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 6 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 6 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 7 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 8 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 8 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 9 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 9 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 10 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 10 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 11 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 11 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude,d.oni,LAST_VALUE(d.percipitation_anomaly) over win as "lagged anomaly", LAST_VALUE(d.date) over win as "following date", 12 as "lag"
FROM data as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 12 FOLLOWING)
);

--Corrected version with 63078912-((1+2+3+4+5+6+7+8+9+10+11+12)*10368)=62270208 rows, as the number of data points decreases with each lag.

CREATE TABLE lags (month,year,date,longditude,laditude,oni,lagged_anomoly,following_date,lag) as (
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 1 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 2 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 3 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 4 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 4 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 5 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 6 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 6 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 7 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 8 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 8 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 9 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 9 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 10 
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 10 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 11
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 11 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
UNION
SELECT *
FROM (
SELECT t.*, COUNT(*) OVER WIN as "window_length"
FROM timelags as t 
WHERE t.lag = 12
WINDOW win AS (PARTITION BY t.longditude,t.laditude,t.lag ORDER BY t.date ROWS BETWEEN CURRENT ROW AND 12 FOLLOWING)
) as lags
WHERE lags.window_length-1=lags.lag
);

--Creation of an index in the form of a B + tree in order to be able to go through the millions of entries faster.

DROP INDEX IF EXISTS lags_pk;

CREATE UNIQUE INDEX lags_pk 
	ON lags (longditude,laditude,lag,month,year);
	

DROP TABLE IF EXITS lagged_correlations;

CREATE TABLE lagged_correlations as (
	SELECT l.longditude,l.laditude,l.lag,corr(l.oni,l.lagged_anomoly) as "correlation"
	FROM lags as l
	GROUP BY l.longditude,l.laditude,l.lag
);

DROP TABLE IF EXISTS plot_lags_1979_2021;
CREATE TABLE plot_lags_1979_2021(longditude,laditude,lag) as (

SELECT temp.longditude,
	   temp.laditude,
--	   temp.array_agg,
--	   l.correlation  as "biggest impact correlation",
--	   temp.avg,
--	   temp.stddev,
--	   (l.correlation-temp.avg)/temp.stddev as z_score,
	   CASE WHEN abs((l.correlation-temp.avg)/temp.stddev) > 1 AND abs(l.correlation) >= 0.088 THEN l.lag ELSE 0 END as "lag with biggest impact"
FROM (
SELECT l.longditude, 
	   l.laditude,
	   array_agg(l.correlation),
	   max(abs(l.correlation)),
	   avg(l.correlation),
	   stddev(l.correlation)
FROM lagged_correlations as l
GROUP BY l.laditude,longditude
ORDER BY l.longditude,l.laditude
) as temp, lagged_correlations as l 
WHERE temp.longditude = l.longditude AND temp.laditude = l.laditude AND temp.max = abs(l.correlation)
ORDER BY temp.laditude ASC,temp.longditude ASC);

\copy plot_lags_1979_2021 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_1979_2021.csv' DELIMITER ';' CSV HEADER;

--Calculate correlation coefficient between oni values and global precipitation for every location and month lag 1-12 for periods of 10 years, in a 5 year cycle. 1979-1988,1984-1993,1989-1998,...
--Starting 1979-1988

DROP TABLE IF EXISTS lags_periods;


CREATE TABLE lags_periods as (
SELECT 1979 as start_year,1988 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1979 AND 1988
UNION 
SELECT 1980 as start_year,1989 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1980 AND 1989
UNION 
SELECT 1981 as start_year,1990 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1981 AND 1990
UNION 
SELECT 1982 as start_year,1991 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1982 AND 1991
UNION 
SELECT 1983 as start_year,1992 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1983 AND 1992
UNION 
SELECT 1984 as start_year, 1993 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1984 AND 1993
UNION 
SELECT 1985 as start_year, 1994 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1985 AND 1994
UNION 
SELECT 1986 as start_year,1995 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1986 AND 1995
UNION 
SELECT 1987 as start_year,1996 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1987 AND 1996
UNION 
SELECT 1988 as start_year,1997 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1988 AND 1997
UNION 
SELECT 1989 as start_year, 1998 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1989 AND 1998
UNION 
SELECT 1990 as start_year, 1999 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1990 AND 1999
UNION 
SELECT 1991 as start_year, 2000 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1991 AND 2000
UNION 
SELECT 1992 as start_year, 2001 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1992 AND 2001
UNION 
SELECT 1993 as start_year, 2002 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1993 AND 2002
UNION 
SELECT 1994 as start_year, 2003 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1994 AND 2003
UNION 
SELECT 1995 as start_year, 2004 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1995 AND 2004
UNION 
SELECT 1996 as start_year, 2005 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1996 AND 2005
UNION 
SELECT 1997 as start_year, 2006 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1997 AND 2006
UNION 
SELECT 1998 as start_year, 2007 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1998 AND 2007
UNION 
SELECT 1999 as start_year, 2008 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 1999 AND 2008
UNION 
SELECT 2000 as start_year, 2009 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2000 AND 2009
UNION 
SELECT 2001 as start_year, 2010 as end_year, *
FROM lags as l  
WHERE l.year BETWEEN 2001 AND 2010
UNION 
SELECT 2002 as start_year, 2011 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2002 AND 2011
UNION 
SELECT 2003 as start_year, 2012 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2003 AND 2012
UNION 
SELECT 2004 as start_year, 2013 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2004 AND 2013
UNION 
SELECT 2005 as start_year, 2014 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2005 AND 2014
UNION 
SELECT 2006 as start_year, 2015 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2006 AND 2015
UNION 
SELECT 2007 as start_year, 2016 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2007 AND 2016
UNION 
SELECT 2008 as start_year, 2017 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2008 AND 2017
UNION 
SELECT 2009 as start_year, 2018 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2009 AND 2018
UNION 
SELECT 2010 as start_year, 2019 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2010 AND 2019
UNION 
SELECT 2011 as start_year, 2020 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2011 AND 2020
UNION 
SELECT 2012 as start_year, 2021 as end_year, *
FROM lags as l 
WHERE l.year BETWEEN 2012 AND 2021
);

\copy lags_periods TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/lags_periods.csv' DELIMITER ';' CSV HEADER;


