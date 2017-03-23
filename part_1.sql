-- 1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
-- Result set: model, speed, hd.

SELECT model, speed, hd
FROM PC
WHERE price < 500


--2.List all printer makers. Result set: maker.

SELECT DISTINCT maker
FROM Product
WHERE type = 'printer'


--3.Find the model number, RAM and screen size of the laptops with prices over $1000.

SELECT model, ram, screen
FROM Laptop
WHERE price > 1000


--4. Find all records from the Printer table containing data about color printers.

SELECT *
FROM Printer
WHERE color = 'y'


--5.Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.

SELECT model, speed, hd
FROM PC
WHERE (cd = '12x' OR cd = '24x') AND price < 600


--6.For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.

SELECT DISTINCT maker, speed
FROM Product INNER JOIN
Laptop ON Laptop.model = Product.model
WHERE hd >= 10


--7.Find out the models and prices for all the products (of any type) produced by maker B.

SELECT DISTINCT Product.model, PC.price
FROM PC INNER JOIN
Product ON PC.model = Product.model
WHERE maker = 'B'
UNION
SELECT DISTINCT Product.model, Laptop.price
FROM Laptop INNER JOIN
Product ON Laptop.model = Product.model
WHERE maker = 'B'
UNION
SELECT DISTINCT Product.model, Printer.price
FROM Printer INNER JOIN
Product ON Printer.model = Product.model
WHERE maker = 'B'


--8.Find the makers producing PCs but not laptops.

SELECT DISTINCT Product.model, PC.price
FROM PC INNER JOIN
Product ON PC.model = Product.model
WHERE maker = 'B'
UNION
SELECT DISTINCT Product.model, Laptop.price
FROM Laptop INNER JOIN
Product ON Laptop.model = Product.model
WHERE maker = 'B'
UNION
SELECT DISTINCT Product.model, Printer.price
FROM Printer INNER JOIN
Product ON Printer.model = Product.model
WHERE maker = 'B'


--9.Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.

SELECT DISTINCT maker
FROM Product INNER JOIN PC
ON PC.model = Product.model
WHERE speed >= 450

--10.Find the printer models having the highest price. Result set: model, price.

SELECT model, price
FROM Printer
WHERE price IN (
SELECT MAX(price)
FROM Printer)