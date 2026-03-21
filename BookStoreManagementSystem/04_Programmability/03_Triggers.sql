--Trigger Kiểm tra tồn kho và trừ kho khi insert order_detail -- Duy
CREATE TRIGGER trg_Insert_OrderDetail
ON ORDER_DETAIL
AFTER INSERT
AS
BEGIN
    -- Kiểm tra tồn kho
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN BOOK b ON i.book_id = b.book_id
        WHERE i.quantity > b.quantity
    )
    BEGIN
        RAISERROR ('Not enough stock available.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Trừ tồn kho
    UPDATE b
    SET b.quantity = b.quantity - i.quantity
    FROM BOOK b
    JOIN inserted i ON b.book_id = i.book_id;
END;
GO
