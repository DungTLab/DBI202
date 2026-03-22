-- Trigger: Prevent deleting a customer if they have related orders.(Trọng)
-- Type: INSTEAD OF DELETE (intercepts the delete attempt and applies custom logic).
CREATE TRIGGER trg_Prevent_Delete_Customer
ON CUSTOMER
INSTEAD OF DELETE
AS
BEGIN
    -- Check whether any customer in the DELETE set appears in ORDERS.
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN ORDERS o ON d.customer_id = o.customer_id
    )
    BEGIN
        -- Block the operation with a business-rule error.
        RAISERROR ('Cannot delete customer with existing orders.', 16, 1);
        RETURN;
    END

    -- If no related orders exist, proceed with deleting the target customer rows.
    DELETE FROM CUSTOMER
    WHERE customer_id IN (SELECT customer_id FROM deleted);
END;
GO

/* ==========================================================
   1. TRIGGER INSERT (DUY) - XỬ LÝ KHI THÊM CHI TIẾT ĐƠN HÀNG
========================================================== */
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
    END;

    -- Trừ tồn kho
    UPDATE b
    SET b.quantity = b.quantity - i.quantity
    FROM BOOK b
    JOIN inserted i ON b.book_id = i.book_id;
END;
GO

/* ==========================================================
   2. TRIGGER DELETE (GIÁC) - XỬ LÝ KHI XÓA CHI TIẾT ĐƠN HÀNG
========================================================== */
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

/* ==========================================================
   3. TRIGGER UPDATE (GIÁC) - XỬ LÝ KHI SỬA CHI TIẾT ĐƠN HÀNG
========================================================== */
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
    END;

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
    END;
END;
GO