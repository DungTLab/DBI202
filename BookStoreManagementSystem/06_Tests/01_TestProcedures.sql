/* =============================================================================
AUTHOR: Nguyen Tran Duc Anh (CE20031)
ROLE: Team Leader, BOOK
============================================================================= */


/*
    Procedure: sp_BulkUpdateBookPrice
    Purpose: Bulk update prices for books published by its ID
*/

/*
    Testcase 1: Increase book price by 10% for book with ID 5
*/ 
EXEC sp_BulkUpdateBookPrice 
    @percentage_change = 10.00, 
    @book_id = 5;

/*
    Testcase 2: Decrease book price by 5% for book with ID 12
*/
EXEC sp_BulkUpdateBookPrice 
    @percentage_change = -5.00, 
    @book_id = 12;


/*
    Trigger: trg_Prevent_Delete_Book
    Description: Prevent deleting a book if it has been bought (exists in ORDER_DETAIL).
*/
DELETE FROM BOOK WHERE book_id = 2