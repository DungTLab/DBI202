/* =============================================================================
AUTHOR: Le Tien Dung (CE201046)
ROLE: Project Manager, AUTHOR
=============================================================================
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
