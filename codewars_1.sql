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