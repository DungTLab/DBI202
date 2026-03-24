USE [BookStoreManagementSystem];
GO

/* =============================================================================
1. PART OF: Huynh Nhat Duy (CE201224) - ORDER
============================================================================= */
PRINT '======================================================================';
PRINT 'DEMO: sp_CancelOrder (Huynh Nhat Duy)';
PRINT '======================================================================';

-- [SETUP] Clean up old data and create dummy data for Duy's test
BEGIN TRY
    DELETE FROM ORDER_DETAIL WHERE order_id = 91001; 
    DELETE FROM ORDERS WHERE order_id = 91001;
    DELETE FROM CUSTOMER WHERE customer_id = 91001; 
    DELETE FROM BOOK WHERE book_id = 91001;
END TRY BEGIN CATCH END CATCH;

INSERT INTO CUSTOMER
    (customer_id, name, phone, email)
VALUES
    (91001, 'Duy Demo', '0111', 'duy@ex.com');
INSERT INTO BOOK
    (book_id, title, price, public_year, quantity)
VALUES
    (91001, 'Book Duy', 10.00, 2024, 100);
INSERT INTO ORDERS
    (order_id, customer_id, order_date)
VALUES
    (91001, 91001, GETDATE());
INSERT INTO ORDER_DETAIL
    (order_id, book_id, quantity, price)
VALUES
    (91001, 91001, 5, 10.00);

-- [TEST] Cancel order 91001 and verify stock update
PRINT '>> Executing sp_CancelOrder...';
EXEC sp_CancelOrder @order_id = 91001;

IF NOT EXISTS (SELECT 1
FROM ORDER_DETAIL
WHERE order_id = 91001)
    PRINT '[PASS] Order 91001 has been successfully canceled and removed.';
ELSE
    PRINT '[FAIL] Order 91001 still exists!';

-- [CLEANUP] Remove dummy data to keep the database clean
DELETE FROM BOOK WHERE book_id = 91001;
DELETE FROM CUSTOMER WHERE customer_id = 91001;
GO


/* =============================================================================
2. PART OF: Nguyen Phu Trong (CE201046) - CUSTOMER
============================================================================= */
PRINT '======================================================================';
PRINT 'DEMO: sp_CreateCustomerAndOrder (Nguyen Phu Trong)';
PRINT '======================================================================';

-- [SETUP & TEST 1] Successfully create a new customer and their first order
BEGIN TRY
    DELETE FROM ORDER_DETAIL WHERE order_id = 92001; 
    DELETE FROM ORDERS WHERE order_id = 92001;
    DELETE FROM CUSTOMER WHERE customer_id = 92001;

    EXEC sp_CreateCustomerAndOrder @customer_id = 92001, @name = 'Trong Demo', @phone = '0222', @email = 'trong@ex.com', @order_id = 92001, @order_date = '2026-03-23';
    PRINT '[PASS] TC01: CUSTOMER and ORDERS were successfully created.';
END TRY BEGIN CATCH PRINT '[ERROR] TC01: ' + ERROR_MESSAGE(); END CATCH;

-- [TEST 2] Intentionally create a duplicate Customer ID to test constraints
BEGIN TRY
    -- Đã sửa GETDATE() thành '2026-03-23' để tránh lỗi cú pháp
    EXEC sp_CreateCustomerAndOrder @customer_id = 92001, @name = 'Dup', @phone = '00', @email = 'dup@ex.com', @order_id = 92002, @order_date = '2026-03-23';
END TRY BEGIN CATCH PRINT '[PASS] TC02 (Blocked Dupe Customer): ' + ERROR_MESSAGE(); END CATCH;

-- [CLEANUP] Remove dummy data
DELETE FROM ORDERS WHERE order_id = 92001;
DELETE FROM CUSTOMER WHERE customer_id = 92001;
GO


/* =============================================================================
3. PART OF: Nguyen Tran Duc Anh (CE20031) - BOOK
============================================================================= */
PRINT '======================================================================';
PRINT 'DEMO: BOOK Procedures & Triggers (Nguyen Tran Duc Anh)';
PRINT '======================================================================';

-- [SETUP] Create dummy data for Duc Anh's test
BEGIN TRY
    DELETE FROM ORDER_DETAIL WHERE order_id = 93001; 
    DELETE FROM ORDERS WHERE order_id = 93001;
    DELETE FROM CUSTOMER WHERE customer_id = 93001; 
    DELETE FROM BOOK WHERE book_id = 93001 OR book_id = 93002;
END TRY BEGIN CATCH END CATCH;

INSERT INTO BOOK
    (book_id, title, price, public_year, quantity)
VALUES
    (93001, 'Book Price', 100.00, 2024, 10);
INSERT INTO BOOK
    (book_id, title, price, public_year, quantity)
VALUES
    (93002, 'Book Sold', 50.00, 2024, 10);
INSERT INTO CUSTOMER
    (customer_id, name, phone, email)
VALUES
    (93001, 'Anh Demo', '0333', 'anh@ex.com');
INSERT INTO ORDERS
    (order_id, customer_id, order_date)
VALUES
    (93001, 93001, GETDATE());
INSERT INTO ORDER_DETAIL
    (order_id, book_id, quantity, price)
VALUES
    (93001, 93002, 1, 50.00);

-- [TEST 1] Bulk update book prices
EXEC sp_BulkUpdateBookPrice @percentage_change = 10.00, @book_id = 93001;
PRINT '[PASS] Executed Bulk Update +10% successfully.';

-- [TEST 2] Intentionally delete a sold book to test the trigger's blocking mechanism
BEGIN TRY
    DELETE FROM BOOK WHERE book_id = 93002;
    PRINT '[FAIL] Book was deleted! Trigger did not block the action.';
