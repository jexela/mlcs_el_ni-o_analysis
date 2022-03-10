/*Preparation of the tables for the PCMCI algorithm to determine the causal maps. The PCMCI is implemented with the Tigramite Python package.
https://github.com/jakobrunge/tigramite/blob/master/README.md 
*/

/*
Creation of the data_nino_indices table with the associated lags of 12 months for all possible actors of the PCMCI algorithm.
*/
--DROP TABLE IF EXISTS data_nino_indices;

CREATE TABLE data_nino_indices ( year, month, date, longditude, laditude, precipitation_anomaly, oni ,nino_12_index, nino_3_index, nino_4_index, tni) as 

SELECT d.year, d.month, date, d.longditude, d.laditude, d.percipitation_anomaly, d.oni, l.nino_12_index ,l.nino_3_index,l.nino_4_index, t.tni
FROM data as d, lags_nino_regions_running_averages as l, trans_nino_index as t
WHERE d.year = l.year AND d.month = l.month AND d.year = t.year AND d.month = t.month;

\copy (SELECT d.precipitation_anomaly,d.oni,d.nino_4_index FROM data_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/pcmci.csv' DELIMITER ';' CSV HEADER;

--SELECT * FROM data_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC, d.year ASC, d.month ASC;
SELECT d.precipitation_anomaly,d.oni,d.nino_4_index FROM data_nino_indices as d WHERE d.longditude=1.25 AND d.laditude = -88.75 ORDER BY d.year ASC, d.month ASC;
SELECT d.precipitation_anomaly,d.oni,d.nino_4_index FROM data_nino_indices as d WHERE d.longditude=3.75 AND d.laditude = -88.75 ORDER BY d.year ASC, d.month ASC;

CREATE TABLE  data_nino_indices_time_lags (month,
										  year,
										  date,
										  longditude,
										  laditude, 
										  precipitation_anomaly, 
										  nino_12_index,
										  nino_3_index,
										  oni, 
										  nino_34_index, 
										  nino_4_index, 
										  lagged_anamoly,
										  lagged_nino_12_index,
										  lagged_nino_3_index,
										  lagged_oni,
										  lagged_nino34_index,
										  lagged_nino_4_index,
										  following_date,
										  window_length,
										  lag
										  ) as (
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 1 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 2 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 3 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 4 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 4 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length",  
															 5 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 5 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 6 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 6 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length",  
															 7 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 8 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 8 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 9 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 9 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 10 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 10 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 11 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 11 FOLLOWING)
UNION
SELECT d.month,d.year, d.date, d.longditude,d.laditude, d.precipitation_anomaly, d.nino_12_index, d.nino_3_index, d.oni, d.nino_34_index, d.nino_4_index,
															 LAST_VALUE(d.precipitation_anomaly) over win as "lagged_anomaly", 
															 LAST_VALUE(d.nino_12_index) over win as "lagged_nino_12_index",
															 LAST_VALUE(d.nino_3_index) over win as "lagged_nino_3_index",
															 LAST_VALUE(d.oni) over win as "lagged_oni",
															 LAST_VALUE(d.nino_34_index) over win as "lagged_nino34_index",
															 LAST_VALUE(d.nino_4_index) over win as "lagged_nino_4_index",
															 LAST_VALUE(d.date) over win as "following date",
															 COUNT(*) OVER win as "window_length", 
															 12 as "lag"
FROM  data_nino_indices as d 
WINDOW win AS (PARTITION BY d.longditude,d.laditude ORDER BY d.date ROWS BETWEEN CURRENT ROW AND 12 FOLLOWING)
);

--Corrected version of lags_periods, as the number of data points decreases with each time lag. This should result in 58599936-(1+2+3+4+5+6+7+8+9+10+11+12)*72*144=57791232 rows. 

DELETE FROM data_nino_indices_time_lags as d
WHERE d.window_length-1<>d.lag;

--After this query we get DELETE 808704 which implies 58599936-808704=57791232 rows.


