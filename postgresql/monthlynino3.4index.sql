-- \i 'C:/Users/Alexej/Desktop/Bachelorarbeit/monthlynino3.4index.sql'

DROP TABLE IF EXISTS monthlyninoindex;

CREATE TABLE monthlyninoindex(
month int NOT NULL,
year int NOT NULL,
total real,
climAdjust real,
anomaly real
);

DROP TABLE IF EXISTS soi;

CREATE TABLE soi(
date int PRIMARY KEY,
value real 
);

/*
The monthly Niño-3.4 index (which is used to calculate the ONI values) that uses these new centered 30-year base periods ("ClimAdjust"), taken from:
https://origin.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_change.shtml
*/

\copy monthlyninoindex (month,year,total,climAdjust,anomaly) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/Monthly-Nino-3.4-index.csv' DELIMITER ',' CSV HEADER;
\copy soi (date, value) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/Southern Oscillation Index.csv' DELIMITER ',' CSV HEADER;

ALTER TABLE soi 
ADD id INTEGER GENERATED ALWAYS AS IDENTITY;


-- TABLE monthlyninoindex;

/*Cold & Warm Episodes by Season
for the Oceanic Niño Index (ONI) [3 month running mean of ERSST.v5 SST anomalies in the Niño 3.4 region (5oN-5oS, 120o-170oW)],
based on centered 30-year base periods updated every 5 years.
https://origin.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ONI_v5.php
*/

DROP TABLE IF EXISTS oni_values;

CREATE TABLE oni_values (month,year,total,climAdjust,anomaly,oni) as 
SELECT *, 
	   AVG(m.anomaly) over win AS "ONI value"
FROM monthlyninoindex as m
WINDOW win AS (ORDER BY m.year, m.month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
ORDER BY m.year, m.month;

/* This table classifies every month where the ONI value exceeds 0.5 for that particular month, 
   followed by four consecutive months with ONI values above 0.5, as an El Nino month.
   Conversely, every month with ONI values below -0.5 followed by four months with ONI values below -0.5, will be labelled a La Nina month.

*/

DROP TABLE IF EXISTS enso_events;

CREATE TABLE enso_events AS
SELECT *,
	   max(oni_values.oni) over win AS "maximum oni value",
	   min(oni_values.oni) over win AS "minimum oni value",
	   CASE WHEN SIGN(max(oni_values.oni) over win)=SIGN(min(oni_values.oni) over win) AND 
				 SIGN(max(oni_values.oni) over win)=1 AND 
				 min(oni_values.oni) over win >= 0.5  THEN 'El Nino Event'
			WHEN SIGN(max(oni_values.oni) over win)=SIGN(min(oni_values.oni) over win) AND 
				 SIGN(max(oni_values.oni) over win)=-1 AND
				 max(oni_values.oni) over win <=-0.5 THEN 'La Nina Event' 
			ELSE 'Normal Conditions' 
	   END AS "condition"
FROM oni_values AS oni_values
WINDOW win AS (ORDER BY oni_values.year, oni_values.month ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)
ORDER BY oni_values.year, oni_values.month;


ALTER TABLE enso_events
ADD id INTEGER GENERATED ALWAYS AS IDENTITY;

--\copy enso_events TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/enso_events.csv' DELIMITER ';' CSV HEADER;

/*Including soi values into enso_events table
*/
SELECT e.*, s.value as "soi"
	   FROM enso_events as e, soi as s 
	   WHERE e.year > 1950 AND e.id - 12 = s.id;

SELECT AVG(c.oni) as "Average ONI from 1951-2021", AVG(c.value) as "Average SOI from 1951-2021", corr(c.oni,c.value) "R(ONI,SOI)"
FROM  (SELECT e.*, s.value
	   FROM enso_events as e, soi as s 
	   WHERE e.year > 1950 AND e.id - 12 = s.id) as c;

/*Listing all El Nino events 
*/

SELECT * 
FROM enso_events as e 
WHERE e.condition = 'El Nino Event';



