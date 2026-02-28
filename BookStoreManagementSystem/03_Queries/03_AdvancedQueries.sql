/* Book queries - Duc Anh*/

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

/* Author queries - Dung*/

SELECT a.name, COUNT(ba.book_id) AS total_books
From AUTHOR a
JOIN BOOK_AUTHOR ba ON a.author_id = ba.author_id
GROUP BY a.name
ORDER BY total_books DESC;

/* Orders queries - Duy*/

-- Count how many orders each customer made
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM ORDERS
GROUP BY customer_id;


-- Calculate total quantity of books sold
SELECT SUM(quantity) AS total_books_sold
FROM ORDER_DETAIL;

/* Order_Detail quetry - Giac*/

/*SUBQUERY*/

-- Select books having greatest total sold:
SELECT b.title, SUM(od.quantity) AS total_sold
FROM ORDER_DETAIL od
JOIN BOOK b ON od.book_id = b.book_id
GROUP BY b.title
HAVING SUM(od.quantity) = (
	SELECT MAX(total_sold)
	FROM (
		SELECT SUM(quantity) AS total_sold
		FROM ORDER_DETAIL
		GROUP BY book_id
	) AS temp
);

-- Select orders having greatest total amount
SELECT order_id
FROM ORDER_DETAIL 
GROUP BY order_id
HAVING SUM(quantity * price) = (
	SELECT MAX(total_amount)
	FROM (
		SELECT SUM(quantity * price) AS total_amount
		FROM ORDER_DETAIL
		GROUP BY order_id
	) AS temp
);

/* Customer queries - Trong*/

/* Advanced Queries for Customer Table */

/* show the top 5 customers who have spent the most money on orders */
SELECT TOP 5
    C.customer_id,
    C.name,
    SUM(OD.quantity * OD.price) AS total_spent
FROM CUSTOMER C
JOIN ORDERS O ON O.customer_id = C.customer_id
JOIN ORDER_DETAIL OD ON OD.order_id = O.order_id
GROUP BY C.customer_id, C.name
ORDER BY total_spent DESC;