-- 31. For ship classes with a gun caliber of 16 in. or more, display the class and the country.

SELECT class, country
FROM Classes
WHERE bore >= 16


-- 32. One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw). 
-- Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.

SELECT country, cast(avg((power(bore,3)/2)) as numeric(6,2)) as weight 
FROM(
SELECT country, classes.class, bore, name 
FROM classes left join ships 
ON classes.class=ships.class 
UNION 
SELECT DISTINCT country, class, bore, ship 
FROM classes  LEFT JOIN outcomes 
on classes.class=outcomes.ship 
where ship=class 
) a 
WHERE name IS NOT NULL 
GROUP BY country


-- 33. Get the ships sunk in the North Atlantic battle. Result set: ship.

SELECT ship
FROM Outcomes
WHERE battle = 'North Atlantic' AND result = 'sunk'
  

-- 34. In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build 
-- battle ships with a displacement of more than 35 thousand tons. 
-- Get the ships violating this treaty (only consider ships for which the year of launch is known). 
-- List the names of the ships.

SELECT name
FROM Classes INNER JOIN Ships
ON Classes.class = Ships.class
WHERE displacement > 35000 AND launched >= 1922 AND type = 'bb'


-- 35. Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
-- Result set: model, type.

SELECT model, type
FROM Product
WHERE model NOT LIKE '%[^A-Z]%' 
OR model NOT LIKE '%[^0-9]%'


-- 36. List the names of lead ships in the database (including the Outcomes table).

SELECT class
FROM Classes INNER JOIN Outcomes
ON Classes.class = Outcomes.ship
UNION
SELECT Classes.class
FROM Classes INNER JOIN Ships
ON Classes.class = Ships.name


-- 37. Find classes for which only one ship exists in the database (including the Outcomes table).

SELECT class
FROM(
SELECT Classes.class AS class, name 
FROM Classes INNER JOIN Ships
ON Classes.class = Ships.class
UNION
SELECT Classes.class AS class, ship AS name
FROM Classes INNER JOIN Outcomes
ON Classes.class = Outcomes.ship
) a
Group by class
HAVING COUNT(name) = 1


-- 38. Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).

SELECT country
FROM Classes
WHERE type = 'bb'
INTERSECT
SELECT country
FROM Classes
WHERE type = 'bc'


-- 39. Find the ships that "survived for future battles"; that is, after being damaged in a battle, they participated in another one, which occurred later.

WITH a AS 
(SELECT Outcomes.ship, Battles.name, Battles.date, Outcomes.result 
FROM Outcomes 
LEFT JOIN Battles ON Outcomes.battle = Battles.name )
 
SELECT DISTINCT a.ship FROM a 
WHERE a.ship IN 
(SELECT ship FROM a AS b 
WHERE b.date < a.date 
AND b.result = 'damaged')


-- 40. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.

SELECT Classes.class, name, country 
FROM Classes INNER JOIN Ships
ON Classes.class = Ships.class
WHERE numGuns >= 10
