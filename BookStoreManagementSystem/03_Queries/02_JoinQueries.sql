/* =========================================================================
   Table: BOOK / BOOK_AUTHOR
   Author: Duc Anh
   ========================================================================= */

-- Retrieve book titles and their corresponding author names
SELECT b.title, a.name
FROM BOOK b
JOIN BOOK_AUTHOR ba ON b.book_id = ba.book_id
JOIN AUTHOR a ON ba.author_id = a.author_id;


/* =========================================================================
   Table: BOOK / BOOK_AUTHOR
   Author: Dung
   ========================================================================= */

-- Retrieve book titles and their corresponding author names
SELECT b.title, a.name
FROM BOOK b
JOIN BOOK_AUTHOR ba ON b.book_id = ba.book_id
JOIN AUTHOR a ON ba.author_id = a.author_id;


/* =========================================================================
   Table: ORDERS / CUSTOMER
   Author: Duy
   ========================================================================= */

-- Retrieve order ID, order date, and the corresponding customer's name
SELECT o.order_id, 
       o.order_date, 
       c.name
FROM ORDERS o
JOIN CUSTOMER c ON o.customer_id = c.customer_id;

-- Retrieve detailed order information including customer name, book title, and quantity
SELECT o.order_id, 
       c.name, 
       b.title, 
       od.quantity
FROM ORDERS o
JOIN CUSTOMER c ON o.customer_id = c.customer_id
JOIN ORDER_DETAIL od ON o.order_id = od.order_id
JOIN BOOK b ON od.book_id = b.book_id;

-- Retrieve order ID, order date, and the corresponding customer's email address
SELECT o.order_id, 
       o.order_date, 
       c.email
FROM ORDERS o
JOIN CUSTOMER c ON o.customer_id = c.customer_id;


/* =========================================================================
   Table: ORDER_DETAIL
   Author: Giac
   ========================================================================= */

/* GROUP BY & HAVING QUERIES */

-- Calculate the total amount (quantity * price) for each order
SELECT order_id, SUM(quantity * price) AS total_amount
FROM ORDER_DETAIL
GROUP BY order_id;

-- Calculate the total quantity sold for each book
SELECT book_id, SUM(quantity) AS total_sold
FROM ORDER_DETAIL
GROUP BY book_id;

-- Retrieve book IDs that have a total quantity sold strictly greater than 2
SELECT book_id, SUM(quantity) AS total_sold
FROM ORDER_DETAIL
GROUP BY book_id
HAVING SUM(quantity) > 2;


/* JOIN QUERIES */

-- Retrieve book titles and the total quantity sold for each title
SELECT b.title, SUM(od.quantity) AS total_sold
FROM ORDER_DETAIL od
JOIN BOOK b ON od.book_id = b.book_id
GROUP BY b.title;

-- Calculate the total amount spent by each customer
SELECT c.name, SUM(od.quantity * od.price) AS total_spent
FROM ORDER_DETAIL od
JOIN ORDERS o ON od.order_id = o.order_id
JOIN CUSTOMER c ON o.customer_id = c.customer_id
GROUP BY c.name;


/* =========================================================================
   Table: CUSTOMER / ORDERS
   Author: Trong
   ========================================================================= */

-- Retrieve all orders made by a specific customer (customer_id = 1), including book details and order information
SELECT C.name, 
       O.order_id, 
       O.order_date, 
       B.title, 
       OD.quantity, 
       OD.price
FROM CUSTOMER C
JOIN ORDERS O ON C.customer_id = O.customer_id
JOIN ORDER_DETAIL OD ON O.order_id = OD.order_id
JOIN BOOK B ON OD.book_id = B.book_id
WHERE C.customer_id = 1;