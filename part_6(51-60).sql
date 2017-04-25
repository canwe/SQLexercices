-- 51. Find the names of the ships with the largest number of guns among all ships having the same displacement (including ships in the Outcomes table).

WITH d1 AS 
(select name as NAME, displacement, numguns  
from ships inner join classes on ships.class = classes.class 
union 
select ship as NAME, displacement, numguns from outcomes inner join classes on outcomes.ship= classes.class),

d2 AS(
select displacement, max(numGuns) as numguns 
from ( 
select displacement, numguns 
from ships 
inner join classes on ships.class = classes.class  
union 
select displacement, numguns  from outcomes inner join classes on outcomes.ship= classes.class) as f 
group by displacement)

select NAME 
from d1 inner join d2
on d1.displacement=d2.displacement and d1.numguns =d2.numguns


-- 52. Determine the names of all ships in the Ships table that can be a Japanese battleship 
-- having at least nine main guns with a caliber of less than 19 inches and a displacement of not more than 65 000 tons.

SELECT name
FROM Classes JOIN Ships
ON Classes.class = Ships.class
WHERE (country = 'Japan' OR country IS NULL)
AND (numGuns >= 9 OR numGuns IS NULL)
AND (bore < 19 OR bore IS NULL)
AND (displacement <= 65000 OR displacement IS NULL)
AND (type = 'bb' OR type IS NULL)
UNION ALL
SELECT name
FROM Ships
WHERE class NOT IN
(SELECT Distinct Classes.class
FROM Classes JOIN Ships
ON Classes.class = Ships.class)


-- 53. With a precision of two decimal places, determine the average number of guns for the battleship classes.

SELECT CAST(AVG(numGuns * 1.0)AS NUMERIC(4,2))  AS AvgnumGuns
FROM Classes
WHERE type = 'bb'


-- 54. With a precision of two decimal places, determine the average number of guns for all battleships (including the ones in the Outcomes table).

WITH a AS(
SELECT ship AS class, ship AS NAME
FROM Outcomes
UNION 
SELECT class, name
FROM Ships ),
b AS(
SELECT  a.name, a.class, numGuns
FROM classes  INNER JOIN a
ON classes.class = a.class
WHERE TYPE = 'bb')
SELECT CAST(AVG(numGuns * 1.0)AS NUMERIC(4,2))  AS AvgnumGuns
FROM b


-- 55. For each class, determine the year the first ship of this class was launched. 
-- If the lead ship’s year of launch is not known, get the minimum year of launch for the ships of this class.
-- Result set: class, year.

SELECT Classes.class,  MIN(launched)
FROM Classes LEFT JOIN Ships
ON Classes.class = Ships.class
GROUP BY Classes.class;


-- 56. For each class, find out the number of ships of this class that were sunk in battles. 
-- Result set: class, number of ships sunk.

WITH a AS(SELECT class, ship
FROM Outcomes INNER JOIN Ships
ON Outcomes.ship = ships.name
WHERE result = 'sunk'
UNION
SELECT ship AS class, ship
FROM Outcomes
WHERE result = 'sunk')

SELECT Classes.class, COUNT(ship)
FROM Classes LEFT JOIN a
ON Classes.class = a.class
GROUP BY Classes.class


-- 57. For classes having irreparable combat losses and at least three ships in the database, display the name of the class and the number of ships sunk.

SELECT Classes.class,COUNT(ship)
FROM Classes LEFT JOIN (SELECT class, ship
FROM Outcomes INNER JOIN Ships
ON Outcomes.ship = ships.name
WHERE result = 'sunk'
UNION
SELECT ship AS class, ship
FROM Outcomes
WHERE result = 'sunk')a
ON Classes.class = a.class
WHERE Classes.class IN(
SELECT class
FROM(
SELECT class, name AS ship
FROM  Ships
UNION
SELECT ship AS class, ship
FROM Outcomes)a
GROUP BY class
HAVING Count(ship)>=3
)
GROUP BY Classes.class
HAVING COUNT(ship)>0


-- 58. For each product type and maker in the Product table, find out, with a precision of two decimal places, the percentage ratio
-- of the number of models of the actual type produced by the actual maker to the total number of models by this maker.
-- Result set: maker, product type, the percentage ratio mentioned above.

WITH a AS (SELECT maker, type, COUNT(model) as counter
FROM Product
GROUP BY maker,type),
 b as (SELECT DISTINCT type
FROM Product),
c as (SELECT DISTINCT maker
FROM PRODUCT),
d as (SELECT maker, type
FROM b,c),
e AS (SELECT maker, SUM(counter) as summ
FROM a
GROUP BY maker),
f AS(
SELECT d.maker, d.type, CASE 
WHEN a.counter IS NULL THEN 0
ELSE a.counter END AS COUNTER
FROM d LEFT JOIN a
ON d.maker = a.maker AND d.type = a.type)

SELECT f.maker, f.type, CASE
WHEN e.summ =0 THEN 0.00
 ELSE CAST((f.counter*100.0)/(e.summ) AS NUMERIC (6,2)) END prc
FROM f INNER JOIN e
ON f.maker = e.maker

-- 59. Calculate the cash balance of each buy-back center for the database with money transactions being recorded not more than once a day.
-- Result set: point, balance.

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
SELECT point, income-outcome as remain
FROM c




