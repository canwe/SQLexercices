-- 61. For the database with money transactions being recorded not more than once a day, calculate the total cash balance of all buy-back centers.

WITH a AS (SELECT point,
SUM(inc) as income
FROM Income_o
GROUP BY point),
b AS (SELECT point, SUM(out) as outcome
FROM Outcome_o
GROUP BY point),
c as (SELECT a.point AS point,
CASE WHEN income IS NULL THEN 0
ELSE income END income,
CASE WHEN outcome IS NULL THEN 0
ELSE outcome END outcome
FROM a FULL JOIN b
ON a.point = b.point)
SELECT SUM(income-outcome) as remain
FROM c;

-- 62. For the database with money transactions being recorded not more than once a day,
-- calculate the total cash balance of all buy-back centers at the beginning of 04/15/2001.

WITH a AS (SELECT point,
SUM(inc) as income
FROM Income_o
WHERE date < '2001-04-15'
GROUP BY point),
b AS (SELECT point, SUM(out) as outcome
FROM Outcome_o
WHERE date < '2001-04-15'
GROUP BY point),
c as (SELECT a.point AS point,
CASE WHEN income IS NULL THEN 0
ELSE income END income,
CASE WHEN outcome IS NULL THEN 0
ELSE outcome END outcome
FROM a FULL JOIN b
ON a.point = b.point)
SELECT SUM(income-outcome) as remain
FROM c

-- 63. Find the names of different passengers that ever travelled more than once occupying seats with the same number.

SELECT name
FROM Passenger
WHERE ID_PSG IN
(SELECT DISTINCT ID_PSG
FROM Pass_in_Trip 
GROUP BY ID_PSG,place
HAVING COUNT(place) > 1)

