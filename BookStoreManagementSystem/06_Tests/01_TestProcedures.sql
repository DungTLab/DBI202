/* =============================================================================
AUTHOR: Nguyen Phu Trong (CE201046)
ROLE: Supporter, CUSTOMER
PROCEDURE: sp_CreateCustomerAndOrder
USAGE: Run each test case block separately (scan block and execute).
============================================================================= */

/* -----------------------------------------------------------------------------
Test Case: TC01
Purpose: Valid input should create CUSTOMER and ORDERS.
Expected: PASS message and both rows exist.
----------------------------------------------------------------------------- */
DECLARE @tc01_customer_id INT = 90001;
DECLARE @tc01_order_id INT = 99001;
DECLARE @tc01_current_date DATETIME = GETDATE();

BEGIN TRY
	-- Clean old data to make this test re-runnable.
	DELETE FROM ORDER_DETAIL WHERE order_id = @tc01_order_id;
	DELETE FROM ORDERS WHERE order_id = @tc01_order_id;
	DELETE FROM CUSTOMER WHERE customer_id = @tc01_customer_id;

	EXEC sp_CreateCustomerAndOrder
		@customer_id = @tc01_customer_id,
		@name = 'TC01 Customer',
		@phone = '0900000001',
		@email = 'tc01.customer@example.com',
		@order_id = @tc01_order_id,
		@order_date = @tc01_current_date;

	IF EXISTS (SELECT 1 FROM CUSTOMER WHERE customer_id = @tc01_customer_id)
	   AND EXISTS (SELECT 1 FROM ORDERS WHERE order_id = @tc01_order_id AND customer_id = @tc01_customer_id)
	BEGIN
		PRINT 'TC01 PASS: CUSTOMER and ORDERS were created.';
	END
	ELSE
	BEGIN
		PRINT 'TC01 FAIL: Expected records were not created.';
	END
END TRY
BEGIN CATCH
	PRINT 'TC01 ERROR:';
	PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
	PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;
GO

/* -----------------------------------------------------------------------------
Test Case: TC02
Purpose: Duplicate customer_id should fail.
Expected: Error is printed by CATCH block.
----------------------------------------------------------------------------- */
DECLARE @tc02_customer_id INT = 90002;
DECLARE @tc02_order_id_existing INT = 99002;
DECLARE @tc02_order_id_new INT = 99003;
DECLARE @tc02_current_date DATETIME = GETDATE();

BEGIN TRY
	-- Prepare baseline data with an existing customer.
	DELETE FROM ORDER_DETAIL WHERE order_id IN (@tc02_order_id_existing, @tc02_order_id_new);
	DELETE FROM ORDERS WHERE order_id IN (@tc02_order_id_existing, @tc02_order_id_new);
	DELETE FROM CUSTOMER WHERE customer_id = @tc02_customer_id;

	INSERT INTO CUSTOMER (customer_id, name, phone, email)
	VALUES (@tc02_customer_id, 'TC02 Existing Customer', '0900000002', 'tc02.existing@example.com');

	INSERT INTO ORDERS (order_id, customer_id, order_date)
	VALUES (@tc02_order_id_existing, @tc02_customer_id, GETDATE());

	-- Call procedure with duplicate customer_id.
	EXEC sp_CreateCustomerAndOrder
		@customer_id = @tc02_customer_id,
		@name = 'TC02 Duplicate Customer',
		@phone = '0900000099',
		@email = 'tc02.duplicate@example.com',
		@order_id = @tc02_order_id_new,
		@order_date = @tc02_current_date;

	PRINT 'TC02 FAIL: Procedure should have thrown an error for duplicate customer_id.';
END TRY
BEGIN CATCH
	PRINT 'TC02 PASS (expected error captured):';
	PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
	PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;
GO

/* -----------------------------------------------------------------------------
Test Case: TC03
Purpose: Duplicate order_id should fail and rollback customer insert.
Expected: Error is printed and new customer is NOT persisted.
----------------------------------------------------------------------------- */
DECLARE @tc03_customer_existing INT = 90003;
DECLARE @tc03_customer_new INT = 90004;
DECLARE @tc03_order_id INT = 99004;
DECLARE @tc03_current_date DATETIME = GETDATE();

BEGIN TRY
	-- Prepare baseline data with an existing order_id.
	DELETE FROM ORDER_DETAIL WHERE order_id = @tc03_order_id;
	DELETE FROM ORDERS WHERE order_id = @tc03_order_id;
	DELETE FROM CUSTOMER WHERE customer_id IN (@tc03_customer_existing, @tc03_customer_new);

	INSERT INTO CUSTOMER (customer_id, name, phone, email)
	VALUES (@tc03_customer_existing, 'TC03 Existing Customer', '0900000003', 'tc03.existing@example.com');

	INSERT INTO ORDERS (order_id, customer_id, order_date)
	VALUES (@tc03_order_id, @tc03_customer_existing, GETDATE());

	-- Call procedure with duplicate order_id and a new customer_id.
	EXEC sp_CreateCustomerAndOrder
		@customer_id = @tc03_customer_new,
		@name = 'TC03 New Customer',
		@phone = '0900000004',
		@email = 'tc03.new@example.com',
		@order_id = @tc03_order_id,
		@order_date = @tc03_current_date;

	PRINT 'TC03 FAIL: Procedure should have thrown an error for duplicate order_id.';
END TRY
BEGIN CATCH
	PRINT 'TC03 PASS (expected error captured):';
	PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
	PRINT 'Error Message: ' + ERROR_MESSAGE();

	-- Verify transaction rollback behavior for the new customer row.
	IF EXISTS (SELECT 1 FROM CUSTOMER WHERE customer_id = @tc03_customer_new)
		PRINT 'TC03 FAIL: Rollback did not remove the new customer row.';
	ELSE
		PRINT 'TC03 PASS: New customer row was rolled back correctly.';
END CATCH;
GO

