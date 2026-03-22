/* =============================================================================
AUTHOR: Nguyen Phu Trong (CE200340)
ROLE: Supporter, CUSTOMER
=============================================================================
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

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
