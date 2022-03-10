/*Preparation of the tables for the PCMCI algorithm to determine the causal maps. The PCMCI is implemented with the Tigramite Python package.
https://github.com/jakobrunge/tigramite/blob/master/README.md 
*/


------------------------------------------------------------------------------ONI -------------------------------------------------------------------------------------------------


--Prepare casual_maps_wo_conditioning_precipitation_oni_con_everything with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_wo_conditioning_precipitation_oni_con_everything_2002_2021
;
CREATE TABLE casual_maps_wo_conditioning_precipitation_oni_con_everything_2002_2021
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

\copy casual_maps_wo_conditioning_precipitation_oni_con_everything_2002_2021 (longditude,laditude,oni_coefficient_minus_zero_lag,oni_coefficient_minus_one_lag,oni_coefficient_minus_two_lag, oni_coefficient_minus_three_lag,oni_coefficient_minus_four_lag,oni_coefficient_minus_five_lag, oni_coefficient_minus_six_lag, oni_coefficient_minus_seven_lag,oni_coefficient_minus_eight_lag, oni_coefficient_minus_nine_lag, oni_coefficient_minus_ten_lag, oni_coefficient_minus_eleven_lag, oni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/oni_wo_conditioning_2002_2021.csv' DELIMITER ';';




--Casual maps for oni with maximum coefficients (lag (0) and 1-12) only 

DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_oni_wo_conditioning_2002_2021;
CREATE TABLE beta_coefficients_maps_precipitation_oni_wo_conditioning_2002_2021 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.oni_coefficient_minus_zero_lag) || array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.oni_coefficient_minus_zero_lag) || array_agg(b.oni_coefficient_minus_one_lag) || array_agg(b.oni_coefficient_minus_two_lag) || array_agg(b.oni_coefficient_minus_three_lag) ||
											   array_agg(b.oni_coefficient_minus_four_lag) || array_agg(b.oni_coefficient_minus_five_lag) || array_agg(b.oni_coefficient_minus_six_lag) || array_agg(b.oni_coefficient_minus_seven_lag) ||
											   array_agg(b.oni_coefficient_minus_eight_lag)|| array_agg(b.oni_coefficient_minus_nine_lag) || array_agg(b.oni_coefficient_minus_ten_lag) || array_agg(b.oni_coefficient_minus_eleven_lag) ||
											   array_agg(b.oni_coefficient_minus_twelve_lag)) as minimum
FROM casual_maps_wo_conditioning_precipitation_oni_con_everything_2002_2021 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.oni_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(oni_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
	        WHEN m.maximum = c.oni_coefficient_minus_zero_lag OR m.minimum = c.oni_coefficient_minus_zero_lag THEN 0
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
FROM maxmin as m, standardization_2002_2021 as s, casual_maps_wo_conditioning_precipitation_oni_con_everything_2002_2021 as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficients_maps_precipitation_oni_wo_conditioning_2002_2021 as b) as b
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;

\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficients_maps_precipitation_oni_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_oni_wo_conditioning_2002_2021.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, b.coefficient_lag FROM beta_coefficients_maps_precipitation_oni_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_oni_wo_conditioning_lag_2002_2021.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------ONI -------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------Nino1+2 ---------------------------------------------------------------------------------------------


--Prepare casual_maps_wo_conditioning_precipitation_nino12_con_everything with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_wo_conditioning_precipitation_nino12_con_everything_2002_2021
;
CREATE TABLE casual_maps_wo_conditioning_precipitation_nino12_con_everything_2002_2021
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

