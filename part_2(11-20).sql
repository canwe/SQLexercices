-- 11.Find out the average speed of PCs.

SELECT AVG(speed)
FROM PC


-- 12.Find out the average speed of the laptops priced over $1000.

SELECT AVG(speed)
FROM Laptop
WHERE price > 1000


-- 13.Find out the average speed of the PCs produced by maker A.

SELECT AVG(speed)
FROM PC INNER JOIN Product
ON Product.model = PC.model
WHERE maker = 'A'


-- 14.Get the makers who produce only one product type and more than one model. Output: maker, type.

SELECT maker, MIN(type) 
FROM Product
GROUP BY maker
HAVING COUNT(DISTINCT model) <>1 AND COUNT (DISTINCT type) = 1

-- 15.Get hard drive capacities that are identical for two or more PCs. 
-- Result set: hd.

SELECT hd
FROM pc
GROUP BY hd
HAVING COUNT(hd) >1


-- 16. Get pairs of PC models with identical speeds and the same RAM capacity. 
-- Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i). 
-- Result set: model with the bigger number, model with the smaller number, speed, and RAM.

SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram 
FROM pc p1, pc p2 
WHERE p1.speed = p2.speed AND p1.ram = p2.ram AND p1.model > p2.model


-- 17. Get the laptop models that have a speed smaller than the speed of any PC. 
-- Result set: type, model, speed.

SELECT DISTINCT Product.type, Product.model, Laptop.speed
FROM Product, PC, Laptop
WHERE Product.model = Laptop.model AND Laptop.speed < ANY (
SELECT MIN(Speed)
FROM PC)


-- 18. Find the makers of the cheapest color printers.
-- Result set: maker, price.

SELECT DISTINCT Product.maker, Printer.price
FROM Product, Printer
WHERE Product.model = Printer.model AND Printer.color = 'y' AND Printer.price <= ANY (
SELECT MIN(price)
FROM Printer
WHERE Printer.color = 'y')

-- 19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. 
-- Result set: maker, average screen size.

SELECT maker, AVG(screen)
FROM Product INNER JOIN Laptop
ON Product.model = Laptop.model
GROUP BY maker

-- 20.Find the makers producing at least three distinct models of PCs.
-- Result set: maker, number of PC models.

SELECT maker, COUNT(model) AS Count_model
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING Count(model) >= 3



