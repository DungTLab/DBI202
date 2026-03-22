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