\copy casual_maps_wo_conditioning_precipitation_nino12_con_everything_2002_2021 (longditude,laditude,nino12_coefficient_minus_zero_lag,nino12_coefficient_minus_one_lag,nino12_coefficient_minus_two_lag, nino12_coefficient_minus_three_lag,nino12_coefficient_minus_four_lag,nino12_coefficient_minus_five_lag, nino12_coefficient_minus_six_lag, nino12_coefficient_minus_seven_lag,nino12_coefficient_minus_eight_lag, nino12_coefficient_minus_nine_lag, nino12_coefficient_minus_ten_lag, nino12_coefficient_minus_eleven_lag, nino12_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/nino12_wo_conditioning_2002_2021.csv' DELIMITER ';';




--Casual maps for oni with maximum coefficients (lag (0) and 1-12) only 

DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_nino12_wo_conditioning_2002_2021;
CREATE TABLE beta_coefficients_maps_precipitation_nino12_wo_conditioning_2002_2021 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.nino12_coefficient_minus_zero_lag) || array_agg(b.nino12_coefficient_minus_one_lag) || array_agg(b.nino12_coefficient_minus_two_lag) || array_agg(b.nino12_coefficient_minus_three_lag) ||
											   array_agg(b.nino12_coefficient_minus_four_lag) || array_agg(b.nino12_coefficient_minus_five_lag) || array_agg(b.nino12_coefficient_minus_six_lag) || array_agg(b.nino12_coefficient_minus_seven_lag) ||
											   array_agg(b.nino12_coefficient_minus_eight_lag)|| array_agg(b.nino12_coefficient_minus_nine_lag) || array_agg(b.nino12_coefficient_minus_ten_lag) || array_agg(b.nino12_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino12_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.nino12_coefficient_minus_zero_lag) || array_agg(b.nino12_coefficient_minus_one_lag) || array_agg(b.nino12_coefficient_minus_two_lag) || array_agg(b.nino12_coefficient_minus_three_lag) ||
											   array_agg(b.nino12_coefficient_minus_four_lag) || array_agg(b.nino12_coefficient_minus_five_lag) || array_agg(b.nino12_coefficient_minus_six_lag) || array_agg(b.nino12_coefficient_minus_seven_lag) ||
											   array_agg(b.nino12_coefficient_minus_eight_lag)|| array_agg(b.nino12_coefficient_minus_nine_lag) || array_agg(b.nino12_coefficient_minus_ten_lag) || array_agg(b.nino12_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino12_coefficient_minus_twelve_lag)) as minimum
FROM casual_maps_wo_conditioning_precipitation_nino12_con_everything_2002_2021 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.nino12_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(nino12_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
	        WHEN m.maximum = c.nino12_coefficient_minus_zero_lag OR m.minimum = c.nino12_coefficient_minus_zero_lag THEN 0
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
FROM maxmin as m, standardization_2002_2021 as s, casual_maps_wo_conditioning_precipitation_nino12_con_everything_2002_2021 as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficients_maps_precipitation_nino12_wo_conditioning_2002_2021 as b) as b
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficients_maps_precipitation_nino12_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_nino12_wo_conditioning_2002_2021.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, b.coefficient_lag FROM beta_coefficients_maps_precipitation_nino12_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_nino12_wo_conditioning_lag_2002_2021.csv' DELIMITER ';' CSV HEADER;


------------------------------------------------------------------------------Nino1+2 ------------------------------------------------------------------------------------------

------------------------------------------------------------------------------Trans Nino Index ---------------------------------------------------------------------------------


--Prepare casual_maps_wo_conditioning_precipitation_tni_con_everything with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_wo_conditioning_precipitation_tni_con_everything_2002_2021
;
CREATE TABLE casual_maps_wo_conditioning_precipitation_tni_con_everything_2002_2021
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

