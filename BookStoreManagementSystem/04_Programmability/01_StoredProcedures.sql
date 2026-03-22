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

/* -----------------------------------------------------------------------------
Procedure: sp_UpdateOrderDetailQuantity
Purpose: Updates the quantity of a specific book in an order.
Note: The trg_Update_OrderDetail trigger will automatically adjust the stock difference.
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_UpdateOrderDetailQuantity
    @order_id INT,           -- The ID of the order containing the book
    @book_id INT,            -- The ID of the book to be updated
    @new_quantity INT        -- The new requested quantity
AS
BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Update the quantity in the ORDER_DETAIL table.
        -- The trigger will handle stock compensation and rollback if stock becomes negative.
        UPDATE ORDER_DETAIL
        SET quantity = @new_quantity
        WHERE order_id = @order_id AND book_id = @book_id;

        -- Commit the transaction upon success
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback if an error occurs during the update or within the trigger
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Pass the error up to the application
        THROW;
    END CATCH
END;
GO

/* -----------------------------------------------------------------------------
Procedure: sp_RemoveBookFromOrder
Purpose: Removes a specific book from an order detail.
Note: The trg_Delete_OrderDetail trigger will automatically restore the stock.
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_RemoveBookFromOrder
    @order_id INT,           -- The ID of the target order
    @book_id INT             -- The ID of the book to be removed
AS
BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Delete the specific detail record. 
        -- The trigger will automatically return the deleted quantity back to the BOOK inventory.
        DELETE FROM ORDER_DETAIL
        WHERE order_id = @order_id AND book_id = @book_id;

        -- Commit the transaction upon success
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Pass the error up to the application
        THROW;
    END CATCH
END;
GO



