-- Duy Ne
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

PRINT '=====================================================';
PRINT 'TEST CASE 2: INSUFFICIENT STOCK (SHOULD FAIL)';
PRINT '=====================================================';

-- 1. SHOW STATE BEFORE
PRINT '--- BEFORE FAILED INSERT ---';
SELECT book_id, title, quantity AS [Stock_Current] 
FROM BOOK WHERE book_id = 19;

-- 2. EXECUTE INSERT (Try to buy 9999 units)
BEGIN TRY
    INSERT INTO ORDERS (order_id, customer_id, order_date) VALUES (31, 15, GETDATE());
    INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price) VALUES (31, 19, 9999, 15.00);
END TRY
BEGIN CATCH
    PRINT '>>> System Message: ' + ERROR_MESSAGE();
END CATCH

-- 3. SHOW STATE AFTER (Stock should NOT change)
PRINT '--- AFTER FAILED INSERT ---';
SELECT book_id, title, quantity AS [Stock_Final_Stayed_Same] 
FROM BOOK WHERE book_id = 19;

-- Verify that Order 31 was NOT created due to Rollback
SELECT 'Order 31 Count' AS [Check], COUNT(*) FROM ORDERS WHERE order_id = 31;