\copy casual_maps_wo_conditioning_precipitation_tni_con_everything_2002_2021 (longditude,laditude,tni_coefficient_minus_zero_lag,tni_coefficient_minus_one_lag,tni_coefficient_minus_two_lag, tni_coefficient_minus_three_lag,tni_coefficient_minus_four_lag,tni_coefficient_minus_five_lag, tni_coefficient_minus_six_lag, tni_coefficient_minus_seven_lag,tni_coefficient_minus_eight_lag, tni_coefficient_minus_nine_lag, tni_coefficient_minus_ten_lag, tni_coefficient_minus_eleven_lag, tni_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/tni_wo_conditioning_2002_2021.csv' DELIMITER ';';




--Casual maps for oni with maximum coefficients (lag (0) and 1-12) only 

DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_tni_wo_conditioning_2002_2021;
CREATE TABLE beta_coefficients_maps_precipitation_tni_wo_conditioning_2002_2021 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.tni_coefficient_minus_zero_lag) || array_agg(b.tni_coefficient_minus_one_lag) || array_agg(b.tni_coefficient_minus_two_lag) || array_agg(b.tni_coefficient_minus_three_lag) ||
											   array_agg(b.tni_coefficient_minus_four_lag) || array_agg(b.tni_coefficient_minus_five_lag) || array_agg(b.tni_coefficient_minus_six_lag) || array_agg(b.tni_coefficient_minus_seven_lag) ||
											   array_agg(b.tni_coefficient_minus_eight_lag)|| array_agg(b.tni_coefficient_minus_nine_lag) || array_agg(b.tni_coefficient_minus_ten_lag) || array_agg(b.tni_coefficient_minus_eleven_lag) ||
											   array_agg(b.tni_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.tni_coefficient_minus_zero_lag) || array_agg(b.tni_coefficient_minus_one_lag) || array_agg(b.tni_coefficient_minus_two_lag) || array_agg(b.tni_coefficient_minus_three_lag) ||
											   array_agg(b.tni_coefficient_minus_four_lag) || array_agg(b.tni_coefficient_minus_five_lag) || array_agg(b.tni_coefficient_minus_six_lag) || array_agg(b.tni_coefficient_minus_seven_lag) ||
											   array_agg(b.tni_coefficient_minus_eight_lag)|| array_agg(b.tni_coefficient_minus_nine_lag) || array_agg(b.tni_coefficient_minus_ten_lag) || array_agg(b.tni_coefficient_minus_eleven_lag) ||
											   array_agg(b.tni_coefficient_minus_twelve_lag)) as minimum
FROM casual_maps_wo_conditioning_precipitation_tni_con_everything_2002_2021 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.tni_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(tni_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
	        WHEN m.maximum = c.tni_coefficient_minus_zero_lag OR m.minimum = c.tni_coefficient_minus_zero_lag THEN 0
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
FROM maxmin as m, standardization_2002_2021 as s, casual_maps_wo_conditioning_precipitation_tni_con_everything_2002_2021 as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficients_maps_precipitation_tni_wo_conditioning_2002_2021 as b) as b
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficients_maps_precipitation_tni_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_tni_wo_conditioning_2002_2021.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, b.coefficient_lag FROM beta_coefficients_maps_precipitation_tni_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_tni_wo_conditioning_lag_2002_2021.csv' DELIMITER ';' CSV HEADER;

------------------------------------------------------------------------------Trans Nino Index ------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------Nino 3 Index ----------------------------------------------------------------------------------------------------------------------


--Prepare casual_maps_wo_conditioning_precipitation_nino3_con_everything with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_wo_conditioning_precipitation_nino3_con_everything_2002_2021
;
CREATE TABLE casual_maps_wo_conditioning_precipitation_nino3_con_everything_2002_2021
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

