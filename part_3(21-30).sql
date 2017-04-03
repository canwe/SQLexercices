-- 21. Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.

SELECT maker, MAX(price)
FROM Product INNER JOIN PC
ON Product.model = PC.model
GROUP BY maker


-- 22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
-- Result set: speed, average price.

SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed


-- 23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. 
-- Result set: maker

SELECT maker
FROM Product, PC
WHERE Product.model = PC.model AND speed >=750
GROUP BY maker
INTERSECT
SELECT maker
FROM Product, Laptop
WHERE Product.model = Laptop.model AND speed >=750
GROUP BY maker;


-- 24. List the models of any type having the highest price of all products present in the database.

WITH Inc AS
(SELECT model, price
FROM PC
UNION
SELECT model, price
FROM PC
UNION
SELECT model, price
FROM Laptop
UNION
SELECT model, price
FROM Printer)
SELECT model 
FROM Inc
WHERE price IN (
SELECT MAX(price)
FROM Inc)


-- 25. Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity. 
-- Result set: maker.

SELECT DISTINCT maker
FROM Product
WHERE type = 'printer'
INTERSECT
SELECT DISTINCT maker
FROM Product
WHERE maker IN (
SELECT DISTINCT maker
FROM Product, PC
WHERE Product.model = PC.model AND speed = (
SELECT DISTINCT MAX(speed)
FROM PC
WHERE ram IN (
SELECT DISTINCT MIN(RAM)
FROM PC
)
) AND ram = (
SELECT DISTINCT MIN(RAM)
FROM PC
)
)


-- 26. Find out the average price of PCs and laptops produced by maker A.
-- Result set: one overall average price for all items.

SELECT AVG (price)
FROM(
SELECT   Price
FROM Product INNER JOIN PC
ON PC.model = Product.model 
WHERE maker = 'A'
UNION ALL
SELECT  Price
FROM Product INNER JOIN Laptop
ON Laptop.model = Product.model 
WHERE maker = 'A')AS aaa

-- 27. Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
-- Result set: maker, average HDD capacity.

SELECT maker, AVG (hd)
FROM Product INNER JOIN 
PC ON Product.model = PC.model
WHERE maker IN(
SELECT DISTINCT maker
FROM Product
WHERE type = 'printer')
GROUP BY maker

-- 28. Determine the average quantity of paint per square with an accuracy of two decimal places.

SELECT CAST(AVG(SUM_VOL*1.0) AS NUMERIC(6,2))
FROM(
SELECT utQ.Q_ID, 
CASE 
WHEN SUM(B_VOL) IS NULL
THEN 0
ELSE SUM(B_VOL)  END SUM_VOL
FROM utQ LEFT JOIN
utB ON utQ.Q_ID = utB.B_Q_ID
GROUP BY utQ.Q_ID
) AS asd

-- 29. Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each 
-- collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense). 
-- Use Income_o and Outcome_o tables.

SELECT Income_o.point, Income_o.date, inc, out
FROM Income_o LEFT JOIN Outcome_O
ON Income_o.point = Outcome_o.point
AND Income_o.date = Outcome_o.date
UNION
SELECT Outcome_O.point, Outcome_O.date, inc, out
FROM Income_O Right JOIN OUTcome_O
ON Income_o.point = Outcome_o.point
AND Income_o.date = Outcome_o.date

-- 30. Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each 
-- collection point [i.e. the code column is the primary key], display a table with one corresponding row for each operating date of each collection point.
-- Result set: point, date, total payout per day (out), total money intake per day (inc). 
-- Missing values are considered to be NULL.

SELECT point, date, SUM(out), SUM(inc)
FROM(
SELECT point, date, null AS out, SUM(inc) AS inc
FROM Income
GROUP BY point, date
UNION 
SELECT point, date, SUM(out) AS out, NULL AS inc
FROM Outcome
GROUP BY point, date) AS asd
GROUP BY point, date
