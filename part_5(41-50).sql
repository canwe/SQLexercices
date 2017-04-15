-- 41. For the PC in the PC table with the maximum code value, obtain all its characteristics (except for the code) and display them in two columns:
-- - name of the characteristic (title of the corresponding column in the PC table);
-- - its respective value.

SELECT characteristics, value 
FROM(
SELECT  
CAST(model as varchar(max)) as model, 
CAST(speed as varchar(max)) as speed, 
CAST(ram as varchar(max)) as ram, 
CAST(hd as varchar(max)) as hd, 
CAST(cd as varchar(max)) as cd, 
CAST(price as varchar(max)) as price 
FROM PC
WHERE code IN (
SELECT max(code)
FROM pc)
) as A 
UNPIVOT(value for characteristics IN 
(model, speed, ram, hd, cd, price)
) as b


-- 42. Find the names of ships sunk at battles, along with the names of the corresponding battles.

SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk'


-- 43. Get the battles that occurred in years when no ships were launched into water.

SELECT name
FROM Battles
WHERE DATEPART(yy, date) NOT IN (
SELECT CASE 
 WHEN launched IS NULL THEN 1000
 ELSE launched 
END 'year'
FROM Ships)


-- 44. Find all ship names beginning with the letter R.

WITH a AS
(SELECT name 
FROM Ships
UNION ALL
SELECT ship AS name
FROM Outcomes)
SELECT Distinct name
FROM a
WHERE name LIKE 'R%'


-- 45. Find all ship names consisting of three or more words (e.g., King George V).
-- Consider the words in ship names to be separated by single spaces, and the ship names to have no leading or trailing spaces. 

WITH a AS
(SELECT name 
FROM Ships
UNION ALL
SELECT ship AS name
FROM Outcomes)
SELECT Distinct name
FROM a
WHERE name LIKE '% % %'


-- 46. For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.

WITH a AS (SELECT DISTINCT name, displacement, numGuns
FROM Classes INNER JOIN Ships
ON Classes.class = Ships.class
WHERE name IN (
SELECT ship
FROM Outcomes 
WHERE BATTLE = 'Guadalcanal')
UNION
SELECT DISTINCT ship AS name, displacement, numGuns
FROM Classes INNER JOIN Outcomes
ON Classes.class = Outcomes.ship
WHERE BATTLE = 'Guadalcanal')
SELECT name, displacement, numGuns
FROM a
UNION
SELECT ship, NULL AS displacement, NULL AS numguns
FROM Outcomes
WHERE battle = 'Guadalcanal' AND
 ship NOT IN (SELECT name 
 FROM Ships )
AND ship NOT IN (
SELECT name from a)


-- 47. Number the rows of the Product table as follows: makers in descending order of number of models produced by them 
-- (for manufacturers producing an equal number of models, their names are sorted in ascending alphabetical order); model numbers in ascending order.
-- Result set: row number as described above, manufacturer's name (maker), model.

SELECT ROW_NUMBER() OVER(ORDER BY co desc, m, model) no, m, model  
FROM ( Select one.maker as m, model, co   
FROM product as one join (
SELECT maker, count(model) as co 
FROM product 
GROUP BY maker) as two on one.maker=two.maker ) as ddd


-- 48. Find the ship classes having at least one ship sunk in battles.

SELECT class
FROM Ships INNER JOIN Outcomes
ON Ships.name = Outcomes.ship
WHERE result = 'sunk'
UNION
SELECT class 
FROM Classes INNER JOIN Outcomes
ON Classes.class = Outcomes.ship
WHERE result = 'sunk'


-- 49. Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table).

SELECT name
FROM Ships INNER JOIN Classes
ON Ships.class = Classes.class
WHERE bore = 16
UNION
SELECT class
FROM Outcomes INNER JOIN Classes
ON Outcomes.ship = Classes.class
WHERE bore = 16


-- 50. Find the battles in which Kongo-class ships from the Ships table were engaged.

SELECT DISTINCT battle
FROM Outcomes INNER JOIN Ships
ON Outcomes.ship = Ships.name
WHERE class = 'Kongo'
