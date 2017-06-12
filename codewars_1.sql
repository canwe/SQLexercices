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