END TRY BEGIN CATCH PRINT '[PASS] Trigger blocked deletion. Error: ' + ERROR_MESSAGE(); END CATCH;

-- [CLEANUP] Remove dummy data
DELETE FROM ORDER_DETAIL WHERE order_id = 93001;
DELETE FROM ORDERS WHERE order_id = 93001;
DELETE FROM CUSTOMER WHERE customer_id = 93001;
DELETE FROM BOOK WHERE book_id = 93001 OR book_id = 93002;
GO


/* =============================================================================
4. PART OF: Tran Huynh Giac - ORDER_DETAIL
============================================================================= */
PRINT '======================================================================';
PRINT 'DEMO: ORDER_DETAIL Procedures (Tran Huynh Giac)';
PRINT '======================================================================';

-- [SETUP] Create dummy data for Giac's test
BEGIN TRY
    DELETE FROM ORDER_DETAIL WHERE order_id = 94001 OR order_id = 94002; 
    DELETE FROM ORDERS WHERE order_id = 94001 OR order_id = 94002;
    DELETE FROM CUSTOMER WHERE customer_id = 94001; 
    DELETE FROM BOOK WHERE book_id = 94001 OR book_id = 94002;
END TRY BEGIN CATCH END CATCH;

INSERT INTO CUSTOMER
    (customer_id, name, phone, email)
VALUES
    (94001, 'Giac Demo', '0444', 'giac@ex.com');
INSERT INTO ORDERS
    (order_id, customer_id, order_date)
VALUES
    (94001, 94001, GETDATE()),
    (94002, 94001, GETDATE());
INSERT INTO BOOK
    (book_id, title, price, public_year, quantity)
VALUES
    (94001, 'Book A', 10.00, 2024, 100),
    (94002, 'Book B', 20.00, 2024, 5);

-- [TEST 1] Successfully add a book to an order (Stock deducted)
EXEC sp_AddBookToOrder @order_id = 94001, @book_id = 94001, @quantity = 10, @price = 10.00;
PRINT '[PASS] Add Book Success. Stock deducted.';

-- [TEST 2] Order exceeds available stock (Test Trigger Block)
BEGIN TRY
    EXEC sp_AddBookToOrder @order_id = 94002, @book_id = 94002, @quantity = 999, @price = 20.00;
END TRY BEGIN CATCH PRINT '[PASS] Blocked Out of Stock: ' + ERROR_MESSAGE(); END CATCH;

-- [TEST 3] Remove book from order (Stock refunded)
EXEC sp_RemoveBookFromOrder @order_id = 94001, @book_id = 94001;
PRINT '[PASS] Remove Book Success. Stock refunded.';

-- [CLEANUP] Remove dummy data
DELETE FROM ORDER_DETAIL WHERE order_id = 94001 OR order_id = 94002;
DELETE FROM ORDERS WHERE order_id = 94001 OR order_id = 94002;
DELETE FROM CUSTOMER WHERE customer_id = 94001;
DELETE FROM BOOK WHERE book_id = 94001 OR book_id = 94002;
GO


/* =============================================================================
5. PART OF: Le Tien Dung (CE201046) - AUTHOR
============================================================================= */
PRINT '======================================================================';
PRINT 'DEMO: sp_DeleteAuthor (Le Tien Dung)';
PRINT '======================================================================';

-- [SETUP] Create dummy data for Dung's test
BEGIN TRY
    DELETE FROM ORDER_DETAIL WHERE order_id = 95001; 
    DELETE FROM ORDERS WHERE order_id = 95001;
    DELETE FROM CUSTOMER WHERE customer_id = 95001; 
    DELETE FROM BOOK_AUTHOR WHERE author_id = 95001;
    DELETE FROM BOOK WHERE book_id = 95001; 
    DELETE FROM AUTHOR WHERE author_id = 95001;
END TRY BEGIN CATCH END CATCH;

INSERT INTO AUTHOR
    (author_id, name, nationality)
VALUES
    (95001, 'Dung Demo Author', 'US');
INSERT INTO BOOK
    (book_id, title, price, public_year, quantity)
VALUES
    (95001, 'Dung Book', 10.0, 2024, 10);
INSERT INTO BOOK_AUTHOR
    (book_id, author_id)
VALUES
    (95001, 95001);
INSERT INTO CUSTOMER
    (customer_id, name, phone, email)
VALUES
    (95001, 'Dung Cus', '0555', 'dung@ex.com');
INSERT INTO ORDERS
    (order_id, customer_id, order_date)
VALUES
    (95001, 95001, GETDATE());
INSERT INTO ORDER_DETAIL
    (order_id, book_id, quantity, price)
VALUES
    (95001, 95001, 1, 10.0);

-- [TEST] Intentionally delete an author whose books have been sold
BEGIN TRY
    PRINT '>> Attempting to delete author 95001...';
    EXEC sp_DeleteAuthor @author_id = 95001;
    PRINT '[FAIL] Author was deleted unexpectedly.';
END TRY BEGIN CATCH PRINT '[PASS] Deletion prevented. Error: ' + ERROR_MESSAGE(); END CATCH;

-- [CLEANUP] Remove dummy data
DELETE FROM ORDER_DETAIL WHERE order_id = 95001;
DELETE FROM ORDERS WHERE order_id = 95001;
DELETE FROM CUSTOMER WHERE customer_id = 95001;
DELETE FROM BOOK_AUTHOR WHERE author_id = 95001;
DELETE FROM BOOK WHERE book_id = 95001;
DELETE FROM AUTHOR WHERE author_id = 95001;
PRINT '>> Cleanup completed.';
GO