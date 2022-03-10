/*Preparation of the tables for the PCMCI algorithm to determine the causal maps. The PCMCI is implemented with the Tigramite Python package.
https://github.com/jakobrunge/tigramite/blob/master/README.md 
*/

/*
Creation of the data_nino_indices table with the associated lags of 12 months for all possible actors of the PCMCI algorithm.
*/
--DROP TABLE IF EXISTS data_nino_indices;

CREATE TABLE data_nino_indices ( year, month, date, longditude, laditude, precipitation_anomaly, nino_12_index ,nino_3_index,oni, nino_34_index, nino_4_index, tni, tni_anom) as 

SELECT d.year, d.month, date, d.longditude, d.laditude, d.percipitation_anomaly, d.oni, l.nino_12_index ,l.nino_3_index,l."nino_3.4_index", l.nino_4_index, t.tni, t.tni_anom
FROM data as d, lags_nino_regions_running_averages as l, trans_nino_index as t
WHERE d.year = l.year AND d.month = l.month AND d.year = t.year AND d.month = t.month;

\copy (SELECT d.precipitation_anomaly,d.oni,d.nino_4_index FROdata_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/pcmci.csv' DELIMITER ';' CSV HEADER;

\copy (SELECT d.precipitation_anomaly,d.oni,d.nino_12_index FROM data_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/pcmci_oni_nino12.csv' DELIMITER ';' CSV HEADER;

\copy (SELECT d.precipitation_anomaly,d.nino_12_index,d.nino_4_index FROM data_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/pcmci_nino12_nino4.csv' DELIMITER ';' CSV HEADER;

\copy (SELECT d.precipitation_anomaly,d.nino_12_index,d.nino_3_index, d.nino_34_index,d.nino_4_index, d.tni FROM data_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/pcmci_everything_wt_oni.csv' DELIMITER ';' CSV HEADER;

\copy (SELECT d.precipitation_anomaly,d.oni,d.nino_12_index,d.nino_3_index,d.nino_4_index, d.tni FROM data_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/pcmci_everything_wt_nino34.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT d.precipitation_anomaly,d.oni,d.nino_12_index,d.nino_3_index,d.nino_4_index, d.tni FROM data_nino_indices as d WHERE d.year BETWEEN 1982 AND 2001 ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/PCMCI_partitioned/1982-2001/pcmci_everything_wt_nino34_1982_2001.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT d.precipitation_anomaly,d.oni,d.nino_12_index,d.nino_3_index,d.nino_4_index, d.tni FROM data_nino_indices as d WHERE d.year BETWEEN 2002 AND 2021 ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/PCMCI_partitioned/2002-2021/pcmci_everything_wt_nino34_2002_2021.csv' DELIMITER ';' CSV HEADER;

\copy (SELECT d.precipitation_anomaly,d.oni,d.nino_3_index FROM data_nino_indices as d ORDER BY d.laditude ASC,d.longditude ASC,d.year ASC, d.month ASC) TO 'C:/Users/Alexej/Desktop/pcmci_oni_nino3.4.csv' DELIMITER ';' CSV HEADER;

--Relation of standard deviations to standardize multiple regression later

DROP TABLE IF EXISTS standardization;
CREATE TABLE standardization (longditude,laditude, precip_anomaly_stddev, oni_stddev, nino12_stddev, nino3_stddev, nino4_stddev, tni_stddev) as

SELECT d.longditude,
	   d.laditude,
	   stddev(d.precipitation_anomaly) as precip_anomaly_stddev, 
	   stddev(d.oni) as oni_stddev,
	   stddev(d.nino_12_index) as nino12_stddev,
	   stddev(d.nino_3_index) as nino3_stddev,
	   stddev(d.nino_4_index) as nino4_stddev,
	   stddev(d.tni) as tni_stddev
FROM data_nino_indices as d
GROUP BY d.longditude,d.laditude;



--Prepare casual_maps_preticipation_oni with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_preticipation_oni_con_nino12
;
CREATE TABLE casual_maps_preticipation_oni_con_nino12
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

\copy casual_maps_preticipation_oni_con_nino12 (longditude,laditude,oni_coefficient_minus_zero_lag,oni_coefficient_minus_one_lag,oni_coefficient_minus_two_lag, oni_coefficient_minus_three_lag,oni_coefficient_minus_four_lag,oni_coefficient_minus_five_lag, oni_coefficient_minus_six_lag, oni_coefficient_minus_seven_lag,oni_coefficient_minus_eight_lag, oni_coefficient_minus_nine_lag, oni_coefficient_minus_ten_lag, oni_coefficient_minus_eleven_lag, oni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/oni_controlling_for_nino12.csv' DELIMITER ';';




--Casual maps for oni controlled fro nino4, with maximum coefficients (lag 1-12) only 

--DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_oni;
CREATE TABLE beta_coefficients_maps_precipitation_oni_con_nino12 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.oni_coefficient_minus_zero_lag) || array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.oni_coefficient_minus_zero_lag) || array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_preticipation_oni_con_nino12 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude, 
       CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum ELSE m.minimum END as coefficients
FROM maxmin as m, causal_maps_precipitation_oni_con_nino12 as c
ORDER BY m.laditude ASC,m.longditude ASC;


\copy (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients) > 1 AND b.coefficients < 0 THEN -1.01 WHEN abs(b.coefficients) > 1 AND b.coefficients > 0 THEN 1.01 ELSE b.coefficients END as coefficient FROM beta_coefficients_maps_precipitation_oni_con_nino12 as b  ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/beta_coefficients_maps_precipitation_oni_con_nino12.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------Nino1+2 controlled for Oceanic Nino Index------------------------------------------------------------------------------------------
--DROP TABLE IF EXISTS casual_maps_preticipation_nino12;

CREATE TABLE casual_maps_preticipation_nino12
(longditude real,
laditude real,
nino12_coefficient_minus_zero_lag numeric,
nino12_coefficient_minus_one_lag numeric,
nino12_coefficient_minus_two_lag numeric,
nino12_coefficient_minus_three_lag numeric,
nino12_coefficient_minus_four_lag numeric,
nino12_coefficient_minus_five_lag numeric,
nino12_coefficient_minus_six_lag numeric,
nino12_coefficient_minus_seven_lag numeric,
nino12_coefficient_minus_eight_lag numeric,
nino12_coefficient_minus_nine_lag numeric,
nino12_coefficient_minus_ten_lag numeric,
nino12_coefficient_minus_eleven_lag numeric,
nino12_coefficient_minus_twelve_lag numeric
);

\copy casual_maps_preticipation_nino12 (longditude,laditude,nino12_coefficient_minus_zero_lag,nino12_coefficient_minus_one_lag,nino12_coefficient_minus_two_lag, nino12_coefficient_minus_three_lag,nino12_coefficient_minus_four_lag,nino12_coefficient_minus_five_lag, nino12_coefficient_minus_six_lag, nino12_coefficient_minus_seven_lag,nino12_coefficient_minus_eight_lag, nino12_coefficient_minus_nine_lag, nino12_coefficient_minus_ten_lag, nino12_coefficient_minus_eleven_lag, nino12_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/nino12_controlling_for_oni.csv' DELIMITER ';';

--DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_nino12;
CREATE TABLE beta_coefficients_maps_precipitation_nino12 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.nino12_coefficient_minus_zero_lag) || array_agg(b.nino12_coefficient_minus_one_lag) || array_agg(b.nino12_coefficient_minus_two_lag) || array_agg(b.nino12_coefficient_minus_three_lag) ||
											   array_agg(b.nino12_coefficient_minus_four_lag) || array_agg(b.nino12_coefficient_minus_five_lag) || array_agg(b.nino12_coefficient_minus_six_lag) || array_agg(b.nino12_coefficient_minus_seven_lag) ||
											   array_agg(b.nino12_coefficient_minus_eight_lag)|| array_agg(b.nino12_coefficient_minus_nine_lag) || array_agg(b.nino12_coefficient_minus_ten_lag) || array_agg(b.nino12_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino12_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.nino12_coefficient_minus_zero_lag) || array_agg(b.nino12_coefficient_minus_one_lag) || array_agg(b.nino12_coefficient_minus_two_lag) || array_agg(b.nino12_coefficient_minus_three_lag) ||
											   array_agg(b.nino12_coefficient_minus_four_lag) || array_agg(b.nino12_coefficient_minus_five_lag) || array_agg(b.nino12_coefficient_minus_six_lag) || array_agg(b.nino12_coefficient_minus_seven_lag) ||
											   array_agg(b.nino12_coefficient_minus_eight_lag)|| array_agg(b.nino12_coefficient_minus_nine_lag) || array_agg(b.nino12_coefficient_minus_ten_lag) || array_agg(b.nino12_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino12_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_preticipation_nino12 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude, CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum ELSE m.minimum END as coefficients
FROM maxmin as m
ORDER BY m.laditude ASC,m.longditude ASC;


\copy (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients) > 1 AND b.coefficients < 0 THEN -1.01 WHEN abs(b.coefficients) > 1 AND b.coefficients > 0 THEN 1.01 ELSE b.coefficients END as coefficient  FROM beta_coefficients_maps_precipitation_nino12 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/beta_coefficients_maps_precipitation_nino12.csv' DELIMITER ';' CSV HEADER;


------------------------------------------------------------------------------Nino1+2 controlled for Oceanic Nino Index------------------------------------------------------------------------------------------


------------------------------------------------------------------------------Oceanic Nino Index controlled for Nino 1+2, Nino 3, Nino4, Trans Nino Index--------------------------------------------------------

--Prepare casual_maps_preticipation_oni with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_precipitation_oni_con_everything
;
CREATE TABLE casual_maps_precipitation_oni_con_everything
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

--\copy casual_maps_precipitation_oni_con_everything (longditude,laditude,oni_coefficient_minus_zero_lag,oni_coefficient_minus_one_lag,oni_coefficient_minus_two_lag, oni_coefficient_minus_three_lag,oni_coefficient_minus_four_lag,oni_coefficient_minus_five_lag, oni_coefficient_minus_six_lag, oni_coefficient_minus_seven_lag,oni_coefficient_minus_eight_lag, oni_coefficient_minus_nine_lag, oni_coefficient_minus_ten_lag, oni_coefficient_minus_eleven_lag, oni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/oni_controlling_for_everything.csv' DELIMITER ';';
\copy casual_maps_precipitation_oni_con_everything (longditude,laditude,oni_coefficient_minus_zero_lag,oni_coefficient_minus_one_lag,oni_coefficient_minus_two_lag, oni_coefficient_minus_three_lag,oni_coefficient_minus_four_lag,oni_coefficient_minus_five_lag, oni_coefficient_minus_six_lag, oni_coefficient_minus_seven_lag,oni_coefficient_minus_eight_lag, oni_coefficient_minus_nine_lag, oni_coefficient_minus_ten_lag, oni_coefficient_minus_eleven_lag, oni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/oni_controlling_for_everything.csv' DELIMITER ';';


DROP TABLE IF EXISTS beta_coefficient_maps_precipitation_oni_con_everything;
CREATE TABLE beta_coefficient_maps_precipitation_oni_con_everything as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(/*array_agg(b.oni_coefficient_minus_zero_lag) ||*/ array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(/*array_agg(b.oni_coefficient_minus_zero_lag) ||*/ array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_precipitation_oni_con_everything as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.oni_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(oni_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
--	        WHEN m.maximum = c.oni_coefficient_minus_zero_lag OR m.minimum = c.oni_coefficient_minus_zero_lag THEN 0
			WHEN m.maximum = c.oni_coefficient_minus_one_lag OR m.minimum = c.oni_coefficient_minus_one_lag THEN 1
			WHEN m.maximum = c.oni_coefficient_minus_two_lag OR m.minimum = c.oni_coefficient_minus_two_lag THEN 2
			WHEN m.maximum = c.oni_coefficient_minus_three_lag OR m.minimum = c.oni_coefficient_minus_three_lag THEN 3
			WHEN m.maximum = c.oni_coefficient_minus_four_lag OR m.minimum = c.oni_coefficient_minus_four_lag THEN 4
			WHEN m.maximum = c.oni_coefficient_minus_five_lag OR m.minimum = c.oni_coefficient_minus_five_lag THEN 5
			WHEN m.maximum = c.oni_coefficient_minus_six_lag OR m.minimum = c.oni_coefficient_minus_six_lag THEN 6
			WHEN m.maximum = c.oni_coefficient_minus_seven_lag OR m.minimum = c.oni_coefficient_minus_seven_lag THEN 7
			WHEN m.maximum = c.oni_coefficient_minus_eight_lag OR m.minimum = c.oni_coefficient_minus_eight_lag THEN 8
			WHEN m.maximum = c.oni_coefficient_minus_nine_lag OR m.minimum = c.oni_coefficient_minus_nine_lag THEN 9
			WHEN m.maximum = c.oni_coefficient_minus_ten_lag OR m.minimum = c.oni_coefficient_minus_ten_lag THEN 10
			WHEN m.maximum = c.oni_coefficient_minus_eleven_lag OR m.minimum = c.oni_coefficient_minus_eleven_lag THEN 11 
			WHEN m.maximum = c.oni_coefficient_minus_twelve_lag OR m.minimum = c.oni_coefficient_minus_twelve_lag THEN 12 
			END as coefficient_lag
FROM maxmin as m, standardization as s, casual_maps_precipitation_oni_con_everything as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficient_maps_precipitation_oni_con_everything as b) as b 
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;

-- \copy (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients) > 1 AND b.coefficients < 0 THEN -1.01 WHEN abs(b.coefficients) > 1 AND b.coefficients > 0 THEN 1.01 ELSE b.coefficients END as coefficient FROM beta_coefficient_maps_precipitation_oni_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_oni_con_everything.csv' DELIMITER ';' CSV HEADER;

\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficient_maps_precipitation_oni_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_oni_con_everything.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients >= 0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients <= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_oni_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_oni_con_everything_coefficient_lag_red.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients <= -0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients >= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_oni_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_oni_con_everything_coefficient_lag_blue.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------Oceanic Nino Index controlled for Nino 1+2, Nino 3, Nino4, Trans Nino Index--------------------------------------------------------

------------------------------------------------------------------------------Trans Nino Index controlled for Nino 1+2, Nino 3, Nino4, Oceanic Nino Index--------------------------------------------------------


/*DROP TABLE IF EXISTS casual_maps_precipitation_tni_con_everything
;
CREATE TABLE casual_maps_precipitation_tni_con_everything
(longditude real,
laditude real,
tni_coefficient_minus_zero_lag numeric,
tni_coefficient_minus_one_lag numeric,
tni_coefficient_minus_two_lag numeric,
tni_coefficient_minus_three_lag numeric,
tni_coefficient_minus_four_lag numeric,
tni_coefficient_minus_five_lag numeric,
tni_coefficient_minus_six_lag numeric,
tni_coefficient_minus_seven_lag numeric,
tni_coefficient_minus_eight_lag numeric,
tni_coefficient_minus_nine_lag numeric,
tni_coefficient_minus_ten_lag numeric,
tni_coefficient_minus_eleven_lag numeric,
tni_coefficient_minus_twelve_lag numeric
);
*/


\copy casual_maps_precipitation_tni_con_everything (longditude,laditude,tni_coefficient_minus_zero_lag,tni_coefficient_minus_one_lag,tni_coefficient_minus_two_lag, tni_coefficient_minus_three_lag,tni_coefficient_minus_four_lag,tni_coefficient_minus_five_lag, tni_coefficient_minus_six_lag, tni_coefficient_minus_seven_lag,tni_coefficient_minus_eight_lag, tni_coefficient_minus_nine_lag, tni_coefficient_minus_ten_lag, tni_coefficient_minus_eleven_lag, tni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/tni_controlling_for_everything.csv' DELIMITER ';';


DROP TABLE IF EXISTS beta_coefficient_maps_precipitation_tni_con_everything;
CREATE TABLE beta_coefficient_maps_precipitation_tni_con_everything as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(/*array_agg(b.tni_coefficient_minus_zero_lag) ||*/ array_agg(b.tni_coefficient_minus_one_lag) || array_agg(b.tni_coefficient_minus_two_lag) || array_agg(b.tni_coefficient_minus_three_lag) ||
											   array_agg(b.tni_coefficient_minus_four_lag) || array_agg(b.tni_coefficient_minus_five_lag) || array_agg(b.tni_coefficient_minus_six_lag) || array_agg(b.tni_coefficient_minus_seven_lag) ||
											   array_agg(b.tni_coefficient_minus_eight_lag)|| array_agg(b.tni_coefficient_minus_nine_lag) || array_agg(b.tni_coefficient_minus_ten_lag) || array_agg(b.tni_coefficient_minus_eleven_lag) ||
											   array_agg(b.tni_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(/*array_agg(b.tni_coefficient_minus_zero_lag) ||*/ array_agg(b.tni_coefficient_minus_one_lag) || array_agg(b.tni_coefficient_minus_two_lag) || array_agg(b.tni_coefficient_minus_three_lag) ||
											   array_agg(b.tni_coefficient_minus_four_lag) || array_agg(b.tni_coefficient_minus_five_lag) || array_agg(b.tni_coefficient_minus_six_lag) || array_agg(b.tni_coefficient_minus_seven_lag) ||
											   array_agg(b.tni_coefficient_minus_eight_lag)|| array_agg(b.tni_coefficient_minus_nine_lag) || array_agg(b.tni_coefficient_minus_ten_lag) || array_agg(b.tni_coefficient_minus_eleven_lag) ||
											   array_agg(b.tni_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_precipitation_tni_con_everything as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude, CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.tni_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(tni_stddev/s.precip_anomaly_stddev) END as coefficients,
            CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
--	        WHEN m.maximum = c.tni_coefficient_minus_zero_lag OR m.minimum = c.tni_coefficient_minus_zero_lag THEN 0
			WHEN m.maximum = c.tni_coefficient_minus_one_lag OR m.minimum = c.tni_coefficient_minus_one_lag THEN 1
			WHEN m.maximum = c.tni_coefficient_minus_two_lag OR m.minimum = c.tni_coefficient_minus_two_lag THEN 2
			WHEN m.maximum = c.tni_coefficient_minus_three_lag OR m.minimum = c.tni_coefficient_minus_three_lag THEN 3
			WHEN m.maximum = c.tni_coefficient_minus_four_lag OR m.minimum = c.tni_coefficient_minus_four_lag THEN 4
			WHEN m.maximum = c.tni_coefficient_minus_five_lag OR m.minimum = c.tni_coefficient_minus_five_lag THEN 5
			WHEN m.maximum = c.tni_coefficient_minus_six_lag OR m.minimum = c.tni_coefficient_minus_six_lag THEN 6
			WHEN m.maximum = c.tni_coefficient_minus_seven_lag OR m.minimum = c.tni_coefficient_minus_seven_lag THEN 7
			WHEN m.maximum = c.tni_coefficient_minus_eight_lag OR m.minimum = c.tni_coefficient_minus_eight_lag THEN 8
			WHEN m.maximum = c.tni_coefficient_minus_nine_lag OR m.minimum = c.tni_coefficient_minus_nine_lag THEN 9
			WHEN m.maximum = c.tni_coefficient_minus_ten_lag OR m.minimum = c.tni_coefficient_minus_ten_lag THEN 10
			WHEN m.maximum = c.tni_coefficient_minus_eleven_lag OR m.minimum = c.tni_coefficient_minus_eleven_lag THEN 11 
			WHEN m.maximum = c.tni_coefficient_minus_twelve_lag OR m.minimum = c.tni_coefficient_minus_twelve_lag THEN 12 
			END as coefficient_lag
FROM maxmin as m, standardization as s, casual_maps_precipitation_tni_con_everything as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficient_maps_precipitation_tni_con_everything as b) as b 
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficient_maps_precipitation_tni_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_tni_con_everything.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients >= 0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients <= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_tni_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_tni_con_everything_coefficient_lag_red.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients <= -0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients >= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_tni_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_tni_con_everything_coefficient_lag_blue.csv' DELIMITER ';' CSV HEADER;


------------------------------------------------------------------------------Trans Nino Index controlled for Nino 1+2, Nino 3, Nino4, Oceanic Nino Index--------------------------------------------------------

------------------------------------------------------------------------------Nino 1+2 Index controlled for Nino 3, Nino4, Oceanic Nino Index, TNI---------------------------------------------------------------


/*
DROP TABLE IF EXISTS casual_maps_precipitation_nino12_con_everything
;
CREATE TABLE casual_maps_precipitation_nino12_con_everything
(longditude real,
laditude real,
nino12_coefficient_minus_zero_lag numeric,
nino12_coefficient_minus_one_lag numeric,
nino12_coefficient_minus_two_lag numeric,
nino12_coefficient_minus_three_lag numeric,
nino12_coefficient_minus_four_lag numeric,
nino12_coefficient_minus_five_lag numeric,
nino12_coefficient_minus_six_lag numeric,
nino12_coefficient_minus_seven_lag numeric,
nino12_coefficient_minus_eight_lag numeric,
nino12_coefficient_minus_nine_lag numeric,
nino12_coefficient_minus_ten_lag numeric,
nino12_coefficient_minus_eleven_lag numeric,
nino12_coefficient_minus_twelve_lag numeric
);
*/


\copy casual_maps_precipitation_nino12_con_everything (longditude,laditude,nino12_coefficient_minus_zero_lag,nino12_coefficient_minus_one_lag,nino12_coefficient_minus_two_lag, nino12_coefficient_minus_three_lag,nino12_coefficient_minus_four_lag,nino12_coefficient_minus_five_lag, nino12_coefficient_minus_six_lag, nino12_coefficient_minus_seven_lag,nino12_coefficient_minus_eight_lag, nino12_coefficient_minus_nine_lag, nino12_coefficient_minus_ten_lag, nino12_coefficient_minus_eleven_lag, nino12_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/nino12_controlling_for_everything.csv' DELIMITER ';';


DROP TABLE IF EXISTS beta_coefficient_maps_precipitation_nino12_con_everything;
CREATE TABLE beta_coefficient_maps_precipitation_nino12_con_everything as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(/*array_agg(b.nino12_coefficient_minus_zero_lag) ||*/ array_agg(b.nino12_coefficient_minus_one_lag) || array_agg(b.nino12_coefficient_minus_two_lag) || array_agg(b.nino12_coefficient_minus_three_lag) ||
											   array_agg(b.nino12_coefficient_minus_four_lag) || array_agg(b.nino12_coefficient_minus_five_lag) || array_agg(b.nino12_coefficient_minus_six_lag) || array_agg(b.nino12_coefficient_minus_seven_lag) ||
											   array_agg(b.nino12_coefficient_minus_eight_lag)|| array_agg(b.nino12_coefficient_minus_nine_lag) || array_agg(b.nino12_coefficient_minus_ten_lag) || array_agg(b.nino12_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino12_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(/*array_agg(b.nino12_coefficient_minus_zero_lag) ||*/ array_agg(b.nino12_coefficient_minus_one_lag) || array_agg(b.nino12_coefficient_minus_two_lag) || array_agg(b.nino12_coefficient_minus_three_lag) ||
											   array_agg(b.nino12_coefficient_minus_four_lag) || array_agg(b.nino12_coefficient_minus_five_lag) || array_agg(b.nino12_coefficient_minus_six_lag) || array_agg(b.nino12_coefficient_minus_seven_lag) ||
											   array_agg(b.nino12_coefficient_minus_eight_lag)|| array_agg(b.nino12_coefficient_minus_nine_lag) || array_agg(b.nino12_coefficient_minus_ten_lag) || array_agg(b.nino12_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino12_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_precipitation_nino12_con_everything as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.nino12_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(nino12_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
--	        WHEN m.maximum = c.nino12_coefficient_minus_zero_lag OR m.minimum = c.nino12_coefficient_minus_zero_lag THEN 0
			WHEN m.maximum = c.nino12_coefficient_minus_one_lag OR m.minimum = c.nino12_coefficient_minus_one_lag THEN 1
			WHEN m.maximum = c.nino12_coefficient_minus_two_lag OR m.minimum = c.nino12_coefficient_minus_two_lag THEN 2
			WHEN m.maximum = c.nino12_coefficient_minus_three_lag OR m.minimum = c.nino12_coefficient_minus_three_lag THEN 3
			WHEN m.maximum = c.nino12_coefficient_minus_four_lag OR m.minimum = c.nino12_coefficient_minus_four_lag THEN 4
			WHEN m.maximum = c.nino12_coefficient_minus_five_lag OR m.minimum = c.nino12_coefficient_minus_five_lag THEN 5
			WHEN m.maximum = c.nino12_coefficient_minus_six_lag OR m.minimum = c.nino12_coefficient_minus_six_lag THEN 6
			WHEN m.maximum = c.nino12_coefficient_minus_seven_lag OR m.minimum = c.nino12_coefficient_minus_seven_lag THEN 7
			WHEN m.maximum = c.nino12_coefficient_minus_eight_lag OR m.minimum = c.nino12_coefficient_minus_eight_lag THEN 8
			WHEN m.maximum = c.nino12_coefficient_minus_nine_lag OR m.minimum = c.nino12_coefficient_minus_nine_lag THEN 9
			WHEN m.maximum = c.nino12_coefficient_minus_ten_lag OR m.minimum = c.nino12_coefficient_minus_ten_lag THEN 10
			WHEN m.maximum = c.nino12_coefficient_minus_eleven_lag OR m.minimum = c.nino12_coefficient_minus_eleven_lag THEN 11 
			WHEN m.maximum = c.nino12_coefficient_minus_twelve_lag OR m.minimum = c.nino12_coefficient_minus_twelve_lag THEN 12 
			END as coefficient_lag
FROM maxmin as m, standardization as s, casual_maps_precipitation_nino12_con_everything as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficient_maps_precipitation_nino12_con_everything as b) as b 
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficient_maps_precipitation_nino12_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino12_con_everything.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients >= 0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients <= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_nino12_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino12_con_everything_coefficient_lag_red.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients <= -0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients >= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_nino12_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino12_con_everything_coefficient_lag_blue.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------Nino 1+2 Index controlled for Nino 3, Nino4, Oceanic Nino Index, TNI---------------------------------------------------------------

------------------------------------------------------------------------------Nino 3 Index controlled for Nino 1+2, Nino4, Oceanic Nino Index, TNI---------------------------------------------------------------


/*
DROP TABLE IF EXISTS casual_maps_precipitation_nino3_con_everything
;
CREATE TABLE casual_maps_precipitation_nino3_con_everything
(longditude real,
laditude real,
nino3_coefficient_minus_zero_lag numeric,
nino3_coefficient_minus_one_lag numeric,
nino3_coefficient_minus_two_lag numeric,
nino3_coefficient_minus_three_lag numeric,
nino3_coefficient_minus_four_lag numeric,
nino3_coefficient_minus_five_lag numeric,
nino3_coefficient_minus_six_lag numeric,
nino3_coefficient_minus_seven_lag numeric,
nino3_coefficient_minus_eight_lag numeric,
nino3_coefficient_minus_nine_lag numeric,
nino3_coefficient_minus_ten_lag numeric,
nino3_coefficient_minus_eleven_lag numeric,
nino3_coefficient_minus_twelve_lag numeric
);
*/


\copy casual_maps_precipitation_nino3_con_everything (longditude,laditude,nino3_coefficient_minus_zero_lag,nino3_coefficient_minus_one_lag,nino3_coefficient_minus_two_lag, nino3_coefficient_minus_three_lag,nino3_coefficient_minus_four_lag,nino3_coefficient_minus_five_lag, nino3_coefficient_minus_six_lag, nino3_coefficient_minus_seven_lag,nino3_coefficient_minus_eight_lag, nino3_coefficient_minus_nine_lag, nino3_coefficient_minus_ten_lag, nino3_coefficient_minus_eleven_lag, nino3_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/nino3_controlling_for_everything.csv' DELIMITER ';';


DROP TABLE IF EXISTS beta_coefficient_maps_precipitation_nino3_con_everything;
CREATE TABLE beta_coefficient_maps_precipitation_nino3_con_everything as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(/*array_agg(b.nino3_coefficient_minus_zero_lag) ||*/ array_agg(b.nino3_coefficient_minus_one_lag) || array_agg(b.nino3_coefficient_minus_two_lag) || array_agg(b.nino3_coefficient_minus_three_lag) ||
											   array_agg(b.nino3_coefficient_minus_four_lag) || array_agg(b.nino3_coefficient_minus_five_lag) || array_agg(b.nino3_coefficient_minus_six_lag) || array_agg(b.nino3_coefficient_minus_seven_lag) ||
											   array_agg(b.nino3_coefficient_minus_eight_lag)|| array_agg(b.nino3_coefficient_minus_nine_lag) || array_agg(b.nino3_coefficient_minus_ten_lag) || array_agg(b.nino3_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino3_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(/*array_agg(b.nino3_coefficient_minus_zero_lag) ||*/ array_agg(b.nino3_coefficient_minus_one_lag) || array_agg(b.nino3_coefficient_minus_two_lag) || array_agg(b.nino3_coefficient_minus_three_lag) ||
											   array_agg(b.nino3_coefficient_minus_four_lag) || array_agg(b.nino3_coefficient_minus_five_lag) || array_agg(b.nino3_coefficient_minus_six_lag) || array_agg(b.nino3_coefficient_minus_seven_lag) ||
											   array_agg(b.nino3_coefficient_minus_eight_lag)|| array_agg(b.nino3_coefficient_minus_nine_lag) || array_agg(b.nino3_coefficient_minus_ten_lag) || array_agg(b.nino3_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino3_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_precipitation_nino3_con_everything as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.nino3_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(nino3_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
--	        WHEN m.maximum = c.nino3_coefficient_minus_zero_lag OR m.minimum = c.nino3_coefficient_minus_zero_lag THEN 0
			WHEN m.maximum = c.nino3_coefficient_minus_one_lag OR m.minimum = c.nino3_coefficient_minus_one_lag THEN 1
			WHEN m.maximum = c.nino3_coefficient_minus_two_lag OR m.minimum = c.nino3_coefficient_minus_two_lag THEN 2
			WHEN m.maximum = c.nino3_coefficient_minus_three_lag OR m.minimum = c.nino3_coefficient_minus_three_lag THEN 3
			WHEN m.maximum = c.nino3_coefficient_minus_four_lag OR m.minimum = c.nino3_coefficient_minus_four_lag THEN 4
			WHEN m.maximum = c.nino3_coefficient_minus_five_lag OR m.minimum = c.nino3_coefficient_minus_five_lag THEN 5
			WHEN m.maximum = c.nino3_coefficient_minus_six_lag OR m.minimum = c.nino3_coefficient_minus_six_lag THEN 6
			WHEN m.maximum = c.nino3_coefficient_minus_seven_lag OR m.minimum = c.nino3_coefficient_minus_seven_lag THEN 7
			WHEN m.maximum = c.nino3_coefficient_minus_eight_lag OR m.minimum = c.nino3_coefficient_minus_eight_lag THEN 8
			WHEN m.maximum = c.nino3_coefficient_minus_nine_lag OR m.minimum = c.nino3_coefficient_minus_nine_lag THEN 9
			WHEN m.maximum = c.nino3_coefficient_minus_ten_lag OR m.minimum = c.nino3_coefficient_minus_ten_lag THEN 10
			WHEN m.maximum = c.nino3_coefficient_minus_eleven_lag OR m.minimum = c.nino3_coefficient_minus_eleven_lag THEN 11 
			WHEN m.maximum = c.nino3_coefficient_minus_twelve_lag OR m.minimum = c.nino3_coefficient_minus_twelve_lag THEN 12 
			END as coefficient_lag
FROM maxmin as m, standardization as s, casual_maps_precipitation_nino3_con_everything as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficient_maps_precipitation_nino3_con_everything as b) as b 
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficient_maps_precipitation_nino3_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino3_con_everything.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients >= 0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients <= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_nino3_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino3_con_everything_coefficient_lag_red.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients <= -0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients >= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_nino3_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino3_con_everything_coefficient_lag_blue.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------Nino 3 Index controlled for Nino 1+2, Nino4, Oceanic Nino Index, TNI---------------------------------------------------------------

------------------------------------------------------------------------------Nino 4 Index controlled for Nino 1+2, Nino3, Oceanic Nino Index, TNI---------------------------------------------------------------

/*
DROP TABLE IF EXISTS casual_maps_precipitation_nino4_con_everything
;
CREATE TABLE casual_maps_precipitation_nino4_con_everything
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


\copy casual_maps_precipitation_nino4_con_everything (longditude,laditude,nino4_coefficient_minus_zero_lag,nino4_coefficient_minus_one_lag,nino4_coefficient_minus_two_lag, nino4_coefficient_minus_three_lag,nino4_coefficient_minus_four_lag,nino4_coefficient_minus_five_lag, nino4_coefficient_minus_six_lag, nino4_coefficient_minus_seven_lag,nino4_coefficient_minus_eight_lag, nino4_coefficient_minus_nine_lag, nino4_coefficient_minus_ten_lag, nino4_coefficient_minus_eleven_lag, nino4_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/nino4_controlling_for_everything.csv' DELIMITER ';';


DROP TABLE IF EXISTS beta_coefficient_maps_precipitation_nino4_con_everything;
CREATE TABLE beta_coefficient_maps_precipitation_nino4_con_everything as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(/*array_agg(b.nino4_coefficient_minus_zero_lag) ||*/ array_agg(b.nino4_coefficient_minus_one_lag) || array_agg(b.nino4_coefficient_minus_two_lag) || array_agg(b.nino4_coefficient_minus_three_lag) ||
											   array_agg(b.nino4_coefficient_minus_four_lag) || array_agg(b.nino4_coefficient_minus_five_lag) || array_agg(b.nino4_coefficient_minus_six_lag) || array_agg(b.nino4_coefficient_minus_seven_lag) ||
											   array_agg(b.nino4_coefficient_minus_eight_lag)|| array_agg(b.nino4_coefficient_minus_nine_lag) || array_agg(b.nino4_coefficient_minus_ten_lag) || array_agg(b.nino4_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino4_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(/*array_agg(b.nino4_coefficient_minus_zero_lag) ||*/ array_agg(b.nino4_coefficient_minus_one_lag) || array_agg(b.nino4_coefficient_minus_two_lag) || array_agg(b.nino4_coefficient_minus_three_lag) ||
											   array_agg(b.nino4_coefficient_minus_four_lag) || array_agg(b.nino4_coefficient_minus_five_lag) || array_agg(b.nino4_coefficient_minus_six_lag) || array_agg(b.nino4_coefficient_minus_seven_lag) ||
											   array_agg(b.nino4_coefficient_minus_eight_lag)|| array_agg(b.nino4_coefficient_minus_nine_lag) || array_agg(b.nino4_coefficient_minus_ten_lag) || array_agg(b.nino4_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino4_coefficient_minus_twelve_lag)) as minimum 
FROM casual_maps_precipitation_nino4_con_everything as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.nino4_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(nino4_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
--          WHEN m.maximum = c.nino4_coefficient_minus_zero_lag OR m.minimum = c.nino4_coefficient_minus_zero_lag THEN 0
			WHEN m.maximum = c.nino4_coefficient_minus_one_lag OR m.minimum = c.nino4_coefficient_minus_one_lag THEN 1
			WHEN m.maximum = c.nino4_coefficient_minus_two_lag OR m.minimum = c.nino4_coefficient_minus_two_lag THEN 2
			WHEN m.maximum = c.nino4_coefficient_minus_three_lag OR m.minimum = c.nino4_coefficient_minus_three_lag THEN 3
			WHEN m.maximum = c.nino4_coefficient_minus_four_lag OR m.minimum = c.nino4_coefficient_minus_four_lag THEN 4
			WHEN m.maximum = c.nino4_coefficient_minus_five_lag OR m.minimum = c.nino4_coefficient_minus_five_lag THEN 5
			WHEN m.maximum = c.nino4_coefficient_minus_six_lag OR m.minimum = c.nino4_coefficient_minus_six_lag THEN 6
			WHEN m.maximum = c.nino4_coefficient_minus_seven_lag OR m.minimum = c.nino4_coefficient_minus_seven_lag THEN 7
			WHEN m.maximum = c.nino4_coefficient_minus_eight_lag OR m.minimum = c.nino4_coefficient_minus_eight_lag THEN 8
			WHEN m.maximum = c.nino4_coefficient_minus_nine_lag OR m.minimum = c.nino4_coefficient_minus_nine_lag THEN 9
			WHEN m.maximum = c.nino4_coefficient_minus_ten_lag OR m.minimum = c.nino4_coefficient_minus_ten_lag THEN 10
			WHEN m.maximum = c.nino4_coefficient_minus_eleven_lag OR m.minimum = c.nino4_coefficient_minus_eleven_lag THEN 11 
			WHEN m.maximum = c.nino4_coefficient_minus_twelve_lag OR m.minimum = c.nino4_coefficient_minus_twelve_lag THEN 12 
			END as coefficient_lag
FROM maxmin as m, standardization as s, casual_maps_precipitation_nino4_con_everything as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficient_maps_precipitation_nino4_con_everything as b) as b 
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficient_maps_precipitation_nino4_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino4_con_everything.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients >= 0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients <= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_nino4_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino4_con_everything_coefficient_lag_red.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, CASE WHEN b.coefficients <= -0.1 THEN b.coefficient_lag WHEN b.coefficients IS NULL OR b.coefficients >= 0 THEN NULL END FROM beta_coefficient_maps_precipitation_nino4_con_everything as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/everything_without_nino34/beta_coefficients_maps_precipitation_nino4_con_everything_coefficient_lag_blue.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------Nino 4 Index controlled for Nino 1+2, Nino3, Oceanic Nino Index, TNI---------------------------------------------------------------