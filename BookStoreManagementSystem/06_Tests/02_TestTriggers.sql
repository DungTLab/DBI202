-- Duy
PRINT '=====================================================';
PRINT 'TEST CASE 1: SUCCESSFUL INSERT (STOCK DEDUCTION)';
PRINT '=====================================================';

-- 1. SHOW STATE BEFORE
PRINT '--- BEFORE INSERT ---';
SELECT book_id, title, quantity AS [Stock_Before] 
FROM BOOK WHERE book_id = 18;

-- 2. EXECUTE INSERT (Buy 2 units)
INSERT INTO ORDERS (order_id, customer_id, order_date) VALUES (30, 15, GETDATE());
INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price) VALUES (30, 18, 2, 23.00);

-- 3. SHOW STATE AFTER
PRINT '--- AFTER INSERT ---';
SELECT 
    od.order_id, 
    od.book_id, 
    od.quantity AS [Bought_Qty], 
    b.quantity AS [Stock_After]
FROM ORDER_DETAIL od
JOIN BOOK b ON od.book_id = b.book_id
WHERE od.order_id = 30;