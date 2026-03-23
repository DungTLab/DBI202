-- =========================================================================
-- Duy 
-- Check the current order details and warehouse stock before running the procedure.
-- =========================================================================
PRINT '--- 1. PRE-CANCELLATION STATUS ---';
SELECT 
    od.order_id AS [Order ID], 
    b.book_id AS [Book ID], 
    b.title AS [Book Title], 
    od.quantity AS [Ordered Qty], 
    b.quantity AS [Current Stock]
FROM ORDER_DETAIL od
JOIN BOOK b ON od.book_id = b.book_id
WHERE od.order_id = 15;

-- =========================================================================
-- This command will trigger the deletion and the stock update (via Trigger).
-- =========================================================================
EXEC sp_CancelOrder @order_id = 15;

-- =========================================================================
-- Confirm that the order is gone and the stock has increased.
-- =========================================================================
PRINT '--- 2. POST-CANCELLATION VERIFICATION ---';

-- Verify if Order 15 still exists (Expected: 0 rows)
SELECT 
    'Order 15 Data' AS [Check Target], 
    COUNT(*) AS [Remaining Rows] 
FROM ORDER_DETAIL 
WHERE order_id = 15;

-- Verify Stock Change (Expected: Stock should increase)
SELECT 
    book_id AS [Book ID], 
    title AS [Book Title], 
    quantity AS [Final Stock After Cancellation]
FROM BOOK 
WHERE book_id = 18;