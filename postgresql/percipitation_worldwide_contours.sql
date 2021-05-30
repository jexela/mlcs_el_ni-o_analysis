-- \i 'C:/Users/Alexej/Desktop/Bachelorarbeit/precipitation_worldwide.sql'

--Prepare precipitation_worldwide table

/*DROP TABLE IF EXISTS precipitation_worldwide_countours;
CREATE TABLE precipitation_worldwide_countours(
id int PRIMARY KEY,
date date,
longditude real,
laditude real,
average_monthly_precipitation real);
*/

--Copy the netcdf file precip.mon.mean.nc into the CSV format translated from the gcpc.py Python Script into the precipitation worldwide table in the PostgreSQL ORDBMS.

--\copy precipitation_worldwide (id, date, longditude,laditude,average_monthly_precipitation) FROM 'C:/Users/Alexej/Desktop/precipitation_worldwide.csv' DELIMITER ',' CSV HEADER;

--Extract months and years from date in precipitation_worldwide table
DROP TABLE IF EXISTS period_1979_1988_countours;
DROP TABLE IF EXISTS period_1980_1989_countours;
DROP TABLE IF EXISTS period_1981_1990_countours;
DROP TABLE IF EXISTS period_1982_1991_countours;
DROP TABLE IF EXISTS period_1983_1992_countours;
DROP TABLE IF EXISTS period_1984_1993_countours;
DROP TABLE IF EXISTS period_1985_1994_countours;
DROP TABLE IF EXISTS period_1986_1995_countours;
DROP TABLE IF EXISTS period_1987_1996_countours;
DROP TABLE IF EXISTS period_1988_1997_countours;
DROP TABLE IF EXISTS period_1989_1998_countours;
DROP TABLE IF EXISTS period_1990_1999_countours;
DROP TABLE IF EXISTS period_1991_2000_countours;
DROP TABLE IF EXISTS period_1992_2001_countours;
DROP TABLE IF EXISTS period_1993_2002_countours;
DROP TABLE IF EXISTS period_1994_2003_countours;
DROP TABLE IF EXISTS period_1995_2004_countours;
DROP TABLE IF EXISTS period_1996_2005_countours;
DROP TABLE IF EXISTS period_1997_2006_countours;
DROP TABLE IF EXISTS period_1998_2007_countours;
DROP TABLE IF EXISTS period_1999_2008_countours;
DROP TABLE IF EXISTS period_2000_2009_countours;
DROP TABLE IF EXISTS period_2001_2010_countours;
DROP TABLE IF EXISTS period_2002_2011_countours;
DROP TABLE IF EXISTS period_2003_2012_countours;
DROP TABLE IF EXISTS period_2004_2013_countours;
DROP TABLE IF EXISTS period_2005_2014_countours;
DROP TABLE IF EXISTS period_2006_2015_countours;
DROP TABLE IF EXISTS period_2007_2016_countours;
DROP TABLE IF EXISTS period_2008_2017_countours;
DROP TABLE IF EXISTS period_2009_2018_countours;
DROP TABLE IF EXISTS period_2010_2019_countours;
DROP TABLE IF EXISTS period_2011_2020_countours;

--CREATE TABLE period_<month>_<year> (longditude,laditude,correlation) as
CREATE TABLE period_1979_1988_countours (longditude,laditude,correlation) as

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

--Calculate correlation coefficient countours between oni values and global precipitation for every location for periods of 10 years, in a 1 year cycle. 1979-1988,1980-1989,1981-1990,...
--Starting 1979-1988	
SELECT t.longditude,t.laditude, CASE WHEN abs(t.correlation) <= 0.179 THEN 0
									 WHEN t.correlation > 0 THEN 1
									 WHEN t.correlation < 0 THEN -1
								END
FROM (SELECT o.longditude, 
	   o.laditude, 
	   corr(o.percipitation_anomaly,o.oni) as "correlation"
	  FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1979 AND 1988) as o
	  GROUP BY (o.longditude,o.laditude)
	  ORDER BY o.laditude ASC,o.longditude ASC) as t;


--\copy period_1979_1988_countours TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/period_1979_1988_countours.csv' DELIMITER ';' CSV HEADER;

--Identifying all the points encapsulated by the big blue shape with the help of recursion 

DROP TABLE IF EXISTS blues;

CREATE TABLE blues (longditude,laditude,correlation) as 
WITH RECURSIVE shapes (longditude,laditude,correlation) as (
		SELECT * 
		FROM period_1979_1988_countours as p 
		WHERE p.laditude = 1.25 AND p.longditude = 126.25
	UNION 
		SELECT p.longditude,p.laditude,p.correlation
		FROM (SELECT * FROM period_1979_1988_countours as temp WHERE temp.correlation = -1) as p, shapes as s 
		WHERE (s.laditude+2.5=p.laditude AND s.longditude+2.5=p.longditude AND p.correlation = -1) OR 
			  (s.laditude+2.5=p.laditude AND s.longditude-2.5=p.longditude AND p.correlation = -1) OR 
			  (s.laditude-2.5=p.laditude AND s.longditude-2.5=p.longditude AND p.correlation = -1) OR 
			  (s.laditude-2.5=p.laditude AND s.longditude+2.5=p.longditude AND p.correlation = -1) OR
			  (s.laditude+2.5=p.laditude AND s.longditude=p.longditude     AND p.correlation = -1) OR
			  (s.laditude-2.5=p.laditude AND s.longditude=p.longditude     AND p.correlation = -1) OR
		      (s.longditude+2.5=p.longditude AND s.laditude=p.laditude     AND p.correlation = -1) OR
		      (s.longditude-2.5=p.longditude AND s.laditude=p.laditude	   AND p.correlation = -1)
)

--Connecting all the identified points to the world map

SELECT * 
FROM(
SELECT p.longditude,p.laditude, 0 as correlation
FROM period_1979_1988_countours as p
WHERE NOT EXISTS (SELECT * FROM shapes as s WHERE p.longditude=s.longditude AND 
												  p.laditude=s.laditude 	AND
												  p.correlation=s.correlation)
UNION
SELECT * FROM shapes as s) as temp 
ORDER BY temp.laditude ASC,temp.longditude ASC;


--\copy blues TO 'C:/Users/Alexej/Desktop/blues.csv' DELIMITER ';' CSV HEADER;

--Calculation of the area of ​​each grid point depending on its location with the great circle distance method.

SELECT *, horizontal_distance*vertical_distance as "square_miles"
FROM blues as b,
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude+1.25,b.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude,b.laditude+1.25)) as vertical_distance) vertical_distance
WHERE b.correlation = -1;

--Adding up each area point to calculate the total area of ​​the blue structure.

SELECT sum(square_miles) as "total area in square miles"
FROM (
SELECT *, horizontal_distance*vertical_distance as "square_miles"
FROM blues as b,
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude+1.25,b.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude,b.laditude+1.25)) as vertical_distance) vertical_distance
WHERE b.correlation = -1) as s;