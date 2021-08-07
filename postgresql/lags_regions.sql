--Calculation of correlation coefficients of different time lags (between 1-12 months)
--Preparing table for calculations:

--Prepare precipitation_worldwide table

/*
DROP TABLE IF EXISTS lags_nino_regions;
CREATE TABLE lags_nino_regions(
year int,
month int,
nino12 real,
anom_nino12 real,
nino3 real,
anom_nino3 real,
nino4 real,
anom_nino4 real,
nino34 real,
anom_nino34 real
);
*/

--Copy different Niño SST Indices from https://climatedataguide.ucar.edu/climate-data/nino-sst-indices-nino-12-3-34-4-oni-and-tni

\copy lags_nino_regions (year,month,nino12,anom_nino12,nino3,anom_nino3,nino4,anom_nino4,nino34,anom_nino34) FROM 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/lags/nino_regions_sea_surface_temperatures.csv' DELIMITER ';' CSV HEADER;

--Include a 3 month running average to create the indices, derived from the SST anomalies.

DROP TABLE IF EXISTS lags_nino_regions_running_averages;
CREATE TABLE lags_nino_regions_running_averages as 
SELECT l.year,
	   l.month, 
	   l.anom_nino12,
	   avg(l.anom_nino12) over win as "nino_12_index",
	   l.anom_nino3,
	   avg(l.anom_nino3) over win as "nino_3_index",
	   l.anom_nino4,
	   avg(l.anom_nino4) over win as "nino_4_index",
	   l.nino34,
	   avg(l.anom_nino34) over win as "nino_3.4_index"
