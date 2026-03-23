/* =============================================================================
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
