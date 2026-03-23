/* =============================================================================
   ORDER_DETAIL PROCEDURES
   Author: Tran Huynh Giac
   ============================================================================= */

-- -----------------------------------------------------------------------------
-- TEST CASE 1: Add a valid book to an order (Success)
-- Objective: Add book ID 2 (De Men Phieu Luu Ky) to Order ID 1 with a quantity of 5.
-- Expected: Data is inserted into ORDER_DETAIL, stock quantity of Book 2 decreases by 5.
-- -----------------------------------------------------------------------------
PRINT '--- TEST 1: Add book successfully ---';
DECLARE @stock_before_1 INT, @stock_after_1 INT;
SELECT @stock_before_1 = quantity FROM BOOK WHERE book_id = 2;
PRINT '>> Book stock (ID 2) BEFORE insert: ' + CAST(@stock_before_1 AS VARCHAR);

EXEC sp_AddBookToOrder @order_id = 1, @book_id = 2, @quantity = 5, @price = 12.00;

SELECT @stock_after_1 = quantity FROM BOOK WHERE book_id = 2;
PRINT '>> Book stock (ID 2) AFTER insert: ' + CAST(@stock_after_1 AS VARCHAR);
IF (@stock_before_1 - 5 = @stock_after_1)
    PRINT '[PASS] Stock deducted correctly!';
ELSE 
    PRINT '[FAIL] Stock calculation is incorrect!';

-- -----------------------------------------------------------------------------
-- TEST CASE 2: Add book fails due to exceeding stock quantity (Blocked by Trigger)
-- Objective: Add book ID 3 (Harry Potter 1) to Order ID 2 with a quantity of 9999.
-- Expected: Trigger trg_Insert_OrderDetail raises error "Not enough stock available", ROLLBACK.
-- -----------------------------------------------------------------------------
PRINT '--- TEST 2: Add book fails (Out of stock) ---';
BEGIN TRY
    EXEC sp_AddBookToOrder @order_id = 2, @book_id = 3, @quantity = 9999, @price = 25.00;
    PRINT '[FAIL] Error: Procedure was not blocked when out of stock!';
END TRY
BEGIN CATCH
    PRINT '[PASS] Successfully blocked with message: ' + ERROR_MESSAGE();
END CATCH;


PRINT '======================================================================';
PRINT 'START TESTING: sp_UpdateOrderDetailQuantity';
PRINT '======================================================================';

-- -----------------------------------------------------------------------------
-- TEST CASE 3: Increase order quantity successfully (Success)
-- Objective: Order 1, Book 3 currently has 2 items, want to increase to 10 items (Add 8 items).
-- Expected: ORDER_DETAIL is updated to 10, stock is further deducted by 8.
-- -----------------------------------------------------------------------------
PRINT '--- TEST 3: Increase quantity successfully ---';
DECLARE @stock_before_3 INT, @stock_after_3 INT;
SELECT @stock_before_3 = quantity FROM BOOK WHERE book_id = 3;
PRINT '>> Book stock (ID 3) BEFORE update: ' + CAST(@stock_before_3 AS VARCHAR);

EXEC sp_UpdateOrderDetailQuantity @order_id = 1, @book_id = 3, @new_quantity = 10;

SELECT @stock_after_3 = quantity FROM BOOK WHERE book_id = 3;
PRINT '>> Book stock (ID 3) AFTER update: ' + CAST(@stock_after_3 AS VARCHAR);
IF (@stock_before_3 - 8 = @stock_after_3)
    PRINT '[PASS] Stock adjusted and deducted correctly (deducted 8 more)!';
ELSE 
    PRINT '[FAIL] Stock calculation is incorrect!';

-- -----------------------------------------------------------------------------
-- TEST CASE 4: Decrease order quantity successfully (Success)
-- Objective: Order 1, Book 3 currently has 10 items (after Test 3), want to decrease to 1 item.
-- Expected: ORDER_DETAIL is updated to 1, stock is refunded by 9 items.
-- -----------------------------------------------------------------------------
PRINT '--- TEST 4: Decrease quantity successfully ---';
DECLARE @stock_before_4 INT, @stock_after_4 INT;
SELECT @stock_before_4 = quantity FROM BOOK WHERE book_id = 3;
PRINT '>> Book stock (ID 3) BEFORE update: ' + CAST(@stock_before_4 AS VARCHAR);

EXEC sp_UpdateOrderDetailQuantity @order_id = 1, @book_id = 3, @new_quantity = 1;

SELECT @stock_after_4 = quantity FROM BOOK WHERE book_id = 3;
PRINT '>> Book stock (ID 3) AFTER update: ' + CAST(@stock_after_4 AS VARCHAR);
IF (@stock_before_4 + 9 = @stock_after_4)
    PRINT '[PASS] Stock adjusted and increased correctly (refunded 9)!';
ELSE 
    PRINT '[FAIL] Stock calculation is incorrect!';

