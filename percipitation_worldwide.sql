-- \i 'C:/Users/Alexej/Desktop/Bachelorarbeit/precipitation_worldwide.sql'

--Prepare precipitation_worldwide table

/*DROP TABLE IF EXISTS precipitation_worldwide;
CREATE TABLE precipitation_worldwide(
id int PRIMARY KEY,
date date,
longditude real,
laditude real,
average_monthly_precipitation real);
*/

--Copy the netcdf file precip.mon.mean.nc into the CSV format translated from the gcpc.py Python Script into the precipitation worldwide table in the PostgreSQL ORDBMS.

--\copy precipitation_worldwide (id, date, longditude,laditude,average_monthly_precipitation) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/precipitation_worldwide.csv' DELIMITER ',' CSV HEADER;

--Extract months and years from date in precipitation_worldwide table

DROP TABLE IF EXISTS period_1979_1988;
DROP TABLE IF EXISTS period_1984_1993;
DROP TABLE IF EXISTS period_1989_1998;
DROP TABLE IF EXISTS period_1994_2003;
DROP TABLE IF EXISTS period_1999_2008;
DROP TABLE IF EXISTS period_2004_2013;
DROP TABLE IF EXISTS period_2009_2018;
DROP TABLE IF EXISTS period_2014_2021;

--CREATE TABLE period_<month>_<year> (longditude,laditude,correlation) as
CREATE TABLE period_2014_2021 (longditude,laditude,correlation) as

WITH temp as (
		SELECT p.id, 
		EXTRACT(MONTH FROM p.date) as month,
		EXTRACT(YEAR FROM p.date) as year, p.date, 
		p.longditude, p.laditude, 
		p.average_monthly_precipitation
		FROM precipitation_worldwide as p ORDER BY p.id),--LIMIT 100 OFFSET 100000;

--Calculate long term month precipitation averages 1979-2021 precipitation for every location
	 averages as (
		SELECT t.month, t.longditude, t.laditude, AVG(t.average_monthly_precipitation) as long_term_month_average
		FROM temp as t 
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

--Calculate correlation coefficient between oni values and global precipitation for every location for periods of 10 years, in a 5 year cycle. 1979-1988,1984-1993,1989-1998,...
--Starting 1979-1988	
SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1979 AND 1988) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;


--\copy period_1979_1988 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_1979_1988.csv' DELIMITER ';' CSV HEADER;

SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1984 AND 1993) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;

--\copy period_1984_1993 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_1984_1993.csv' DELIMITER ';' CSV HEADER;

SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1989 AND 1998) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;

--\copy period_1989_1998 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_1989_1998.csv' DELIMITER ';' CSV HEADER;

SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1994 AND 2003) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;

--\copy period_1994_2003 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_1994_2003.csv' DELIMITER ';' CSV HEADER;

SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1999 AND 2008) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;

--\copy period_1999_2008 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_1999_2008.csv' DELIMITER ';' CSV HEADER;

SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 2004 AND 2013) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;

--\copy period_2004_2013 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_2004_2013.csv' DELIMITER ';' CSV HEADER;

SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 2009 AND 2018) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;

--\copy period_2009_2018 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_2009_2018.csv' DELIMITER ';' CSV HEADER;

SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation coefficient oceanic nino index and percipitation anomalies"
FROM (SELECT * FROM oni WHERE oni.year BETWEEN 2014 AND 2021) as o
GROUP BY (o.longditude,o.laditude)
ORDER BY o.laditude ASC,o.longditude ASC;

--\copy period_2014_2021 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_2014_2021.csv' DELIMITER ';' CSV HEADER;

		