CREATE TABLE c_long_lat(longditude,laditude,lag,corr_auto_c,corr_c_past_oni,corr_c_past_nino4index) as 
SELECT d.longditude,d.laditude,d.lag,corr(d.lagged_anamoly,d.precipitation_anomaly),corr(d.lagged_anamoly,d.oni),corr(d.lagged_anamoly,d.nino_4_index)
FROM data_nino_indices_time_lags as d 
GROUP BY d.longditude,d.laditude,d.lag;

CREATE TABLE a_long_lat(longditude,laditude,lag,corr_auto_oni,corr_a_past_precip,corr_a_past_nino4index) as 
SELECT d.longditude,d.laditude,d.lag,corr(d.lagged_oni,d.oni),corr(d.lagged_oni,d.precipitation_anomaly),corr(d.lagged_oni,d.nino_4_index)
FROM data_nino_indices_time_lags as d 
GROUP BY d.longditude,d.laditude,d.lag;

CREATE TABLE b_long_lat(longditude,laditude,lag,corr_auto_nino4,corr_b_past_precip,corr_b_past_oni) as 
SELECT d.longditude,d.laditude,d.lag,corr(d.lagged_nino_4_index,d.nino_4_index),corr(d.lagged_nino_4_index,d.precipitation_anomaly),corr(d.lagged_nino_4_index,d.oni)
FROM data_nino_indices_time_lags as d 
GROUP BY d.longditude,d.laditude,d.lag;

--DROP TABLE IF EXISTS pcmci_ready;
CREATE TABLE pcmci_ready (
longditude numeric,
laditude numeric,
actor_id int,
incoming_links text);


INSERT INTO pcmci_ready 
WITH 	c_temp as 
					(SELECT c.longditude,
							c.laditude, 
							REPLACE(ROW((ROW(0,-c.lag)::text),c.corr_auto_c)::text,'"','') as driver_0 ,
							REPLACE(ROW((ROW(1,-c.lag)::text),c.corr_c_past_oni)::text,'"','') as driver_1,
							REPLACE(ROW((ROW(2,-c.lag)::text),c.corr_c_past_nino4index)::text,'"','') as driver_2
					 FROM c_long_lat as c),
		a_temp as 
					(SELECT a.longditude,
							a.laditude, 
							a.lag, 
							REPLACE(ROW((ROW(0,-a.lag)::text),a.corr_a_past_precip)::text,'"','') as driver_0 ,
							REPLACE(ROW((ROW(1,-a.lag)::text),a.corr_auto_oni)::text,'"','') as driver_1 ,
							REPLACE(ROW((ROW(2,-a.lag)::text),a.corr_a_past_nino4index)::text,'"','') as driver_2
					 FROM a_long_lat as a),
		b_temp as 	
					(SELECT b.longditude,
							b.laditude, 
							b.lag, 
							REPLACE(ROW((ROW(0,-b.lag)::text),b.corr_b_past_precip)::text,'"','') as driver_0 ,
							REPLACE(ROW((ROW(1,-b.lag)::text),b.corr_b_past_oni)::text,'"','') as driver_1 ,
							REPLACE(ROW((ROW(2,-b.lag)::text),b.corr_auto_nino4)::text,'"','') as driver_2
					 FROM b_long_lat as b)


SELECT c.longditude,c.laditude, 0 as actor_id, REPLACE((array_agg(c.driver_0) || array_agg(c.driver_1) || array_agg(c.driver_2))::text,'"','') as incoming_links
FROM c_temp as c
GROUP BY c.longditude,c.laditude
UNION 
SELECT a.longditude,a.laditude, 1 as actor_id, REPLACE((array_agg(a.driver_0) || array_agg(a.driver_1) || array_agg(a.driver_2))::text,'"','') as incoming_links
FROM a_temp as a
GROUP BY a.longditude,a.laditude
UNION 
SELECT b.longditude,b.laditude, 2 as actor_id, REPLACE((array_agg(b.driver_0) || array_agg(b.driver_1) || array_agg(b.driver_2))::text,'"','') as incoming_links
FROM b_temp as b
GROUP BY b.longditude,b.laditude;

