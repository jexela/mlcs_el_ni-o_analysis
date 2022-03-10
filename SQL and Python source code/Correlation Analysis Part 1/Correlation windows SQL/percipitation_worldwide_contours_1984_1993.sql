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
DROP TABLE IF EXISTS period_2012_2021_countours;

--CREATE TABLE period_<month>_<year> (longditude,laditude,correlation) as
CREATE TABLE period_1984_1993_countours (longditude,laditude,correlation) as

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

--Calculate correlation coefficient countours between oni values and global precipitation for every location for periods of 10 years (120 months, 118 degrees of freedom), in a 1 year cycle. 1979-1988,1980-1989,1981-1990,...
--Use approximations to the t distribution https://www.researchgate.net/publication/282255788_Approximations_to_the_t_distribution
--Starting 1979-1988	
SELECT *, rank () over (ORDER BY abs(p.correlation) DESC)
FROM (SELECT t.longditude,t.laditude, t.correlation,t_value,z_one,p_value
	   FROM (SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation"
			 FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1984 AND 1993) as o
			 GROUP BY (o.longditude,o.laditude)
			 ORDER BY o.laditude ASC,o.longditude ASC) as t,
			 LATERAL (SELECT sqrt(120-2)*t.correlation/(sqrt(1-power(t.correlation,2))) as t_value) t_value,
			 LATERAL (SELECT abs(t_value)*(1-1/(4*118))*power((1+(power(t_value,2)/(2*118))),-0.5) as z_one) z_one,
			 LATERAL (SELECT 2*(1-power(1+exp(0.000345*power(z_one,5)-0.0695547*power(z_one,3)-1.604325*z_one),-1)) as p_value) p_value) as p
