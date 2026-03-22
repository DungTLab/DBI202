/* =============================================================================
AUTHOR: Tran Huynh Giac (CE200291)
ROLE: ORDER_DETAIL
============================================================================= */

/* -----------------------------------------------------------------------------
Procedure: sp_AddBookToOrder
Purpose: Handles INSERT into ORDER_DETAIL.
Note: Stock checking and deduction are 100% delegated to the trg_Insert_OrderDetail trigger.
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_AddBookToOrder
    @order_id INT,           -- The ID of the order
    @book_id INT,            -- The ID of the book being ordered
    @quantity INT,           -- The requested quantity
    @price DECIMAL(10,2)     -- The price at the time of purchase
AS
BEGIN
    BEGIN TRY
        -- Start a transaction to ensure data integrity
        BEGIN TRANSACTION;
        
        -- Perform the INSERT operation. 
        -- The trigger (trg_Insert_OrderDetail) will automatically fire to check stock and deduct inventory.
        INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price)
        VALUES (@order_id, @book_id, @quantity, @price);

        -- Commit the transaction if the INSERT and the trigger execution are both successful
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if any error occurs (e.g., trigger raises an 'out of stock' error)
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Pass the error message up to the calling application (C#, Java, etc.)
        THROW;
    END CATCH
END;
GO

