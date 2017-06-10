-- 1. Use a select statement to list names, authors, and number of copies sold of the 5 books which were sold most.

SELECT *
FROM Books
ORDER BY copies_sold desc LIMIT 5 

