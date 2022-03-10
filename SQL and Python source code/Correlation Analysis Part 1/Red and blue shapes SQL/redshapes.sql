
DROP TABLE IF EXISTS redshapes;

CREATE TABLE redshapes (year,area) as (
SELECT 1984, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1979_1988 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.252) as s
UNION
SELECT 1985, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1980_1989 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.254) as s
UNION
SELECT 1986, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1981_1990 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.259) as s
UNION
SELECT 1987, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1982_1991 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.258) as s
UNION
SELECT 1988, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1983_1992 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.257) as s
UNION
SELECT 1989, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1984_1993 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.265) as s
UNION
SELECT 1990, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1985_1994 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.265) as s
UNION
SELECT 1991, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1986_1995 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.27) as s
UNION
SELECT 1992, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1987_1996 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.267) as s
UNION
SELECT 1993, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1988_1997 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.258) as s
UNION
SELECT 1994, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1989_1998 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.252) as s
UNION
SELECT 1995, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1990_1999 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.25) as s
UNION
SELECT 1996, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1991_2000 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.247) as s
UNION
SELECT 1997, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1992_2001 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.248) as s
UNION
SELECT 1998, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1993_2002 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.25) as s
UNION
SELECT 1999, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1994_2003 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.253) as s
UNION
SELECT 2000, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1995_2004 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.253) as s
UNION
SELECT 2001, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1996_2005 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.252) as s
UNION
SELECT 2002, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1997_2006 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.25) as s
UNION
SELECT 2003, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1998_2007 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.254) as s
UNION
SELECT 2004, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_1999_2008 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.262) as s
UNION
SELECT 2005, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2000_2009 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.263) as s
UNION
SELECT 2006, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2001_2010 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.262) as s
UNION
SELECT 2007, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2002_2011 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.25) as s
UNION
SELECT 2008, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2003_2012 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.262) as s
UNION
SELECT 2009, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2004_2013 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.264) as s
UNION
SELECT 2010, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2005_2014 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.264) as s
UNION
SELECT 2011, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2006_2015 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.267) as s
UNION
SELECT 2012, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2007_2016 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.261) as s
UNION
SELECT 2013, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2008_2017 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.26) as s
UNION
SELECT 2014, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2009_2018 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.264) as s
UNION
SELECT 2015, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2010_2019 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.268) as s
UNION
SELECT 2016, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2011_2020 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.275) as s
UNION
SELECT 2017, round(sum(square_miles)::numeric,2) as "total area in square kilometers"
FROM (
SELECT *, square_miles*2,58998811 as "square_kilometer"
FROM reds_2012_2021 as r,
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude+1.25,r.laditude)) as horizontal_distance) horizontal_distance, 
	 LATERAL (SELECT 2*(point(r.longditude,r.laditude)<@>point(r.longditude,r.laditude+1.25)) as vertical_distance) vertical_distance,
	 LATERAL (SELECT horizontal_distance*vertical_distance as square_miles) square_miles
WHERE r.correlation >= 0.288) as s
);

\copy (SELECT b.* FROM redshapes as b ORDER BY b.year) TO 'C:/Users/Alexej/Desktop/Bachelorarbeit/climatology 1981-2010/Benjamini_Hochberg/redshapes.csv' DELIMITER ';' CSV HEADER;