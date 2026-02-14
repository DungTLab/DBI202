--Get all orders
SELECT 
	* FROM ORDERS;

--Get orders by customer id = 3
SELECT * 
	FROM ORDERS
	WHERE customer_id = 3;

-- Get orders after 2024-01-01
SELECT *
FROM ORDERS
WHERE order_date > '2024-01-01';
