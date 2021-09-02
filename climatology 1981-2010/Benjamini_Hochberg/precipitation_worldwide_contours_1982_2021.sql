
--CREATE TABLE period_<month>_<year> (longditude,laditude,correlation) as
CREATE TABLE period_1982_2021_countours (longditude,laditude,correlation) as

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

--Calculate correlation coefficient countours between oni values and global precipitation for every location for periods of 10 years (471 months, 469 degrees of freedom), in a 1 year cycle. 1979-1988,1980-1989,1981-1990,...
--Use approximations to the t distribution https://www.researchgate.net/publication/282255788_Approximations_to_the_t_distribution
--Starting 1979-1988	
SELECT *, rank () over (ORDER BY abs(p.correlation) DESC)
FROM (SELECT t.longditude,t.laditude, t.correlation,t_value,z_one,p_value
	   FROM (SELECT o.longditude, o.laditude, corr(o.percipitation_anomaly,o.oni) as "correlation"
			 FROM (SELECT * FROM oni WHERE oni.year BETWEEN 1982 AND 2021) as o
			 GROUP BY (o.longditude,o.laditude)
			 ORDER BY o.laditude ASC,o.longditude ASC) as t,
			 LATERAL (SELECT sqrt(471-2)*t.correlation/(sqrt(1-power(t.correlation,2))) as t_value) t_value,
			 LATERAL (SELECT abs(t_value)*(1-1/(4*118))*power((1+(power(t_value,2)/(2*118))),-0.5) as z_one) z_one,
			 LATERAL (SELECT 2*(1-power(1+exp(0.000345*power(z_one,5)-0.0695547*power(z_one,3)-1.604325*z_one),-1)) as p_value) p_value) as p
WINDOW win as (ORDER BY abs(p.correlation) ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
;

--DROP TABLE IF EXISTS period_1982_2021_countours_adj;

CREATE TABLE period_1982_2021_countours_adj as 
WITH RECURSIVE start as (
		SELECT p.*, p.p_value as p_value_adj
		FROM period_1982_2021_countours as p
		WHERE p.p_value = (SELECT max(p.p_value) as p_value_adj FROM period_1982_2021_countours as p)
		
	UNION
	
		SELECT p.*,CASE WHEN s.p_value_adj > p.p_value * (10368/p.rank) THEN (p.p_value * 10368/p.rank::numeric) ELSE s.p_value_adj END as p_value_adj
		FROM period_1982_2021_countours as p, start as s
		WHERE p.rank=s.rank-1 
)
SELECT s.longditude, s.laditude, s.correlation, s.p_value_adj
FROM start as s
ORDER BY s.laditude ASC,s.longditude ASC;

SELECT min(abs(p.correlation))
FROM (SELECT CASE WHEN temp.p_value_adj < 0.05 THEN temp.correlation ELSE 0 END as correlation FROM period_1982_2021_countours_adj as temp) as p
WHERE p.correlation <> 0;

-- Cutoff line =   0.264508866471598767, which corresponds to the smallest absolute correlation with p_value_adj < 0.05
--TABLE period_1982_2021_countours OFFSET 10000;

\copy period_1982_2021_countours_adj TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Benjamini_Hochberg/csv_contours/period_1982_2021_countours_adj.csv' DELIMITER ';' CSV HEADER;