FROM lags_nino_regions as l 
WINDOW win as (ORDER BY l.year,l.month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
ORDER BY l.year,l.month;


/*
Join table lags_periods table with the other indices (table lags_nino_regions_running_averages). Table lag_periods consists of correlation coefficient between oni values and global precipitation for every 
location and monthly lags 1-12 for a moving window of 10 years. 1979-1988,1980-1989,...,2012-2021.
Since there is only data since 1982 for the other Nino indexes, the original lags_periods table, which only contains the ONI values, is also shortened by 3 years. The new joined table accordingly contains the Nino1 + 2, Nino3, Nino3 + 4, Nino4 and ONI values ​​since 1982, as well as 31 (instead of 34 as before) windows of a size of 10 years, as well as all possible monthly time lags 1-12.
*/

/*DROP TABLE IF EXISTS lags_periods_nino_indices;*/

CREATE TABLE lags_periods_nino_indices (start_year,end_year,year,month,date,longditude,laditude,oni,nino_12_index,nino_3_index,nino_34_index,nino_4_index,lagged_anomoly,following_date,lag,window_length) as 
SELECT l.start_year,
	   l.end_year,
	   l.year,
	   l.month,
	   l.date,
	   l.longditude,
	   l.laditude,
	   l.oni,
	   m.nino_12_index,
	   m.nino_3_index,
	   m."nino_3.4_index",
	   m.nino_4_index,
	   l.lagged_anomoly,
	   l.following_date,
	   l.lag,
	   l.window_length
FROM lags_periods as l, lags_nino_regions_running_averages as m
WHERE l.start_year >= 1982 AND l.year = m.year AND l.month = m.month;

--Calculate correlation coefficients between oni values, nino12, nino3, nino34, nino4 and global precipitation anomalies for every location for periods of 10 years, for every monthly time lag 1-12. --1979-1988,1980-1989,1990-1999,...,2012-2021. Once this is done, calculate the maximum correlation coefficients from all time lags 1-12 for each location and window.
--Then calculate the median and the middle 50% to get an idea of ​​the different time lags. Pixels that do not show a certain pattern of time lags are not considered.

DROP TABLE IF EXISTS lag_max_correlations_nino_indices;

CREATE TABLE lag_max_correlations_nino_indices (start_year,
												end_year,
												longditude,
												laditude,
												max_correlation_oni, max_1, min_1, avg_1, stddev_1, 
												--z_score_abs_oni, 
												max_correlation_nino12, max_2, min_2, avg_2, stddev_2, 
												--z_score_abs_nino12, 
												max_correlation_nino3, max_3, min_3, avg_3, stddev_3,
												--z_score_abs_nino3,
												max_correlation_nino34, max_4, min_4, avg_4, stddev_4, 
												--z_score_abs_nino34,
												max_correlation_nino4, max_5, min_5, avg_5, stddev_5 
												/*z_score_abs_nino4*/) as 

WITH window_correlations as (
						SELECT l.start_year,l.end_year,l.longditude,l.laditude,l.lag,corr(l.oni,l.lagged_anomoly) as correlation_oni, 
																					 corr(l.nino_12_index,l.lagged_anomoly) as correlation_nino12,
																					 corr(l.nino_3_index,l.lagged_anomoly) as correlation_nino3,
																					 corr(l.nino_34_index,l.lagged_anomoly) as correlation_nino34,
																					 corr(l.nino_4_index,l.lagged_anomoly) as correlation_nino4
						FROM lags_periods_nino_indices as l 
						GROUP BY l.start_year,l.end_year,l.longditude,l.laditude,l.lag),
						
	 max_correlations   as(
						SELECT w.start_year,
							   w.end_year,
							   w.longditude,
							   w.laditude, 
							   max(abs(w.correlation_oni)) as max_correlation_oni, max(w.correlation_oni) as max_1 ,min(w.correlation_oni) as min_1, avg(w.correlation_oni) as avg_1 ,stddev(w.correlation_oni) as stddev_1,
							   
							   max(abs(w.correlation_nino12)) as max_correlation_nino12, max(w.correlation_nino12) as max_2 ,min(w.correlation_nino12) as min_2, avg(w.correlation_nino12) as avg_2 ,stddev(w.correlation_nino12) as stddev_2,
							   
							   max(abs(w.correlation_nino3)) as max_correlation_nino3, max(w.correlation_nino3) as max_3,min(w.correlation_nino3) as min_3, avg(w.correlation_nino3) as avg_3,stddev(w.correlation_nino3) as stddev_3,
							   
							   max(abs(w.correlation_nino34)) as max_correlation_nino34, max(w.correlation_nino34) as max_4,min(w.correlation_nino34) as min_4, avg(w.correlation_nino34) as avg_4,stddev(w.correlation_nino34) as stddev_4,
							   
							   max(abs(w.correlation_nino4)) as max_correlation_nino4, max(w.correlation_nino4) as max_5,min(w.correlation_nino4) as min_5, avg(w.correlation_nino4) as avg_5,stddev(w.correlation_nino4) as stddev_5
						FROM window_correlations as w
						GROUP BY w.start_year,w.end_year,w.longditude,w.laditude)
						
SELECT * FROM max_correlations as m;

/*DROP TABLE IF EXISTS window_correlations_nino_indices;*/
CREATE TABLE window_correlations_nino_indices as 
SELECT l.start_year,l.end_year,l.longditude,l.laditude,l.lag,corr(l.oni,l.lagged_anomoly) as correlation_oni, 
																					 corr(l.nino_12_index,l.lagged_anomoly) as correlation_nino12,
																					 corr(l.nino_3_index,l.lagged_anomoly) as correlation_nino3,
																					 corr(l.nino_34_index,l.lagged_anomoly) as correlation_nino34,
																					 corr(l.nino_4_index,l.lagged_anomoly) as correlation_nino4
						FROM lags_periods_nino_indices as l 
						GROUP BY l.start_year,l.end_year,l.longditude,l.laditude,l.lag;

---------------------------------------Nino12 max indices---------------------------------------
DROP TABLE IF EXISTS lag_max_correlations_2;

CREATE TABLE lag_max_correlations_2(start_year,end_year,longditude,laditude,max_correlation,lag, z_score_abs, z_score_max,z_score_min,avg,stddev) as 
WITH max_correlations   as(
						SELECT w.start_year,w.end_year,w.longditude,w.laditude, max(abs(w.correlation_nino12)) as max_correlation, max(w.correlation_nino12),min(w.correlation_nino12), avg(w.correlation_nino12),stddev(w.correlation_nino12)
						FROM window_correlations_nino_indices as w
						GROUP BY w.start_year,w.end_year,w.longditude,w.laditude),
			
	 max_lags 			as(
						SELECT m.start_year,m.end_year,m.longditude,
							   m.laditude,w.correlation_nino12,w.lag, 
							  ((w.correlation_nino12-m.avg)/m.stddev) as z_score_abs,
							  ((m.max-m.avg)/m.stddev) as z_score_max,
							  ((m.min-m.avg)/m.stddev) as z_score_min,
							  m.avg, m.stddev
						FROM max_correlations as m, window_correlations_nino_indices as w 
						WHERE m.max_correlation=abs(w.correlation_nino12) AND m.start_year = w.start_year AND m.end_year = w.end_year AND m.longditude = w.longditude AND m.laditude = w.laditude
						)

SELECT * FROM max_lags as m;

DROP TABLE IF EXISTS plot_lags_2;

CREATE TABLE plot_lags_2 as
SELECT l.longditude,
	   l.laditude, 
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.5) within group (order by l.lag) ELSE NULL END as "median max lag",
--	   percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) as "interquartile range", 
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 17 THEN count(l.lag) ELSE NULL END as "amount of lags"
FROM (SELECT lag_max_correlations_2.start_year,
		     lag_max_correlations_2.end_year,
			 lag_max_correlations_2.longditude, 
			 lag_max_correlations_2.laditude,
			 CASE WHEN abs(lag_max_correlations_2.z_score_abs) > 1 AND abs(lag_max_correlations_2.max_correlation*sqrt(118/(1-(lag_max_correlations_2.max_correlation*lag_max_correlations_2.max_correlation))))>=1.98 THEN lag_max_correlations_2.lag ELSE NULL END as lag,
			 lag_max_correlations_2.z_score_abs,
			 lag_max_correlations_2.z_score_max,
			 lag_max_correlations_2.z_score_min,
			 lag_max_correlations_2.avg,
			 lag_max_correlations_2.stddev FROM lag_max_correlations_2 as lag_max_correlations_2) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

