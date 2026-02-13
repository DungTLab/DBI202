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