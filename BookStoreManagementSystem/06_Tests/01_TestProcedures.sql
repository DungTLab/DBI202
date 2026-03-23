/* =============================================================================
AUTHOR: Le Tien Dung (CE201046)
ROLE: Project Manager, AUTHOR
============================================================================= */

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