SELECT sum(s.count) FROM (
SELECT p."median max lag", count(p."median max lag") 
FROM plot_lags_2 as p 
GROUP BY p."median max lag"
ORDER BY p."median max lag") as s;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_2 as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";

\copy plot_lags_2 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_2.csv' DELIMITER ';' CSV HEADER;

DROP TABLE IF EXISTS plot_lags_2_inter;

CREATE TABLE plot_lags_2_inter as
SELECT l.longditude,
	   l.laditude, 
--	   percentile_disc(0.5) within group (order by l.lag) "median max lag",
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) ELSE NULL END as "interquartile range",
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 17 THEN count(l.lag) ELSE NULL END  as "amount of lags"
FROM (SELECT lag_max_correlations_2.start_year,
		     lag_max_correlations_2.end_year,
			 lag_max_correlations_2.longditude, 
			 lag_max_correlations_2.laditude,
			 CASE WHEN abs(lag_max_correlations_2.z_score_abs) > 1 AND abs(lag_max_correlations_2.max_correlation*sqrt(118/(1-(lag_max_correlations_2.max_correlation*lag_max_correlations_2.max_correlation))))>=1.98 THEN lag_max_correlations_2.lag ELSE NULL END as lag,
			 lag_max_correlations_2.z_score_abs,
			 lag_max_correlations_2.z_score_max,
			 lag_max_correlations_2.z_score_min,
			 lag_max_correlations_2.avg,
			 lag_max_correlations_2.stddev FROM lag_max_correlations_2 as lag_max_correlations_2) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

\copy plot_lags_2_inter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_2_inter.csv' DELIMITER ';' CSV HEADER;

/*
SELECT *
FROM plot_lags_2_inter as p 
WHERE p."interquartile range" = 0;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_2_inter as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";
*/
DROP TABLE IF EXISTS plot_lags_2_filter;

CREATE TABLE plot_lags_2_filter as 
SELECT p1.longditude,
	   p1.laditude,
	   --p1."median max lag", 
	   --p1."amount of lags", 
	   CASE WHEN p2."interquartile range" <=2 THEN p1."median max lag" ELSE NULL END as "significant median max lag"
FROM plot_lags_2 as p1, plot_lags_2_inter as p2
WHERE p1.longditude=p2.longditude AND p1.laditude = p2.laditude
ORDER BY p1.laditude,p1.longditude;

\copy plot_lags_2_filter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_2_filter.csv' DELIMITER ';' CSV HEADER;