\copy casual_maps_wo_conditioning_precipitation_nino3_con_everything_2002_2021 (longditude,laditude,nino3_coefficient_minus_zero_lag,nino3_coefficient_minus_one_lag,nino3_coefficient_minus_two_lag, nino3_coefficient_minus_three_lag,nino3_coefficient_minus_four_lag,nino3_coefficient_minus_five_lag, nino3_coefficient_minus_six_lag, nino3_coefficient_minus_seven_lag,nino3_coefficient_minus_eight_lag, nino3_coefficient_minus_nine_lag, nino3_coefficient_minus_ten_lag, nino3_coefficient_minus_eleven_lag, nino3_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/nino3_wo_conditioning_2002_2021.csv' DELIMITER ';';




--Casual maps for oni with maximum coefficients (lag (0) and 1-12) only 

DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_nino3_wo_conditioning_2002_2021;
CREATE TABLE beta_coefficients_maps_precipitation_nino3_wo_conditioning_2002_2021 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.nino3_coefficient_minus_zero_lag) || array_agg(b.nino3_coefficient_minus_one_lag) || array_agg(b.nino3_coefficient_minus_two_lag) || array_agg(b.nino3_coefficient_minus_three_lag) ||
											   array_agg(b.nino3_coefficient_minus_four_lag) || array_agg(b.nino3_coefficient_minus_five_lag) || array_agg(b.nino3_coefficient_minus_six_lag) || array_agg(b.nino3_coefficient_minus_seven_lag) ||
											   array_agg(b.nino3_coefficient_minus_eight_lag)|| array_agg(b.nino3_coefficient_minus_nine_lag) || array_agg(b.nino3_coefficient_minus_ten_lag) || array_agg(b.nino3_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino3_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.nino3_coefficient_minus_zero_lag) || array_agg(b.nino3_coefficient_minus_one_lag) || array_agg(b.nino3_coefficient_minus_two_lag) || array_agg(b.nino3_coefficient_minus_three_lag) ||
											   array_agg(b.nino3_coefficient_minus_four_lag) || array_agg(b.nino3_coefficient_minus_five_lag) || array_agg(b.nino3_coefficient_minus_six_lag) || array_agg(b.nino3_coefficient_minus_seven_lag) ||
											   array_agg(b.nino3_coefficient_minus_eight_lag)|| array_agg(b.nino3_coefficient_minus_nine_lag) || array_agg(b.nino3_coefficient_minus_ten_lag) || array_agg(b.nino3_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino3_coefficient_minus_twelve_lag)) as minimum
FROM casual_maps_wo_conditioning_precipitation_nino3_con_everything_2002_2021 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.nino3_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(nino3_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
	        WHEN m.maximum = c.nino3_coefficient_minus_zero_lag OR m.minimum = c.nino3_coefficient_minus_zero_lag THEN 0
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
FROM maxmin as m, standardization_2002_2021 as s, casual_maps_wo_conditioning_precipitation_nino3_con_everything_2002_2021 as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficients_maps_precipitation_nino3_wo_conditioning_2002_2021 as b) as b
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficients_maps_precipitation_nino3_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_nino3_wo_conditioning_2002_2021.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, b.coefficient_lag FROM beta_coefficients_maps_precipitation_nino3_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_nino3_wo_conditioning_lag_2002_2021.csv' DELIMITER ';' CSV HEADER;




------------------------------------------------------------------------------Nino 3 Index ---------------------------------------------------------------

------------------------------------------------------------------------------Nino 4 Index ---------------------------------------------------------------

--Prepare casual_maps_wo_conditioning_precipitation_nino4_con_everything with the help of PCMCI algorithm

