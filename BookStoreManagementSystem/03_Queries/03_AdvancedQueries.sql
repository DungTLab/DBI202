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