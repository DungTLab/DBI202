SELECT * FROM AUTHOR
WHERE nationality = 'Vietnam' 
OR	  nationality = 'UK';

/* Order_Detail quetry - Giac*/

/*BASIC QUERY*/

-- Select all:
SELECT *
FROM ORDER_DETAIL;

-- Select with quantity greater than 1:
SELECT *
FROM ORDER_DETAIL
WHERE quantity > 1;

-- Select with price greater than 20:
SELECT *
FROM ORDER_DETAIL
WHERE price > 20

-- Calculate total for each lines:
SELECT order_id, book_id, quantity, price, quantity * price AS total
FROM ORDER_DETAIL;