SELECT p."significant median max lag", count(p."significant median max lag")
FROM plot_lags_2_filter as p
GROUP BY p."significant median max lag"
ORDER BY p."significant median max lag";


---------------------------------------Nino12 max indices---------------------------------------



---------------------------------------Nino3 max indices---------------------------------------
DROP TABLE IF EXISTS lag_max_correlations_3;
CREATE TABLE lag_max_correlations_3(start_year,end_year,longditude,laditude,max_correlation,lag, z_score_abs, z_score_max,z_score_min,avg,stddev) as 
WITH max_correlations   as(
						SELECT w.start_year,w.end_year,w.longditude,w.laditude, max(abs(w.correlation_nino3)) as max_correlation, max(w.correlation_nino3),min(w.correlation_nino3), avg(w.correlation_nino3),stddev(w.correlation_nino3)
						FROM window_correlations_nino_indices as w
						GROUP BY w.start_year,w.end_year,w.longditude,w.laditude),
			
	 max_lags 			as(
						SELECT m.start_year,m.end_year,m.longditude,
							   m.laditude,w.correlation_nino3,w.lag, 
							  ((w.correlation_nino3-m.avg)/m.stddev) as z_score_abs,
							  ((m.max-m.avg)/m.stddev) as z_score_max,
							  ((m.min-m.avg)/m.stddev) as z_score_min,
							  m.avg, m.stddev
						FROM max_correlations as m, window_correlations_nino_indices as w 
						WHERE m.max_correlation=abs(w.correlation_nino3) AND m.start_year = w.start_year AND m.end_year = w.end_year AND m.longditude = w.longditude AND m.laditude = w.laditude
						)

SELECT * FROM max_lags as m;

DROP TABLE IF EXISTS plot_lags_3;

CREATE TABLE plot_lags_3 as
SELECT l.longditude,
	   l.laditude, 
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.5) within group (order by l.lag) ELSE NULL END as "median max lag",
--	   percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) as "interquartile range", 
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 17 THEN count(l.lag) ELSE NULL END as "amount of lags"
FROM (SELECT lag_max_correlations_3.start_year,
		     lag_max_correlations_3.end_year,
			 lag_max_correlations_3.longditude, 
			 lag_max_correlations_3.laditude,
			 CASE WHEN abs(lag_max_correlations_3.z_score_abs) > 1 AND abs(lag_max_correlations_3.max_correlation*sqrt(118/(1-(lag_max_correlations_3.max_correlation*lag_max_correlations_3.max_correlation))))>=1.98 THEN lag_max_correlations_3.lag ELSE NULL END as lag,
			 lag_max_correlations_3.z_score_abs,
			 lag_max_correlations_3.z_score_max,
			 lag_max_correlations_3.z_score_min,
			 lag_max_correlations_3.avg,
			 lag_max_correlations_3.stddev FROM lag_max_correlations_3 as lag_max_correlations_3) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

SELECT sum(s.count) FROM (
SELECT p."median max lag", count(p."median max lag") 
FROM plot_lags_3 as p 
GROUP BY p."median max lag"
ORDER BY p."median max lag") as s;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_3 as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";

\copy plot_lags_3 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_3.csv' DELIMITER ';' CSV HEADER;

DROP TABLE IF EXISTS plot_lags_3_inter;

CREATE TABLE plot_lags_3_inter as
SELECT l.longditude,
	   l.laditude, 
--	   percentile_disc(0.5) within group (order by l.lag) "median max lag",
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) ELSE NULL END as "interquartile range",
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 17 THEN count(l.lag) ELSE NULL END  as "amount of lags"
FROM (SELECT lag_max_correlations_3.start_year,
		     lag_max_correlations_3.end_year,
			 lag_max_correlations_3.longditude, 
			 lag_max_correlations_3.laditude,
			 CASE WHEN abs(lag_max_correlations_3.z_score_abs) > 1 AND abs(lag_max_correlations_3.max_correlation*sqrt(118/(1-(lag_max_correlations_3.max_correlation*lag_max_correlations_3.max_correlation))))>=1.98 THEN lag_max_correlations_3.lag ELSE NULL END as lag,
			 lag_max_correlations_3.z_score_abs,
			 lag_max_correlations_3.z_score_max,
			 lag_max_correlations_3.z_score_min,
			 lag_max_correlations_3.avg,
			 lag_max_correlations_3.stddev FROM lag_max_correlations_3 as lag_max_correlations_3) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

