-- Show order info with customer name
SELECT o.order_id,
       o.order_date,
       c.name
FROM ORDERS o
JOIN CUSTOMER c 
ON o.customer_id = c.customer_id;
