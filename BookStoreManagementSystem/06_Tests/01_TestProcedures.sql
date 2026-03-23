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

-- -----------------------------------------------------------------------------
-- TEST CASE 5: Increase quantity fails due to insufficient stock (Blocked by Trigger)
-- Objective: Update Order 1, Book 3 to a quantity of 5000.
-- Expected: Trigger trg_Update_OrderDetail raises error "Stock cannot be negative", ROLLBACK.
-- -----------------------------------------------------------------------------
PRINT '--- TEST 5: Update fails (Negative stock) ---';
BEGIN TRY
    EXEC sp_UpdateOrderDetailQuantity @order_id = 1, @book_id = 3, @new_quantity = 5000;
    PRINT '[FAIL] Error: Procedure was not blocked when exceeding stock!';
END TRY
BEGIN CATCH
    PRINT '[PASS] Successfully blocked with message: ' + ERROR_MESSAGE();
END CATCH;


PRINT '======================================================================';
PRINT 'START TESTING: sp_RemoveBookFromOrder';
PRINT '======================================================================';

-- -----------------------------------------------------------------------------
-- TEST CASE 6: Remove book from order successfully (Success)
-- Objective: Remove book (ID 4 - 1984) previously bought (1 item) from Order ID 1.
-- Expected: The record is deleted from ORDER_DETAIL, 1 item is refunded to book stock ID 4.
-- -----------------------------------------------------------------------------
PRINT '--- TEST 6: Remove order detail successfully ---';
DECLARE @stock_before_6 INT, @stock_after_6 INT;
SELECT @stock_before_6 = quantity FROM BOOK WHERE book_id = 4;
PRINT '>> Book stock (ID 4) BEFORE deletion: ' + CAST(@stock_before_6 AS VARCHAR);

EXEC sp_RemoveBookFromOrder @order_id = 1, @book_id = 4;

SELECT @stock_after_6 = quantity FROM BOOK WHERE book_id = 4;
PRINT '>> Book stock (ID 4) AFTER deletion: ' + CAST(@stock_after_6 AS VARCHAR);
IF (@stock_before_6 + 1 = @stock_after_6)
    PRINT '[PASS] Stock has been refunded correctly (added 1)!';
ELSE 
    PRINT '[FAIL] Stock calculation is incorrect!';
    
IF NOT EXISTS (SELECT 1 FROM ORDER_DETAIL WHERE order_id = 1 AND book_id = 4)
    PRINT '[PASS] Data in ORDER_DETAIL has been successfully deleted!';
ELSE
    PRINT '[FAIL] Data in ORDER_DETAIL still exists!';
AUTHOR: Le Tien Dung (CE201046)
ROLE: Project Manager, AUTHOR

/* -----------------------------------------------------------------------------
Procedure: sp_DeleteAuthor
Purpose: Delete an author and handle constraints with existing books
----------------------------------------------------------------------------- */
USE [BookStoreManagementSystem];
GO

-- 1. SETUP: Create dummy author, book, and simulate a sale (order_id 1 must exist)
INSERT INTO AUTHOR (author_id, name, nationality) VALUES (999, 'Dummy Author', 'US');
INSERT INTO BOOK (book_id, title, price, public_year, quantity) VALUES (999, 'Dummy Book', 10.0, 2024, 10);
INSERT INTO BOOK_AUTHOR (book_id, author_id) VALUES (999, 999);
INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price) VALUES (1, 999, 1, 10.0);
GO

-- 2. TEST: Attempt to delete the author (Should FAIL because the book was sold)
BEGIN TRY
    EXEC sp_DeleteAuthor @author_id = 999;
    PRINT 'TEST FAILED: Author was deleted unexpectedly.';
END TRY
BEGIN CATCH
    PRINT 'TEST PASSED: Deletion prevented. Error: ' + ERROR_MESSAGE();
END CATCH
GO

-- 3. CLEANUP: Remove dummy data safely
DELETE FROM ORDER_DETAIL WHERE book_id = 999 AND order_id = 1;
DELETE FROM BOOK_AUTHOR WHERE author_id = 999;
DELETE FROM BOOK WHERE book_id = 999;
DELETE FROM AUTHOR WHERE author_id = 999;
GO
