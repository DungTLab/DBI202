/* Book triggers - Duc Anh*/

-- Prevent delete book information if it have been bought by customer:
CREATE TRIGGER trg_Prevent_Delete_Book
ON BOOK
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN ORDER_DETAIL od ON d.book_id = od.book_id
    )
    BEGIN
        RAISERROR ('Cannot delete book that has been sold.', 16, 1);
        RETURN;
    END

    DELETE FROM BOOK
    WHERE book_id IN (SELECT book_id FROM deleted);
END;