SELECT REPLACE(REPLACE(ROW(p.actor_id,p.incoming_links)::text, ',"{',': ['),'}")',']')
FROM pcmci_ready as p 
WHERE p.laditude = 1.25 AND p.longditude = 126.25
ORDER BY p.laditude ASC, p.longditude, p.actor_id ASC 
LIMIT 6;


\copy (SELECT * FROM pcmci_ready as p ORDER BY p.laditude ASC, p.longditude ASC) TO 'C:/Users/Alexej/Desktop/pcmci.csv' DELIMITER ';' CSV HEADER;

--SQL functions to fetch the greatest and smallest values of a PostgreSQL array

CREATE OR REPLACE FUNCTION array_greatest(anyarray)
RETURNS anyelement
LANGUAGE SQL
AS $$
  SELECT max(elements) FROM unnest($1) elements
$$;

CREATE OR REPLACE FUNCTION array_smallest(anyarray)
RETURNS anyelement
LANGUAGE SQL
AS $$
  SELECT min(elements) FROM unnest($1) elements
$$;

SELECT array_greatest(array_agg(1.3) || array_agg(2.44324));
SELECT array_smallest(array_agg(1.3) || array_agg(2.44324));

--Prepare casual_maps_preticipation_oni with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_preticipation_oni
;
CREATE TABLE casual_maps_preticipation_oni
(longditude real,
laditude real,
oni_coefficient_minus_zero_lag numeric,
oni_coefficient_minus_one_lag numeric,
oni_coefficient_minus_two_lag numeric,
oni_coefficient_minus_three_lag numeric,
oni_coefficient_minus_four_lag numeric,
oni_coefficient_minus_five_lag numeric,
oni_coefficient_minus_six_lag numeric,
oni_coefficient_minus_seven_lag numeric,
oni_coefficient_minus_eight_lag numeric,
oni_coefficient_minus_nine_lag numeric,
oni_coefficient_minus_ten_lag numeric,
oni_coefficient_minus_eleven_lag numeric,
oni_coefficient_minus_twelve_lag numeric
);
*/

