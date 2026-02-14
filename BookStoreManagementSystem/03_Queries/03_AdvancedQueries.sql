-- Count how many orders each customer made
SELECT customer_id,
       COUNT(order_id) AS total_orders
FROM ORDERS
GROUP BY customer_id;


-- Calculate total quantity of books sold
SELECT SUM(quantity) AS total_books_sold
FROM ORDER_DETAIL;



