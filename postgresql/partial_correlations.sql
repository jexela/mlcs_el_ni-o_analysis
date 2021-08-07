 
 
 
SELECT * 
FROM ( 
SELECT w.start_year,
	   w.end_year,
	   w.longditude,
	   w.laditude,
	   w.lag,
	   w.correlation_oni as correlation,
	   CASE WHEN abs(w.correlation_oni*sqrt(118/(1-(w.correlation_oni*w.correlation_oni))))>=1.98 THEN 'significant' ELSE 'not significant' END as test,
	   'oni' as variable
FROM window_correlations_nino_indices as w
UNION 
SELECT w.start_year,
	   w.end_year,
	   w.longditude,
	   w.laditude,
	   w.lag,
	   w.correlation_nino4 as correlation,
	   CASE WHEN abs(w.correlation_nino4*sqrt(118/(1-(w.correlation_nino4*w.correlation_nino4))))>=1.98 THEN 'significant' ELSE 'not significant' END as test,
	   'nino4' as variable
FROM window_correlations_nino_indices as w 
) as first
WHERE first.test = 'significant' 
ORDER BY first.start_year,first.end_year,first.longditude,first.laditude,abs(first.correlation) DESC
LIMIT 24;

