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
	
/*
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

*/

--Calculate correlation coefficient between oni values and global precipitation for every location and monthly lags 1-12 for a moving window of 10 years. 1979-1988,1980-1989,...,2012-2021.

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

--\copy lags_periods TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/lags_periods.csv' DELIMITER ';' CSV HEADER;

--Corrected version of lags_periods, as the number of data points decreases with each time lag.

DELETE FROM lags_periods as l  
WHERE ((l.year = l.end_year AND l.lag = 1  AND (l.month BETWEEN 12 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 1  AND (l.month BETWEEN 3 AND 3))) 																     				OR
	  ((l.year = l.end_year AND l.lag = 2  AND (l.month BETWEEN 11 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 2  AND (l.month BETWEEN 2 AND 3))) 																     				OR
	  ((l.year = l.end_year AND l.lag = 3  AND (l.month BETWEEN 10 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 3  AND (l.month BETWEEN 1 AND 3))) 																     				OR
	  ((l.year = l.end_year AND l.lag = 4  AND (l.month BETWEEN  9 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 4  AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN 12 AND 12) AND l.lag = 4 )) OR
      ((l.year = l.end_year AND l.lag = 5  AND (l.month BETWEEN  8 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 5  AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN 11 AND 12) AND l.lag = 5 )) OR
      ((l.year = l.end_year AND l.lag = 6  AND (l.month BETWEEN  7 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 6  AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN 10 AND 12) AND l.lag = 6 )) OR
      ((l.year = l.end_year AND l.lag = 7  AND (l.month BETWEEN  6 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 7  AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN  9 AND 12) AND l.lag = 7 )) OR
      ((l.year = l.end_year AND l.lag = 8  AND (l.month BETWEEN  5 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 8  AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN  8 AND 12) AND l.lag = 8 )) OR
      ((l.year = l.end_year AND l.lag = 9  AND (l.month BETWEEN  4 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 9  AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN  7 AND 12) AND l.lag = 9 )) OR
      ((l.year = l.end_year AND l.lag = 10 AND (l.month BETWEEN  3 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 10 AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN  6 AND 12) AND l.lag = 10)) OR
      ((l.year = l.end_year AND l.lag = 11 AND (l.month BETWEEN  2 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 11 AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN  5 AND 12) AND l.lag = 11)) OR
      ((l.year = l.end_year AND l.lag = 12 AND (l.month BETWEEN  1 AND 12) AND l.year <> 2021) OR (l.year = 2021 AND l.lag = 12 AND (l.month BETWEEN 1 AND 3)) OR (l.end_year=2021 AND l.year=2020 AND (l.month BETWEEN  4 AND 12) AND l.lag = 12))
;

--Calculate correlation coefficients between oni values and global precipitation anomalies for every location for periods of 10 years, for every monthly time lag 1-12. 1979-1988,1980-1989,1990-1999,...,2012-2021
--Once this is done, calculate the maximum correlation coefficients from all time lags 1-12 for each location and window.
--Then calculate the median and the middle 50% to get an idea of ​​the different time lags. Pixels that do not show a certain pattern of time lags are not considered.


--DROP TABLE IF EXISTS lag_max_correlations;

CREATE TABLE lag_max_correlations (start_year,end_year,longditude,laditude,max_correlation,lag, z_score, z_score_low,z_score_high, fisher_transformation_avg,stderror) as 

WITH window_correlations as (
						SELECT l.start_year,l.end_year,l.longditude,l.laditude,corr(l.oni,l.lagged_anomoly) as correlation, atanh(corr(l.oni,l.lagged_anomoly)) as fisher_transformation,l.lag
						FROM lags_periods as l 
						GROUP BY l.start_year,l.end_year,l.longditude,l.laditude,l.lag),
						
	 max_correlations   as(
						SELECT w.start_year,w.end_year,w.longditude,w.laditude, max(abs(w.correlation)) as max_correlation, avg(w.correlation),stddev(w.correlation), avg(w.fisher_transformation) as fisher_transformation_avg, sqrt(1/(120-3)::float) as fisher_transformation_stderror
						FROM window_correlations as w
						GROUP BY w.start_year,w.end_year,w.longditude,w.laditude),
			
	 max_lags 			as(
						SELECT m.start_year,m.end_year,m.longditude,
							   m.laditude,w.correlation,w.lag, 
							   w.fisher_transformation as z_score_score,
							   m.fisher_transformation_avg-m.fisher_transformation_stderror*1.96 as z_score_low,
							   m.fisher_transformation_avg+m.fisher_transformation_stderror*1.96 as z_score_high,
							   m.fisher_transformation_avg, m.fisher_transformation_stderror
						FROM max_correlations as m, window_correlations as w 
						WHERE m.max_correlation=abs(w.correlation) AND m.start_year = w.start_year AND m.end_year = w.end_year AND m.longditude = w.longditude AND m.laditude = w.laditude
						)

SELECT * FROM max_lags as m;


DROP TABLE IF EXISTS plot_lags;

--Probability that the maximum is outside the unsafe area ,1-P(-Z=-1.96<x<Z=1.96) (two standard deviations), whereby there are no places over 1979-1988,1980-1989,1990-1999,...,2012-2021 that do consist exclusively of NULL values.

CREATE TABLE plot_lags as
SELECT l.longditude,
	   l.laditude, 
	   CASE WHEN count(l.lag) >= 12 THEN percentile_disc(0.5) within group (order by l.lag) ELSE NULL END as "median max lag",
--	   percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) as "interquartile range", 
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 12 THEN count(l.lag) ELSE NULL END as "amount of lags"
FROM (SELECT lag_max_correlations.start_year,
		     lag_max_correlations.end_year,
			 lag_max_correlations.longditude, 
			 lag_max_correlations.laditude,
			 CASE WHEN (lag_max_correlations.max_correlation NOT BETWEEN tanh(lag_max_correlations.z_score_low) AND tanh(lag_max_correlations.z_score_high))
			 AND abs(lag_max_correlations.max_correlation)>=0.25 THEN lag_max_correlations.lag ELSE NULL END as lag,
			 lag_max_correlations.z_score,
			 lag_max_correlations.z_score_low,
			 lag_max_correlations.z_score_high,
			 lag_max_correlations.stderror FROM lag_max_correlations as lag_max_correlations) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

/*
SELECT * FROM plot_lags as p WHERE p."median max lag" >=3;
*/

SELECT sum(s.count) FROM (
SELECT p."median max lag", count(p."median max lag") 
FROM plot_lags as p 
GROUP BY p."median max lag"
ORDER BY p."median max lag") as s;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";

\copy plot_lags TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags.csv' DELIMITER ';' CSV HEADER;

DROP TABLE IF EXISTS plot_lags_inter;

CREATE TABLE plot_lags_inter as
SELECT l.longditude,
	   l.laditude, 
--	   percentile_disc(0.5) within group (order by l.lag) "median max lag",
	   CASE WHEN count(l.lag) >= 12 THEN percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) ELSE NULL END as "interquartile range",
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 12 THEN count(l.lag) ELSE NULL END  as "amount of lags"
FROM (SELECT lag_max_correlations.start_year,
		     lag_max_correlations.end_year,
			 lag_max_correlations.longditude, 
			 lag_max_correlations.laditude,
			 CASE WHEN (lag_max_correlations.max_correlation NOT BETWEEN tanh(lag_max_correlations.z_score_low) AND tanh(lag_max_correlations.z_score_high)) AND abs(lag_max_correlations.max_correlation)>=0.179 THEN lag_max_correlations.lag ELSE NULL END as lag,
			 lag_max_correlations.z_score,
			 lag_max_correlations.z_score_low,
			 lag_max_correlations.z_score_high,
			 lag_max_correlations.stderror FROM lag_max_correlations as lag_max_correlations) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

\copy plot_lags_inter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_inter.csv' DELIMITER ';' CSV HEADER;

/*
SELECT *
FROM plot_lags_inter as p 
WHERE p."interquartile range" = 0;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_inter as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";
*/
DROP TABLE IF EXISTS plot_lags_filter;

CREATE TABLE plot_lags_filter as 
SELECT p1.longditude,
	   p1.laditude,
	   --p1."median max lag", 
	   --p1."amount of lags", 
	   CASE WHEN p2."interquartile range" <=4 THEN p1."median max lag" ELSE NULL END as "significant median max lag"
FROM plot_lags as p1, plot_lags_inter as p2
WHERE p1.longditude=p2.longditude AND p1.laditude = p2.laditude
ORDER BY p1.laditude,p1.longditude;

\copy plot_lags_filter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_filter.csv' DELIMITER ';' CSV HEADER;

SELECT p."significant median max lag" as "significant median max lag oni" , count(p."significant median max lag")
FROM plot_lags_filter as p
GROUP BY p."significant median max lag"
ORDER BY p."significant median max lag";


--Finding the most frequent lag 

DROP TABLE IF EXISTS plot_lags_mode;

CREATE TABLE plot_lags_mode as
SELECT l.longditude,
	   l.laditude, 
	   CASE WHEN count(l.lag) >= 12 THEN mode() within group (order by l.lag) ELSE NULL END as "mode max lag",
--	   percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) as "interquartile range", 
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "mode maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 12 THEN count(l.lag) ELSE NULL END as "amount of lags"
FROM (SELECT lag_max_correlations.start_year,
		     lag_max_correlations.end_year,
			 lag_max_correlations.longditude, 
			 lag_max_correlations.laditude,
			 CASE WHEN (lag_max_correlations.max_correlation NOT BETWEEN tanh(lag_max_correlations.z_score_low) AND tanh(lag_max_correlations.z_score_high))
			 AND abs(lag_max_correlations.max_correlation)>=0.25  THEN lag_max_correlations.lag ELSE NULL END as lag,
			 lag_max_correlations.z_score,
			 lag_max_correlations.z_score_low,
			 lag_max_correlations.z_score_high,
			 lag_max_correlations.stderror FROM lag_max_correlations as lag_max_correlations) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

SELECT p."mode max lag" as "mode max lag oni", count(p."mode max lag")
FROM plot_lags_mode as p
GROUP BY p."mode max lag"
ORDER BY p."mode max lag";

\copy plot_lags_mode TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_mode.csv' DELIMITER ';' CSV HEADER;