\copy plot_lags_3_inter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_3_inter.csv' DELIMITER ';' CSV HEADER;

/*
SELECT *
FROM plot_lags_3_inter as p 
WHERE p."interquartile range" = 0;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_3_inter as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";
*/
DROP TABLE IF EXISTS plot_lags_3_filter;

CREATE TABLE plot_lags_3_filter as 
SELECT p1.longditude,
	   p1.laditude,
	   --p1."median max lag", 
	   --p1."amount of lags", 
	   CASE WHEN p2."interquartile range" <=2 THEN p1."median max lag" ELSE NULL END as "significant median max lag"
FROM plot_lags_3 as p1, plot_lags_3_inter as p2
WHERE p1.longditude=p2.longditude AND p1.laditude = p2.laditude
ORDER BY p1.laditude,p1.longditude;

\copy plot_lags_3_filter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_3_filter.csv' DELIMITER ';' CSV HEADER;

SELECT p."significant median max lag", count(p."significant median max lag")
FROM plot_lags_3_filter as p
GROUP BY p."significant median max lag"
ORDER BY p."significant median max lag";

---------------------------------------Nino3 max indices---------------------------------------

---------------------------------------Nino34 max indices---------------------------------------
DROP TABLE IF EXISTS lag_max_correlations_4;

CREATE TABLE lag_max_correlations_4(start_year,end_year,longditude,laditude,max_correlation,lag, z_score_abs, z_score_max,z_score_min,avg,stddev) as 
WITH max_correlations   as(
						SELECT w.start_year,w.end_year,w.longditude,w.laditude, max(abs(w.correlation_nino34)) as max_correlation, max(w.correlation_nino34),min(w.correlation_nino34), avg(w.correlation_nino34),stddev(w.correlation_nino34)
						FROM window_correlations_nino_indices as w
						GROUP BY w.start_year,w.end_year,w.longditude,w.laditude),
			
	 max_lags 			as(
						SELECT m.start_year,m.end_year,m.longditude,
							   m.laditude,w.correlation_nino34,w.lag, 
							  ((w.correlation_nino34-m.avg)/m.stddev) as z_score_abs,
							  ((m.max-m.avg)/m.stddev) as z_score_max,
							  ((m.min-m.avg)/m.stddev) as z_score_min,
							  m.avg, m.stddev
						FROM max_correlations as m, window_correlations_nino_indices as w 
						WHERE m.max_correlation=abs(w.correlation_nino34) AND m.start_year = w.start_year AND m.end_year = w.end_year AND m.longditude = w.longditude AND m.laditude = w.laditude
						)

SELECT * FROM max_lags as m;

DROP TABLE IF EXISTS plot_lags_4;

CREATE TABLE plot_lags_4 as
SELECT l.longditude,
	   l.laditude, 
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.5) within group (order by l.lag) ELSE NULL END as "median max lag",
--	   percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) as "interquartile range", 
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 17 THEN count(l.lag) ELSE NULL END as "amount of lags"
FROM (SELECT lag_max_correlations_4.start_year,
		     lag_max_correlations_4.end_year,
			 lag_max_correlations_4.longditude, 
			 lag_max_correlations_4.laditude,
			 CASE WHEN abs(lag_max_correlations_4.z_score_abs) > 1 AND abs(lag_max_correlations_4.max_correlation*sqrt(118/(1-(lag_max_correlations_4.max_correlation*lag_max_correlations_4.max_correlation))))>=1.98 THEN lag_max_correlations_4.lag ELSE NULL END as lag,
			 lag_max_correlations_4.z_score_abs,
			 lag_max_correlations_4.z_score_max,
			 lag_max_correlations_4.z_score_min,
			 lag_max_correlations_4.avg,
			 lag_max_correlations_4.stddev FROM lag_max_correlations_4 as lag_max_correlations_4) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

SELECT sum(s.count) FROM (
SELECT p."median max lag", count(p."median max lag") 
FROM plot_lags_4 as p 
GROUP BY p."median max lag"
ORDER BY p."median max lag") as s;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_4 as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";

\copy plot_lags_4 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_4.csv' DELIMITER ';' CSV HEADER;

