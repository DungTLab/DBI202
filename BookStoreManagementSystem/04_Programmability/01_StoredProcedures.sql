/* =============================================================================
AUTHOR: Huynh Nhat Duy (CE201224)
ROLE: Supporter, ORDER
=============================================================================
*/

/* -----------------------------------------------------------------------------
Procedure: sp_CancelOrder
Purpose: Cancel an entire order by deleting ORDER_DETAIL first, then ORDERS
-----------------------------------------------------------------------------
*/
CREATE PROCEDURE sp_CancelOrder
    @order_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Delete order details first (Trigger trg_Delete_OrderDetail handles stock restoration)
        DELETE FROM ORDER_DETAIL WHERE order_id = @order_id;

        -- Delete the main order record
        DELETE FROM ORDERS WHERE order_id = @order_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
