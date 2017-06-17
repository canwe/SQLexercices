-- 1. Use a select statement to list names, authors, and number of copies sold of the 5 books which were sold most.

SELECT *
FROM Books
ORDER BY copies_sold desc LIMIT 5 

-- 2.  create a basic Increment function which Increments on the age field of the peoples table.

CREATE OR REPLACE FUNCTION increment 
RETURN number IS 
   total number(2) := 0; 
BEGIN 
      
   RETURN total + 1; 
END; 

CREATE  FUNCTION increment(i integer) 
RETURNS integer AS $$
BEGIN 
    RETURN i + 1; 
END;

-- 3. For this challenge you need to create a SELECT statement, this SELECT statement will use an IN to check 
-- whether a department has had a sale with a price over 98.00 dollars.

SELECT *
FROM departments 
WHERE id IN (
  SELECT department_id 
  FROM sales
  WHERE price > 98)

-- 4. Timmy works for a statistical analysis company and has been given a task of totaling the number of 
-- sales on a given day grouped by each department name and then each day.

SELECT 
 CAST(s.transaction_date AS DATE) as day,
  d.name as department,
  COUNT(s.id) as sale_count
  FROM department d JOIN sale s
  on d.id = s.department_id
  group by day,d.id
  order by day, name asc

-- 5. You recieved an invitation to an amazing party.
-- Now you need to write an insert statement to add yourself to the table of participants.

INSERT INTO participants
VALUES ('MY NAME', 26, true);

SELECT * FROM participants;

-- 6. For this challenge you need to create a simple SELECT statement that will return all 
-- columns from the people table, and join to the toys table so that you can return the COUNT of the toys

SELECT p.id, p.name , COUNT(t.id )AS toy_count
FROM people p INNER JOIN toys t
ON p.id = t.people_id
GROUP BY p.id

-- 7. For this challenge you need to create a simple GROUP BY statement, 
-- you want to group all the people by their age and count the people who have the same age.

SELECT age, COUNT(id) people_count
FROM people
GROUP BY age

-- 8. For this challenge you need to create a simple SELECT statement that will return all 
-- columns from the products table, and join to the companies table so that you can return the company name.

SELECT p.id, p.name, p.isbn, p.company_id, p.price, c.name as company_name
FROM products p INNER JOIN companies c
ON p.company_id = c.id

-- 9. For this challenge you need to create a simple SELECT statement. Your task is to calculate the MIN, 
-- MEDIAN and MAX scores of the students from the results table.

with b as(
SELECT CAST(cast(SUM(score) as FLOAT)/count(score) as FLOAT) as a
FROM (
  SELECT score ,
    ROW_NUMBER() OVER (ORDER BY score ASC ) AS ra,
    ROW_NUMBER() OVER (ORDER BY score DESC ) AS rd
  FROM result 
) x
 WHERE ra IN (SELECT count(score)/2 from result) OR  ra IN (SELECT count(score)/2+1 from result)
 ),
t as (
select MIN(score) as min, MAX(score) as max
FROM result)

SELECT t.min, b.a as MEDIAN, t.max
FROM t,b