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

-- 64. Using the Income and Outcome tables, determine for each buy-back center the days when it received funds but made no payments, and vice versa.
-- Result set: point, date, type of operation (inc/out), sum of money per day.

WITH a AS (SELECT point, date, SUM(inc) as inc
FROM INCOME
GROUP BY point, date),
b AS (SELECT point, date, SUM(out) as out
FROM OUTCOME
GROUP BY point, date),
c AS(
SELECT CASE WHEN a.point IS NULL THEN b.point ELSE a.point END point,
CASE WHEN a.date IS NULL THEN b.date ELSE a.date END date,
 inc, out
FROM a FULL JOIN b
ON a.point=b.point AND a.date=b.date
WHERE inc IS NULL OR out IS NULL)

SELECT point, date,
CASE WHEN inc IS NULL THEN 'out' ELSE 'inc' END operation,
CASE WHEN inc IS NULL THEN out ELSE inc END money
FROM c;

-- 65. Number the unique pairs {maker, type} in the Product table, ordering them as follows:
-- - maker name in ascending order;
-- - type of product (type) in the order PC, Laptop, Printer.
-- If a manufacturer produces more than one type of product, its name should be displayed in the first row only;
-- other rows for THIS manufacturer should contain an empty string (').

With a AS (SELECT DISTINCT maker, 
CASE WHEN type = 'PC' then 1
WHEN type = 'Laptop' then 2
ELSE 3 END ord , type
FROM Product)

SELECT row_number() over(ORDER BY maker, ord) num, 
CASE 
WHEN type='Laptop' AND (maker in (SELECT maker FROM Product WHERE 
type='PC')) 
THEN ''
WHEN type='Printer' AND ((maker in (SELECT maker FROM Product WHERE 
type='PC')) OR (maker in (SELECT maker FROM Product WHERE 
type='Laptop'))) 
THEN '' 
ELSE maker 
END AS maker, type
FROM a



