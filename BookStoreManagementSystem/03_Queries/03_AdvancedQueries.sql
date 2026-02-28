-- Advanced Queries for Book Store Management System
SELECT *
FROM BOOK
WHERE book_id NOT IN (
    SELECT book_id FROM ORDER_DETAIL
);

-- Find all books that are more expensive than the average price of all books
SELECT *
FROM BOOK
WHERE price > (
    SELECT AVG(price) FROM BOOK
);