DROP TABLE IF EXISTS plot_lags_4_inter;

CREATE TABLE plot_lags_4_inter as
SELECT l.longditude,
	   l.laditude, 
--	   percentile_disc(0.5) within group (order by l.lag) "median max lag",
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) ELSE NULL END as "interquartile range",
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 17 THEN count(l.lag) ELSE NULL END  as "amount of lags"
FROM (SELECT lag_max_correlations_4.start_year,
		     lag_max_correlations_4.end_year,
			 lag_max_correlations_4.longditude, 
			 lag_max_correlations_4.laditude,
			 CASE WHEN abs(lag_max_correlations_4.z_score_abs) > 1 AND abs(lag_max_correlations_4.max_correlation*sqrt(118/(1-(lag_max_correlations_4.max_correlation*lag_max_correlations_4.max_correlation))))>=1.98 THEN lag_max_correlations_4.lag ELSE NULL END as lag,
			 lag_max_correlations_4.z_score_abs,
			 lag_max_correlations_4.z_score_max,
			 lag_max_correlations_4.z_score_min,
			 lag_max_correlations_4.avg,
			 lag_max_correlations_4.stddev FROM lag_max_correlations_4 as lag_max_correlations_4) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

\copy plot_lags_4_inter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_4_inter.csv' DELIMITER ';' CSV HEADER;

/*
SELECT *
FROM plot_lags_4_inter as p 
WHERE p."interquartile range" = 0;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_4_inter as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";
*/
DROP TABLE IF EXISTS plot_lags_4_filter;

CREATE TABLE plot_lags_4_filter as 
SELECT p1.longditude,
	   p1.laditude,
	   --p1."median max lag", 
	   --p1."amount of lags", 
	   CASE WHEN p2."interquartile range" <=2 THEN p1."median max lag" ELSE NULL END as "significant median max lag"
FROM plot_lags_4 as p1, plot_lags_4_inter as p2
WHERE p1.longditude=p2.longditude AND p1.laditude = p2.laditude
ORDER BY p1.laditude,p1.longditude;

\copy plot_lags_4_filter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_4_filter.csv' DELIMITER ';' CSV HEADER;

SELECT p."significant median max lag", count(p."significant median max lag")
FROM plot_lags_4_filter as p
GROUP BY p."significant median max lag"
ORDER BY p."significant median max lag";

---------------------------------------Nino34 max indices---------------------------------------

---------------------------------------Nino4 max indices---------------------------------------

DROP TABLE IF EXISTS lag_max_correlations_5;

CREATE TABLE lag_max_correlations_5(start_year,end_year,longditude,laditude,max_correlation,lag, z_score_abs, z_score_max,z_score_min,avg,stddev) as 
WITH max_correlations   as(
						SELECT w.start_year,w.end_year,w.longditude,w.laditude, max(abs(w.correlation_nino4)) as max_correlation, max(w.correlation_nino4),min(w.correlation_nino4), avg(w.correlation_nino4),stddev(w.correlation_nino4)
						FROM window_correlations_nino_indices as w
						GROUP BY w.start_year,w.end_year,w.longditude,w.laditude),
			
	 max_lags 			as(
						SELECT m.start_year,m.end_year,m.longditude,
							   m.laditude,w.correlation_nino4,w.lag, 
							  ((w.correlation_nino4-m.avg)/m.stddev) as z_score_abs,
							  ((m.max-m.avg)/m.stddev) as z_score_max,
							  ((m.min-m.avg)/m.stddev) as z_score_min,
							  m.avg, m.stddev
						FROM max_correlations as m, window_correlations_nino_indices as w 
						WHERE m.max_correlation=abs(w.correlation_nino4) AND m.start_year = w.start_year AND m.end_year = w.end_year AND m.longditude = w.longditude AND m.laditude = w.laditude
						)

SELECT * FROM max_lags as m;

DROP TABLE IF EXITS plot_lags5;

