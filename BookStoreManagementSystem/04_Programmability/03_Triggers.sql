/*Order details trigger - Giac*/

/* 
Trigger: Restore warehouse stock when ORDER_DETAIL is deleted

Purpose:
- Return the quantity of books back to the warehouse (BOOK table)
  when an order detail is removed.
- Ensure stock consistency when items are canceled or deleted from an order.
*/

CREATE TRIGGER trg_Delete_OrderDetail
ON ORDER_DETAIL
AFTER DELETE
AS
BEGIN
    -- Add the deleted quantity back to the stock
    UPDATE b
    SET b.quantity = b.quantity + d.quantity
    FROM BOOK b
    JOIN deleted d ON b.book_id = d.book_id;
END;
GO

/* 
Trigger: Update warehouse stock when ORDER_DETAIL is updated

Purpose:
- Adjust the book quantity in the warehouse (BOOK table) when an order detail is updated.
- Prevent changing the book_id in an existing order detail.
- Ensure that stock quantity never becomes negative.
*/

CREATE TRIGGER trg_Update_OrderDetail
ON ORDER_DETAIL
AFTER UPDATE
AS
BEGIN
    -- Prevent changing the book_id in an existing order detail
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d 
            ON i.order_id = d.order_id
        WHERE i.book_id <> d.book_id
    )
    BEGIN
        RAISERROR ('Cannot change book in order detail.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Adjust stock quantity:
    -- New stock = current stock + old quantity (returned) - new quantity (sold)
    UPDATE b
    SET b.quantity = b.quantity + d.quantity - i.quantity
    FROM BOOK b
    JOIN inserted i ON b.book_id = i.book_id
    JOIN deleted d 
        ON i.order_id = d.order_id
        AND i.book_id = d.book_id;

    -- Ensure stock does not become negative
    IF EXISTS (
        SELECT 1
        FROM BOOK
        WHERE quantity < 0
    )
    BEGIN
        RAISERROR ('Stock cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO