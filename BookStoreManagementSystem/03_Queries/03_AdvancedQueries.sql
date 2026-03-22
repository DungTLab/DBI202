/* =========================================================================
   Table: BOOK
   Author: Duc Anh
   ========================================================================= */

/* ADVANCED QUERIES */

-- Retrieve books that have never been ordered
SELECT *
FROM BOOK
WHERE book_id NOT IN (
    SELECT book_id 
    FROM ORDER_DETAIL
);

-- Retrieve books with a price higher than the overall average book price
SELECT *
FROM BOOK
WHERE price > (
    SELECT AVG(price) 
    FROM BOOK
);


/* =========================================================================
   Table: AUTHOR
   Author: Dung
   ========================================================================= */

-- Count the total number of books written by each author and order by the highest count
SELECT a.name, COUNT(ba.book_id) AS total_books
FROM AUTHOR a
JOIN BOOK_AUTHOR ba ON a.author_id = ba.author_id
GROUP BY a.name
ORDER BY total_books DESC;


/* =========================================================================
   Table: ORDERS
   Author: Duy
   ========================================================================= */

-- Count the total number of orders placed by each customer
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM ORDERS
GROUP BY customer_id;

-- Calculate the total quantity of all books sold across all orders
SELECT SUM(quantity) AS total_books_sold
FROM ORDER_DETAIL;


/* =========================================================================
   Table: ORDER_DETAIL
   Author: Giac
   ========================================================================= */

/* SUBQUERIES */

-- Retrieve the book(s) with the highest total quantity sold
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

-- Retrieve the order(s) with the highest total amount spent
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


/* =========================================================================
   Table: CUSTOMER
   Author: Trong
   ========================================================================= */

/* ADVANCED QUERIES */

-- Retrieve the top 5 customers who have spent the most money, ordered by total spent
SELECT TOP 5
    C.customer_id,
    C.name,
    SUM(OD.quantity * OD.price) AS total_spent
FROM CUSTOMER C
JOIN ORDERS O ON O.customer_id = C.customer_id
JOIN ORDER_DETAIL OD ON OD.order_id = O.order_id
GROUP BY C.customer_id, C.name
ORDER BY total_spent DESC;