/*DROP TABLE IF EXISTS casual_maps_wo_conditioning_precipitation_nino4_con_everything_2002_2021
;
CREATE TABLE casual_maps_wo_conditioning_precipitation_nino4_con_everything_2002_2021
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

\copy casual_maps_wo_conditioning_precipitation_nino4_con_everything_2002_2021 (longditude,laditude,nino4_coefficient_minus_zero_lag,nino4_coefficient_minus_one_lag,nino4_coefficient_minus_two_lag, nino4_coefficient_minus_three_lag,nino4_coefficient_minus_four_lag,nino4_coefficient_minus_five_lag, nino4_coefficient_minus_six_lag, nino4_coefficient_minus_seven_lag,nino4_coefficient_minus_eight_lag, nino4_coefficient_minus_nine_lag, nino4_coefficient_minus_ten_lag, nino4_coefficient_minus_eleven_lag, nino4_coefficient_minus_twelve_lag) FROM 'C:/Users/Alexej/nino4_wo_conditioning_2002_2021.csv' DELIMITER ';';




--Casual maps for oni with maximum coefficients (lag (0) and 1-12) only 

DROP TABLE IF EXISTS beta_coefficients_maps_precipitation_nino4_wo_conditioning_2002_2021;
CREATE TABLE beta_coefficients_maps_precipitation_nino4_wo_conditioning_2002_2021 as 

WITH maxmin as (
SELECT b.longditude,b.laditude, array_greatest(array_agg(b.nino4_coefficient_minus_zero_lag) || array_agg(b.nino4_coefficient_minus_one_lag) || array_agg(b.nino4_coefficient_minus_two_lag) || array_agg(b.nino4_coefficient_minus_three_lag) ||
											   array_agg(b.nino4_coefficient_minus_four_lag) || array_agg(b.nino4_coefficient_minus_five_lag) || array_agg(b.nino4_coefficient_minus_six_lag) || array_agg(b.nino4_coefficient_minus_seven_lag) ||
											   array_agg(b.nino4_coefficient_minus_eight_lag)|| array_agg(b.nino4_coefficient_minus_nine_lag) || array_agg(b.nino4_coefficient_minus_ten_lag) || array_agg(b.nino4_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino4_coefficient_minus_twelve_lag)) as maximum, 	
								array_smallest(array_agg(b.nino4_coefficient_minus_zero_lag) || array_agg(b.nino4_coefficient_minus_one_lag) || array_agg(b.nino4_coefficient_minus_two_lag) || array_agg(b.nino4_coefficient_minus_three_lag) ||
											   array_agg(b.nino4_coefficient_minus_four_lag) || array_agg(b.nino4_coefficient_minus_five_lag) || array_agg(b.nino4_coefficient_minus_six_lag) || array_agg(b.nino4_coefficient_minus_seven_lag) ||
											   array_agg(b.nino4_coefficient_minus_eight_lag)|| array_agg(b.nino4_coefficient_minus_nine_lag) || array_agg(b.nino4_coefficient_minus_ten_lag) || array_agg(b.nino4_coefficient_minus_eleven_lag) ||
											   array_agg(b.nino4_coefficient_minus_twelve_lag)) as minimum
FROM casual_maps_wo_conditioning_precipitation_nino4_con_everything_2002_2021 as b
GROUP BY b.longditude,b.laditude
ORDER BY b.laditude ASC,b.longditude ASC)

SELECT m.laditude,m.longditude,
	   CASE WHEN abs(m.maximum) > abs(m.minimum) THEN m.maximum*(s.nino4_stddev/s.precip_anomaly_stddev) ELSE m.minimum*(nino4_stddev/s.precip_anomaly_stddev) END as coefficients,
	   CASE WHEN m.maximum = 0 AND m.minimum = 0 THEN NULL
	        WHEN m.maximum = c.nino4_coefficient_minus_zero_lag OR m.minimum = c.nino4_coefficient_minus_zero_lag THEN 0
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
FROM maxmin as m, standardization_2002_2021 as s, casual_maps_wo_conditioning_precipitation_nino4_con_everything_2002_2021 as c  
WHERE m.laditude = s.laditude AND m.longditude = s.longditude AND m.longditude = c.longditude AND m.laditude = c.laditude
ORDER BY m.laditude ASC,m.longditude ASC;

SELECT b.coefficient_lag, count(*)
FROM (SELECT b.laditude,b.longditude,CASE WHEN abs(b.coefficients)>=0.1 THEN b.coefficient_lag ELSE NULL END as coefficient_lag FROM beta_coefficients_maps_precipitation_nino4_wo_conditioning_2002_2021 as b) as b
GROUP BY b.coefficient_lag
ORDER BY b.coefficient_lag;


\copy (SELECT b.laditude,b.longditude, b.coefficients FROM beta_coefficients_maps_precipitation_nino4_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_nino4_wo_conditioning_2002_2021.csv' DELIMITER ';' CSV HEADER;
\copy (SELECT b.laditude,b.longditude, b.coefficient_lag FROM beta_coefficients_maps_precipitation_nino4_wo_conditioning_2002_2021 as b ORDER BY b.laditude ASC,b.longditude ASC) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/PCMCI/causal_map_wo_conditioning/beta_coefficients_maps_precipitation_nino4_wo_conditioning_lag_2002_2021.csv' DELIMITER ';' CSV HEADER;




------------------------------------------------------------------------------Nino 4 Index controlled for Nino 1+2, Nino3, Oceanic Nino Index, TNI---------------------------------------------------------------