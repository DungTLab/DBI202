/* =============================================================================
AUTHOR: Tran Huynh Giac (CE200291)
ROLE: ORDER_DETAIL

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
AUTHOR: Huynh Nhat Duy (CE201224)
ROLE: Supporter, ORDER
*/

/* -----------------------------------------------------------------------------
Procedure: sp_CancelOrder
Purpose: Cancel an entire order by deleting ORDER_DETAIL first, then ORDERS
-----------------------------------------------------------------------------
*/

CREATE PROCEDURE sp_CancelOrder
    @order_id INT
AUTHOR: Nguyen Phu Trong (CE200340)
ROLE: Supporter, CUSTOMER
*/

/* -----------------------------------------------------------------------------
Procedure: sp_CreateCustomerAndOrder
Purpose: Create a new customer and their first order simultaneously
-----------------------------------------------------------------------------
*/
CREATE PROCEDURE sp_CreateCustomerAndOrder
    @customer_id INT,
    @name VARCHAR(100),
    @phone VARCHAR(15),
    @email VARCHAR(100),
    @order_id INT,
    @order_date DATE
AUTHOR: Nguyen Tran Duc Anh (CE20031)
ROLE: Team Leader, BOOK
*/

/* -----------------------------------------------------------------------------
Procedure: sp_BulkUpdateBookPrice
Purpose: Bulk update prices for books published by its ID
-----------------------------------------------------------------------------
*/
CREATE PROCEDURE sp_BulkUpdateBookPrice
    @percentage_change DECIMAL(5,2),
    @book_id INT
AUTHOR: Le Tien Dung (CE201046)
ROLE: Project Manager, AUTHOR
*/

/* -----------------------------------------------------------------------------
Procedure: sp_DeleteAuthor
Purpose: Delete an author and handle constraints with existing books
-----------------------------------------------------------------------------
*/
CREATE PROCEDURE sp_DeleteAuthor
    @author_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Delete order details first (Trigger trg_Delete_OrderDetail handles stock restoration)
        DELETE FROM ORDER_DETAIL WHERE order_id = @order_id;

        -- Delete the main order record
        DELETE FROM ORDERS WHERE order_id = @order_id;
        -- Insert new customer details
        INSERT INTO CUSTOMER (customer_id, name, phone, email)
        VALUES (@customer_id, @name, @phone, @email);

        -- Insert new order linked to the created customer
        INSERT INTO ORDERS (order_id, customer_id, order_date)
        VALUES (@order_id, @customer_id, @order_date);
        UPDATE BOOK
        SET price = price * (1 + @percentage_change / 100)
        WHERE book_id = @book_id;

        -- Validate if the author's books have already been sold
        IF EXISTS (
            SELECT 1
            FROM BOOK_AUTHOR ba
            JOIN ORDER_DETAIL od ON ba.book_id = od.book_id
            WHERE ba.author_id = @author_id
        )
        BEGIN
            RAISERROR ('Cannot delete author. Associated books exist in order history.', 16, 1);
        END

        -- Remove associations in the bridging table
        DELETE FROM BOOK_AUTHOR WHERE author_id = @author_id;

        -- Remove the author record
        DELETE FROM AUTHOR WHERE author_id = @author_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO



GO