\copy casual_maps_preticipation_oni (longditude,laditude,oni_coefficient_minus_zero_lag,oni_coefficient_minus_one_lag,oni_coefficient_minus_two_lag, oni_coefficient_minus_three_lag,oni_coefficient_minus_four_lag,oni_coefficient_minus_five_lag, oni_coefficient_minus_six_lag, oni_coefficient_minus_seven_lag,oni_coefficient_minus_eight_lag, oni_coefficient_minus_nine_lag, oni_coefficient_minus_ten_lag, oni_coefficient_minus_eleven_lag, oni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/oni_controlling_for_nino4.csv' DELIMITER ';';

/*DROP TABLE IF EXISTS partial_correlation_maps_preticipation_oni;

CREATE TABLE partial_correlation_maps_preticipation_oni 
(longditude real,
laditude real,
oni_coefficient_minus_zero_lag numeric,
oni_coefficient_minus_one_lag numeric,
oni_coefficient_minus_two_lag numeric,
oni_coefficient_minus_three_lag numeric,
oni_coefficient_minus_four_lag numeric,
oni_coefficient_minus_five_lag numeric,
oni_coefficient_minus_six_lag numeric,
oni_coefficient_minus_seven_lag numeric,
oni_coefficient_minus_eight_lag numeric,
oni_coefficient_minus_nine_lag numeric,
oni_coefficient_minus_ten_lag numeric,
oni_coefficient_minus_eleven_lag numeric,
oni_coefficient_minus_twelve_lag numeric
);
*/

\copy partial_correlation_maps_preticipation_oni (longditude,laditude,oni_coefficient_minus_zero_lag,oni_coefficient_minus_one_lag,oni_coefficient_minus_two_lag, oni_coefficient_minus_three_lag,oni_coefficient_minus_four_lag,oni_coefficient_minus_five_lag, oni_coefficient_minus_six_lag, oni_coefficient_minus_seven_lag,oni_coefficient_minus_eight_lag, oni_coefficient_minus_nine_lag, oni_coefficient_minus_ten_lag, oni_coefficient_minus_eleven_lag, oni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/partial correlations/oni_controlling_for_nino4_partial_correlations.csv' DELIMITER ';';

\copy (SELECT c.longditude,c.laditude,c.oni_coefficient_minus_zero_lag FROM partial_correlation_maps_preticipation_oni as c ORDER BY c.laditude ASC,c.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/partial_correlation_maps_preticipation_oni_lag_minus_one.csv' DELIMITER ';' CSV HEADER;

--DROP TABLE IF EXISTS partial_correlations_precipitation_oni;
CREATE TABLE partial_correlations_precipitation_oni as 

WITH maxmin as (
SELECT p.longditude,p.laditude, array_greatest(array_agg(p.oni_coefficient_minus_zero_lag) || array_agg(p.oni_coefficient_minus_one_lag) || array_agg(p.oni_coefficient_minus_two_lag) || array_agg(p.oni_coefficient_minus_three_lag) ||
											   array_agg(p.oni_coefficient_minus_four_lag) || array_agg(p.oni_coefficient_minus_five_lag) || array_agg(p.oni_coefficient_minus_six_lag) || array_agg(p.oni_coefficient_minus_seven_lag) ||
											   array_agg(p.oni_coefficient_minus_eight_lag)|| array_agg(p.oni_coefficient_minus_nine_lag) || array_agg(p.oni_coefficient_minus_ten_lag) || array_agg(p.oni_coefficient_minus_eleven_lag) ||
											   array_agg(p.oni_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(p.oni_coefficient_minus_zero_lag) || array_agg(p.oni_coefficient_minus_one_lag) || array_agg(p.oni_coefficient_minus_two_lag) || array_agg(p.oni_coefficient_minus_three_lag) ||
											   array_agg(p.oni_coefficient_minus_four_lag) || array_agg(p.oni_coefficient_minus_five_lag) || array_agg(p.oni_coefficient_minus_six_lag) || array_agg(p.oni_coefficient_minus_seven_lag) ||
											   array_agg(p.oni_coefficient_minus_eight_lag)|| array_agg(p.oni_coefficient_minus_nine_lag) || array_agg(p.oni_coefficient_minus_ten_lag) || array_agg(p.oni_coefficient_minus_eleven_lag) ||
											   array_agg(p.oni_coefficient_minus_twelve_lag)) as minimum 
FROM partial_correlation_maps_preticipation_oni as p
GROUP BY p.longditude,p.laditude
ORDER BY p.laditude ASC,p.longditude ASC)

SELECT m.laditude,m.longditude, CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum ELSE m.minimum END 
FROM maxmin as m
ORDER BY m.laditude ASC,m.longditude ASC;


\copy (SELECT * FROM partial_correlations_precipitation_oni as p ORDER BY p.laditude ASC,p.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/partial_correlation_maps_preticipation_oni.csv' DELIMITER ';' CSV HEADER;

--Casual maps for oni controlled fro nino4, with maximum coefficients (lag 1-12) only 

--DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_oni;
CREATE TABLE beta_coefficients_maps_precipitation_oni as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.oni_coefficient_minus_zero_lag) || array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.oni_coefficient_minus_zero_lag) || array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_preticipation_oni as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude, CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum ELSE m.minimum END as coefficients
FROM maxmin as m
ORDER BY m.laditude ASC,m.longditude ASC;


\copy (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients) > 1 AND b.coefficients < 0 THEN -1.01 WHEN abs(b.coefficients) > 1 AND b.coefficients > 0 THEN 1.01 ELSE b.coefficients END as coefficient FROM beta_coefficients_maps_precipitation_oni as b  ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/beta_coefficients_maps_precipitation_oni.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------Nino4 controlled for Oceanic Nino Index------------------------------------------------------------------------------------------
/*
DROP TABLE IF EXISTS casual_maps_preticipation_nino4
;
CREATE TABLE casual_maps_preticipation_nino4
(longditude real,
laditude real,
nino4_coefficient_minus_zero_lag numeric,
nino4_coefficient_minus_one_lag numeric,
nino4_coefficient_minus_two_lag numeric,
nino4_coefficient_minus_three_lag numeric,
nino4_coefficient_minus_four_lag numeric,
nino4_coefficient_minus_five_lag numeric,
nino4_coefficient_minus_six_lag numeric,
nino4_coefficient_minus_seven_lag numeric,
nino4_coefficient_minus_eight_lag numeric,
nino4_coefficient_minus_nine_lag numeric,
nino4_coefficient_minus_ten_lag numeric,
nino4_coefficient_minus_eleven_lag numeric,
nino4_coefficient_minus_twelve_lag numeric
);
*/
\copy casual_maps_preticipation_nino4 (longditude,laditude,nino4_coefficient_minus_zero_lag,nino4_coefficient_minus_one_lag,nino4_coefficient_minus_two_lag, nino4_coefficient_minus_three_lag,nino4_coefficient_minus_four_lag,nino4_coefficient_minus_five_lag, nino4_coefficient_minus_six_lag, nino4_coefficient_minus_seven_lag,nino4_coefficient_minus_eight_lag, nino4_coefficient_minus_nine_lag, nino4_coefficient_minus_ten_lag, nino4_coefficient_minus_eleven_lag, nino4_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/nino4_controlling_for_oni.csv' DELIMITER ';';

\copy (SELECT c.longditude,c.laditude,c.nino4_coefficient_minus_zero_lag FROM casual_maps_preticipation_nino4 as c ORDER BY c.laditude ASC,c.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/casual_maps_preticipation_nino4_lag_minus_one.csv' DELIMITER ';' CSV HEADER;

--DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_nino4;
CREATE TABLE beta_coefficients_maps_precipitation_nino4 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.nino4_coefficient_minus_zero_lag) || array_agg(b.nino4_coefficient_minus_one_lag) || array_agg(b.nino4_coefficient_minus_two_lag) || array_agg(b.nino4_coefficient_minus_three_lag) ||
											   array_agg(b.nino4_coefficient_minus_four_lag) || array_agg(b.nino4_coefficient_minus_five_lag) || array_agg(b.nino4_coefficient_minus_six_lag) || array_agg(b.nino4_coefficient_minus_seven_lag) ||
											   array_agg(b.nino4_coefficient_minus_eight_lag)|| array_agg(b.nino4_coefficient_minus_nine_lag) || array_agg(b.nino4_coefficient_minus_ten_lag) || array_agg(b.nino4_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino4_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.nino4_coefficient_minus_zero_lag) || array_agg(b.nino4_coefficient_minus_one_lag) || array_agg(b.nino4_coefficient_minus_two_lag) || array_agg(b.nino4_coefficient_minus_three_lag) ||
											   array_agg(b.nino4_coefficient_minus_four_lag) || array_agg(b.nino4_coefficient_minus_five_lag) || array_agg(b.nino4_coefficient_minus_six_lag) || array_agg(b.nino4_coefficient_minus_seven_lag) ||
											   array_agg(b.nino4_coefficient_minus_eight_lag)|| array_agg(b.nino4_coefficient_minus_nine_lag) || array_agg(b.nino4_coefficient_minus_ten_lag) || array_agg(b.nino4_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino4_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_preticipation_nino4 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude, CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum ELSE m.minimum END as coefficients
FROM maxmin as m
ORDER BY m.laditude ASC,m.longditude ASC;


\copy (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients) > 1 AND b.coefficients < 0 THEN -1.01 WHEN abs(b.coefficients) > 1 AND b.coefficients > 0 THEN 1.01 ELSE b.coefficients END as coefficient  FROM beta_coefficients_maps_precipitation_nino4 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/beta_coefficients_maps_precipitation_nino4.csv' DELIMITER ';' CSV HEADER;


------------------------------------------------------------------------------Nino4 controlled for Oceanic Nino Index------------------------------------------------------------------------------------------