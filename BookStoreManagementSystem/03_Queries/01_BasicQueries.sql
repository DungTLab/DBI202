/* =========================================================================
   Table: BOOK
   Author: Duc Anh
   ========================================================================= */

-- Retrieve all records from the BOOK table
SELECT * 
FROM BOOK;

-- Retrieve books with a quantity strictly greater than 5
SELECT * 
FROM BOOK
WHERE quantity > 5;

-- Retrieve books with a quantity less than or equal to 5
SELECT * 
FROM BOOK
WHERE quantity <= 5;

-- Retrieve books with a price strictly greater than 20
SELECT *
FROM BOOK
WHERE price > 20;

-- Retrieve books with a price less than or equal to 20
SELECT *
FROM BOOK
WHERE price <= 20;


/* =========================================================================
   Table: AUTHOR
   Author: Dung
   ========================================================================= */

-- Retrieve all records from the AUTHOR table
SELECT * 
FROM AUTHOR;

-- Retrieve authors whose nationality is either Vietnam or the UK
SELECT * 
FROM AUTHOR
WHERE nationality = 'Vietnam' 
   OR nationality = 'UK';


/* =========================================================================
   Table: ORDERS
   Author: Duy
   ========================================================================= */

-- Retrieve all records from the ORDERS table
SELECT * 
FROM ORDERS;

-- Retrieve all orders placed by the customer with ID 3
SELECT * 
FROM ORDERS
WHERE customer_id = 3;

-- Retrieve all orders placed after January 1st, 2024
SELECT *
FROM ORDERS
WHERE order_date > '2024-01-01';


/* =========================================================================
   Table: ORDER_DETAIL
   Author: Giac
   ========================================================================= */

-- Retrieve all records from the ORDER_DETAIL table
SELECT *
FROM ORDER_DETAIL;

-- Retrieve order details where the quantity is strictly greater than 1
SELECT *
FROM ORDER_DETAIL
WHERE quantity > 1;

-- Retrieve order details where the price is strictly greater than 20
SELECT *
FROM ORDER_DETAIL
WHERE price > 20;

-- Calculate the total cost (quantity * price) for each line item
SELECT order_id, book_id, quantity, price, (quantity * price) AS total
FROM ORDER_DETAIL;


/* =========================================================================
   Table: CUSTOMER
   Author: Trong
   ========================================================================= */

-- Retrieve all records from the CUSTOMER table
SELECT * 
FROM CUSTOMER;

-- Retrieve customers who do not have an email address on file
SELECT *
FROM CUSTOMER
WHERE email IS NULL;

-- Count the total number of registered customers
SELECT COUNT(*) AS total_customers
FROM CUSTOMER;