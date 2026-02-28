/* Book queries - Duc Anh*/

-- Join Queries for Book Store Management System
SELECT b.title, a.name
FROM BOOK b
JOIN BOOK_AUTHOR ba ON b.book_id = ba.book_id
JOIN AUTHOR a ON ba.author_id = a.author_id;

/* Author queries - Dung*/

SELECT b.title, a.name
FROM BOOK b
JOIN BOOK_AUTHOR ba ON b.book_id = ba.book_id
JOIN AUTHOR a ON ba.author_id = a. author_id;

/* Orders queries - Duy*/

-- Show order info with customer name
SELECT o.order_id,
       o.order_date,
       c.name
FROM ORDERS o
JOIN CUSTOMER c 
ON o.customer_id = c.customer_id;

-- Show order id, customer name, book title and quantity
SELECT o.order_id,
       c.name,
       b.title,
       od.quantity
FROM ORDERS o
JOIN CUSTOMER c 
ON o.customer_id = c.customer_id
JOIN ORDER_DETAIL od 
ON o.order_id = od.order_id
JOIN BOOK b 
ON od.book_id = b.book_id;

-- Get order id with customer email
SELECT o.order_id,
       o.order_date,
       c.email
FROM ORDERS o
JOIN CUSTOMER c
ON o.customer_id = c.customer_id;

/* Order_Detail quetry - Giac*/

/*GROUP BY + HAVING QUERY*/

-- Calculate total amount for each different order id:
SELECT order_id, SUM(quantity * price) AS total_amount
FROM ORDER_DETAIL
GROUP BY order_id;


-- Calculate total sold for each different book_id:
SELECT book_id, SUM(quantity) AS total_sold
FROM ORDER_DETAIL
GROUP BY book_id;

-- Select book_id have total sold greater than 2
SELECT book_id, SUM(quantity) AS total_sold
FROM ORDER_DETAIL
GROUP BY book_id
HAVING SUM(quantity) > 2;

/*JOIN QUERY*/

-- View book title and total sold:
SELECT b.title, SUM(od.quantity) AS total_sold
FROM ORDER_DETAIL od
JOIN BOOK b ON od.book_id = b.book_id
GROUP BY b.title;

-- Total spent for each different customer:
SELECT c.name, SUM(od.quantity * od.price) AS total_spent
FROM ORDER_DETAIL od
JOIN ORDERS o ON od.order_id = o.order_id
JOIN CUSTOMER c ON o.customer_id = c.customer_id
GROUP BY c.name;

