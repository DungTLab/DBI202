/* =============================================================================
AUTHOR: Nguyen Tran Duc Anh (CE20031)
ROLE: Team Leader, BOOK
=============================================================================
*/

/* -----------------------------------------------------------------------------
Procedure: sp_BulkUpdateBookPrice
Purpose: Bulk update prices for books published before a certain year
-----------------------------------------------------------------------------
*/
CREATE PROCEDURE sp_BulkUpdateBookPrice
    @percentage_change DECIMAL(5,2),
    @public_year_threshold INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE BOOK
        SET price = price * (1 + @percentage_change / 100)
        WHERE public_year < @public_year_threshold;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
