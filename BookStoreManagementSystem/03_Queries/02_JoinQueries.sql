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

