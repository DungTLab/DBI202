/* Join Queries for Customer Table */

/* show all orders made by a specific customer (customer_id = 1), including the book details and order information */
SELECT 
    C.name,
    O.order_id,
    O.order_date,
    B.title,
    OD.quantity,
    OD.price
FROM CUSTOMER C
JOIN ORDERS O 
    ON C.customer_id = O.customer_id
JOIN ORDER_DETAIL OD 
    ON O.order_id = OD.order_id
JOIN BOOK B 
    ON OD.book_id = B.book_id
WHERE C.customer_id = 1;