WINDOW win as (ORDER BY abs(p.correlation) ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
;

--DROP TABLE IF EXISTS period_1984_1993_countours_adj;

CREATE TABLE period_1984_1993_countours_adj as 
WITH RECURSIVE start as (
		SELECT p.*, p.p_value as p_value_adj
		FROM period_1984_1993_countours as p
		WHERE p.p_value = (SELECT max(p.p_value) as p_value_adj FROM period_1984_1993_countours as p)
		
	UNION
	
		SELECT p.*,CASE WHEN s.p_value_adj > p.p_value * (10368/p.rank) THEN (p.p_value * 10368/p.rank::numeric) ELSE s.p_value_adj END as p_value_adj
		FROM period_1984_1993_countours as p, start as s
		WHERE p.rank=s.rank-1 
)
SELECT s.longditude, s.laditude, s.correlation, s.p_value_adj
FROM start as s
ORDER BY s.laditude ASC,s.longditude ASC;

SELECT min(abs(p.correlation))
FROM (SELECT CASE WHEN temp.p_value_adj < 0.05 THEN temp.correlation ELSE 0 END as correlation FROM period_1984_1993_countours_adj as temp) as p
WHERE p.correlation <> 0;

-- Cutoff line =   0.264508866120598767, which corresponds to the smallest absolute correlation with p_value_adj < 0.05
--TABLE period_1984_1993_countours OFFSET 10000;

\copy period_1984_1993_countours_adj TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Benjamini_Hochberg/csv_contours/period_1984_1993_countours_adj.csv' DELIMITER ';' CSV HEADER;

/* Test approximations to the t distribution https://www.researchgate.net/publication/262689541_Approximations_to_the_t-distribution with r=829*sqrt(30187241)/(30187241) corresponding to a two tail area of 0.05 with 120 observations (118 degrees of freedom)
Approximation yields a p value of 0.4964 
For t table please refer to http://simulation-math.com/TDistTable.pdf
SELECT t.correlation,p_value
FROM (SELECT 99/sqrt(304801) as correlation) as t,
	  LATERAL (SELECT sqrt(120-2)*t.correlation/(sqrt(1-power(t.correlation,2))) as t_value) t_value,
	  LATERAL (SELECT abs(t_value)*(1-1/(4*118))*power((1+(power(t_value,2)/(2*118))),-0.5) as z_one) z_one,
	  LATERAL (SELECT 2*(1-power(1+exp(0.000345*power(z_one,5)-0.0695547*power(z_one,3)-1.604325*z_one),-1)) as p_value) p_value;
*/  

--Identifying all the points encapsulated by the big blue shape with the help of recursion 

DROP TABLE IF EXISTS blues_1984_1993;

CREATE TABLE blues_1984_1993 (longditude,laditude,correlation) as 
WITH RECURSIVE shapes (longditude,laditude,correlation) as (
		SELECT p.longditude,p.laditude,p.correlation 
		FROM period_1984_1993_countours_adj as p 
		WHERE (p.laditude = 1.25 AND p.longditude = 126.25) OR (p.laditude = 1.25-25 AND p.longditude = 126.25+50)
	UNION 
		SELECT p.longditude,p.laditude,p.correlation
		FROM (SELECT * FROM period_1984_1993_countours_adj as temp WHERE temp.correlation <= -  0.264508) as p, shapes as s 
		WHERE (s.laditude+2.5=p.laditude AND s.longditude+2.5=p.longditude AND p.correlation <= -  0.264508) OR 
			  (s.laditude+2.5=p.laditude AND s.longditude-2.5=p.longditude AND p.correlation <= -  0.264508) OR 
			  (s.laditude-2.5=p.laditude AND s.longditude-2.5=p.longditude AND p.correlation <= -  0.264508) OR 
			  (s.laditude-2.5=p.laditude AND s.longditude+2.5=p.longditude AND p.correlation <= -  0.264508) OR
			  (s.laditude+2.5=p.laditude AND s.longditude=p.longditude     AND p.correlation <= -  0.264508) OR
			  (s.laditude-2.5=p.laditude AND s.longditude=p.longditude     AND p.correlation <= -  0.264508) OR
		      (s.longditude+2.5=p.longditude AND s.laditude=p.laditude     AND p.correlation <= -  0.264508) OR
		      (s.longditude-2.5=p.longditude AND s.laditude=p.laditude	   AND p.correlation <= -  0.264508)
)

--Connecting all the identified points to the world map

SELECT * 
FROM(
SELECT p.longditude,p.laditude, CASE WHEN abs(p.correlation) <   0.264508 THEN p.correlation ELSE 0 END
FROM period_1984_1993_countours_adj as p
WHERE NOT EXISTS (SELECT * FROM shapes as s WHERE p.longditude=s.longditude AND 
												  p.laditude=s.laditude)
UNION
SELECT * FROM shapes as s) as temp 
ORDER BY temp.laditude ASC,temp.longditude ASC;


--\copy blues TO 'C:/Users/Alexej/Desktop/blues.csv' DELIMITER ';' CSV HEADER;

--Calculation of the area of ​​each grid point depending on its location with the great circle distance method.

/*
SELECT *, horizontal_distance*vertical_distance as "square_miles"
FROM blues as b,
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude+1.25,b.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude,b.laditude+1.25)) as vertical_distance) vertical_distance
WHERE b.correlation <= -  0.264508;*/

--Adding up each area point to calculate the total area of ​​the blue structure.

SELECT sum(square_miles) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM blues_1984_1993 as b,
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude+1.25,b.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(b.longditude,b.laditude)<@>point(b.longditude,b.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE b.correlation <= -  0.264508) as s;


--Identifying all the points encapsulated by the big red shape with the help of recursion 

DROP TABLE IF EXISTS reds_1984_1993;

CREATE TABLE reds_1984_1993 (longditude,laditude,correlation) as 
WITH RECURSIVE shapes2 (longditude,laditude,correlation) as (
		SELECT p.longditude,p.laditude,p.correlation 
		FROM period_1984_1993_countours_adj as p 
		WHERE p.laditude = 1.25 AND p.longditude = 201.25 --OR p.laditude = 31.25 AND p.longditude = 281.25 
	UNION 
		SELECT p.longditude,p.laditude,p.correlation
		FROM (SELECT * FROM period_1984_1993_countours_adj as temp WHERE temp.correlation >=   0.264508) as p, shapes2 as s 
		WHERE (s.laditude+2.5=p.laditude AND s.longditude+2.5=p.longditude AND p.correlation >=   0.264508) OR 
			  (s.laditude+2.5=p.laditude AND s.longditude-2.5=p.longditude AND p.correlation >=   0.264508) OR 
			  (s.laditude-2.5=p.laditude AND s.longditude-2.5=p.longditude AND p.correlation >=   0.264508) OR 
			  (s.laditude-2.5=p.laditude AND s.longditude+2.5=p.longditude AND p.correlation >=   0.264508) OR
			  (s.laditude+2.5=p.laditude AND s.longditude=p.longditude     AND p.correlation >=   0.264508) OR
			  (s.laditude-2.5=p.laditude AND s.longditude=p.longditude     AND p.correlation >=   0.264508) OR
		      (s.longditude+2.5=p.longditude AND s.laditude=p.laditude     AND p.correlation >=   0.264508) OR
		      (s.longditude-2.5=p.longditude AND s.laditude=p.laditude	   AND p.correlation >=   0.264508)
)

--Connecting all the identified points to the world map


SELECT *
FROM(
SELECT b.longditude,b.laditude, b.correlation
FROM blues_1984_1993 as b
WHERE NOT EXISTS (SELECT * FROM shapes2 as s WHERE b.longditude=s.longditude AND 
												  b.laditude=s.laditude)
UNION
SELECT * FROM shapes2 as s) as temp 
ORDER BY temp.laditude ASC,temp.longditude ASC;


\copy reds_1984_1993 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Benjamini_Hochberg/reds_1984_1993.csv' DELIMITER ';' CSV HEADER;
\copy reds_1984_1993 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Shapes0.05/csv/reds_1984_1993.csv' DELIMITER ';' CSV HEADER;

SELECT sum(square_miles) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1984_1993 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >=   0.264508) as s;