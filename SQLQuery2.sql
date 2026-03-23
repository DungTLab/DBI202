SELECT book_id, title, quantity 
FROM BOOK 
WHERE book_id = 1;

INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price)
VALUES (1, 1, 5, 15.50);

SELECT book_id, title, quantity 
FROM BOOK 
WHERE book_id = 1;

DELETE FROM ORDER_DETAIL WHERE order_id = 1 AND book_id = 1;
INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price)
VALUES (1, 1, 1000, 15.50);

-- run procedure

drop table AUTHOR, BOOK_AUTHOR, CUSTOMER, ORDER_DETAIL,ORDERS, BOOK
GO
-- Trigger: Tự động cộng lại kho khi có dòng bị xóa khỏi ORDER_DETAIL
CREATE OR ALTER TRIGGER trg_Delete_OrderDetail
ON ORDER_DETAIL
AFTER DELETE
AS
BEGIN
    UPDATE b
    SET b.quantity = b.quantity + d.quantity
    FROM BOOK b
    INNER JOIN deleted d ON b.book_id = d.book_id;
END;
GO

-- Procedure: Hủy đơn hàng
CREATE OR ALTER PROCEDURE sp_CancelOrder
    @order_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            DELETE FROM ORDER_DETAIL WHERE order_id = @order_id;
            DELETE FROM ORDERS WHERE order_id = @order_id;
        COMMIT TRANSACTION;
        PRINT N'Đã hủy đơn hàng ' + CAST(@order_id AS VARCHAR) + N' thành công.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
drop procedure sp_CancelOrder

-- =========================================================================
-- BƯỚC 1: DỌN DẸP DỮ LIỆU CŨ (Để tránh lỗi Violation of PRIMARY KEY)
-- =========================================================================
DELETE FROM ORDER_DETAIL WHERE order_id = 15;
DELETE FROM ORDERS WHERE order_id = 15;
GO

-- =========================================================================
-- BƯỚC 2: CHUẨN BỊ DỮ LIỆU MỚI ĐỂ TEST
-- (Giả sử khách mua 10 cuốn Inferno - ID 18)
-- =========================================================================
INSERT INTO ORDERS (order_id, customer_id, order_date) 
VALUES (15, 15, GETDATE());

INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price) 
VALUES (15, 18, 10, 23.00);
GO

-- =========================================================================
-- BƯỚC 3: KIỂM TRẠNG THÁI TRƯỚC KHI HỦY
-- =========================================================================
PRINT '--- TRẠNG THÁI TRƯỚC KHI HỦY ---';
SELECT book_id, title, quantity AS Stock_Before 
FROM BOOK 
WHERE book_id = 18;

-- =========================================================================
-- BƯỚC 4: THỰC THI PROCEDURE HỦY ĐƠN
-- =========================================================================
EXEC sp_CancelOrder @order_id = 15;

-- =========================================================================
-- BƯỚC 5: KIỂM TRẠNG THÁI SAU KHI HỦY (PHẢI TĂNG THÊM 10)
-- =========================================================================
PRINT '--- TRẠNG THÁI SAU KHI HỦY ---';
SELECT book_id, title, quantity AS Stock_After 
FROM BOOK
WHERE book_id = 18;

select 
from [dbo].[BOOK]


PRINT '========= BÁO CÁO KIỂM TRA HỆ THỐNG SAU KHI HỦY ĐƠN =========';

-- 1. Kiểm tra tồn kho của cuốn sách vừa thao tác (ID 18)
SELECT 
    book_id AS [Mã Sách], 
    title AS [Tên Sách], 
    quantity AS [Số Lượng Tồn Hiện Tại]
FROM BOOK 
WHERE book_id = 18;

-- 2. Kiểm tra xem đơn hàng 15 còn tồn tại trong hệ thống không
-- Nếu kết quả trả về là 0, nghĩa là đã xóa sạch thành công.
SELECT 
    COUNT(*) AS [Số lượng đơn hàng 15 còn lại],
    CASE 
        WHEN COUNT(*) = 0 THEN N'Đã xóa sạch khỏi database' 
        ELSE N'Vẫn còn tồn tại' 
    END AS [Trạng thái]
FROM ORDERS 
WHERE order_id = 15;

-- 3. Liệt kê Top 5 đơn hàng mới nhất còn lại trong máy để đối chiếu
SELECT TOP 5 
    o.order_id, 
    o.order_date
FROM ORDERS o
JOIN CUSTOMER c ON o.customer_id = c.customer_id
ORDER BY o.order_id DESC;