CREATE TABLE plot_lags_5 as
SELECT l.longditude,
	   l.laditude, 
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.5) within group (order by l.lag) ELSE NULL END as "median max lag",
--	   percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) as "interquartile range", 
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   CASE WHEN count(l.lag)  >= 17 THEN count(l.lag) ELSE NULL END as "amount of lags"
FROM (SELECT lag_max_correlations_5.start_year,
		     lag_max_correlations_5.end_year,
			 lag_max_correlations_5.longditude, 
			 lag_max_correlations_5.laditude,
			 CASE WHEN abs(lag_max_correlations_5.z_score_abs) > 1 AND abs(lag_max_correlations_5.max_correlation*sqrt(118/(1-(lag_max_correlations_5.max_correlation*lag_max_correlations_5.max_correlation))))>=1.98 THEN lag_max_correlations_5.lag ELSE NULL END as lag,
			 lag_max_correlations_5.z_score_abs,
			 lag_max_correlations_5.z_score_max,
			 lag_max_correlations_5.z_score_min,
			 lag_max_correlations_5.avg,
			 lag_max_correlations_5.stddev FROM lag_max_correlations_5 as lag_max_correlations_5) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

SELECT sum(s.count) FROM (
SELECT p."median max lag", count(p."median max lag") 
FROM plot_lags_5 as p 
GROUP BY p."median max lag"
ORDER BY p."median max lag") as s;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_5 as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";

\copy plot_lags_5 TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_5.csv' DELIMITER ';' CSV HEADER;

DROP TABLE IF EXISTS plot_lags_5_inter;

CREATE TABLE plot_lags_5_inter as
SELECT l.longditude,
	   l.laditude, 
--	   percentile_disc(0.5) within group (order by l.lag) "median max lag",
	   CASE WHEN count(l.lag) >= 17 THEN percentile_disc(0.75) within group (order by l.lag) - percentile_disc(0.25) within group (order by l.lag) ELSE NULL END as "interquartile range",
--	   percentile_disc(0.25) within group (order by l.lag) as "25th percentile",
--	   percentile_disc(0.75) within group (order by l.lag) as "75th percentile",
	   array_agg(l.lag) as "maximum lags over windows 1979-1988,1980-1989,...,2012-2021",
	   count(l.lag) as "amount of lags"
FROM (SELECT lag_max_correlations_5.start_year,
		     lag_max_correlations_5.end_year,
			 lag_max_correlations_5.longditude, 
			 lag_max_correlations_5.laditude,
			 CASE WHEN abs(lag_max_correlations_5.z_score_abs) > 1 AND abs(lag_max_correlations_5.max_correlation*sqrt(118/(1-(lag_max_correlations_5.max_correlation*lag_max_correlations_5.max_correlation))))>=1.98 THEN lag_max_correlations_5.lag ELSE NULL END as lag,
			 lag_max_correlations_5.z_score_abs,
			 lag_max_correlations_5.z_score_max,
			 lag_max_correlations_5.z_score_min,
			 lag_max_correlations_5.avg,
			 lag_max_correlations_5.stddev FROM lag_max_correlations_5 as lag_max_correlations_5) as l 
GROUP BY l.longditude,l.laditude
ORDER BY l.laditude,l.longditude;

\copy plot_lags_5_inter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_5_inter.csv' DELIMITER ';' CSV HEADER;

/*
SELECT *
FROM plot_lags_5_inter as p 
WHERE p."interquartile range" = 0;

SELECT p."amount of lags",count(p."amount of lags")
FROM plot_lags_5_inter as p
GROUP BY p."amount of lags"
ORDER BY p."amount of lags";
*/
DROP TABLE IF EXISTS plot_lags_5_filter;

CREATE TABLE plot_lags_5_filter as 
SELECT p1.longditude,
	   p1.laditude,
	   --p1."median max lag", 
	   --p1."amount of lags", 
	   CASE WHEN p2."interquartile range" <=2 THEN p1."median max lag" ELSE NULL END as "significant median max lag"
FROM plot_lags_5 as p1, plot_lags_5_inter as p2
WHERE p1.longditude=p2.longditude AND p1.laditude = p2.laditude
ORDER BY p1.laditude,p1.longditude;

\copy plot_lags_5_filter TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Lags/csv/plot_lags_5_filter.csv' DELIMITER ';' CSV HEADER;

SELECT p."significant median max lag", count(p."significant median max lag")
FROM plot_lags_5_filter as p
GROUP BY p."significant median max lag"
ORDER BY p."significant median max lag";

---------------------------------------Nino4 max indices---------------------------------------


