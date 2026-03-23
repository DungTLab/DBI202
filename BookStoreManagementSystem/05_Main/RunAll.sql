/* =========================================================================
   RUN ALL SCRIPT - BOOK STORE MANAGEMENT SYSTEM
   ========================================================================= */

/* =========================================================================
   1. DATABASE INITIALIZATION
   Purpose: Safely drop the existing database (disconnecting active users) 
            and create a fresh instance.
   ========================================================================= */

USE [master];
GO

-- Check if the database already exists
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'BookStoreManagementSystem')
BEGIN
    -- Force disconnect all active connections by taking offline with rollback, then bring online to drop
    ALTER DATABASE BookStoreManagementSystem SET OFFLINE WITH ROLLBACK IMMEDIATE;
    ALTER DATABASE BookStoreManagementSystem SET ONLINE;
    DROP DATABASE BookStoreManagementSystem;
END
GO

-- Create the new database for the Book Store Management System
CREATE DATABASE BookStoreManagementSystem;
GO

-- Select the database to use for subsequent operations
USE [BookStoreManagementSystem];
GO

/* =========================================================================
   2. PHASE 1: INDEPENDENT TABLES (No Foreign Keys)
   ========================================================================= */

/* 1. Nguyễn Phú Trọng - Table: CUSTOMER */
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

/* 2. Nguyễn Trần Đức Anh - Table: BOOK */
CREATE TABLE BOOK (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price > 0),
    public_year INT CHECK (public_year <= YEAR(GETDATE())),
    quantity INT CHECK (quantity >= 0)
);

/* 3. Lê Tiến Dũng - Table: AUTHOR */
CREATE TABLE AUTHOR (
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50)
);
GO

/* =========================================================================
   3. PHASE 2: DEPENDENT TABLES LEVEL 1 (References Independent Tables)
   ========================================================================= */

/* 4. Huỳnh Nhật Duy - Table: ORDERS */
CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
);

/* 5. Lê Tiến Dũng - Table: BOOK_AUTHOR */
CREATE TABLE BOOK_AUTHOR (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id),
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id)
);
GO

/* =========================================================================
   4. PHASE 3: DEPENDENT TABLES LEVEL 2 (References Level 1 Tables)
   ========================================================================= */

/* 6. Trần Huỳnh Giác - Table: ORDER_DETAIL */
CREATE TABLE ORDER_DETAIL (
    order_id INT,
    book_id INT,
    quantity INT CHECK (quantity > 0),
    price DECIMAL(10, 2) CHECK (price > 0),
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id)
);
GO

/* =========================================================================
   5. DATA INSERTION (DML - Mock Data)
   ========================================================================= */

-- Insert mock data into the AUTHOR table
INSERT INTO AUTHOR VALUES
    (1, 'Nguyen Nhat Anh', 'Vietnam'),
    (2, 'To Hoai', 'Vietnam'),
    (3, 'J.K. Rowling', 'UK'),
    (4, 'George Orwell', 'UK'),
    (5, 'Haruki Murakami', 'Japan'),
    (6, 'Paulo Coelho', 'Brazil'),
    (7, 'Dan Brown', 'USA'),
    (8, 'Stephen King', 'USA'),
    (9, 'Ernest Hemingway', 'USA'),
    (10, 'Mark Twain', 'USA'),
    (11, 'Leo Tolstoy', 'Russia'),
    (12, 'Jane Austen', 'UK'),
    (13, 'F. Scott Fitzgerald', 'USA'),
    (14, 'Agatha Christie', 'UK'),
    (15, 'Victor Hugo', 'France');

-- Insert mock data into the BOOK table
INSERT INTO BOOK VALUES
    (1, 'Mat Biec', 15.50, 2019, 100),
    (2, 'De Men Phieu Luu Ky', 12.00, 2018, 80),
    (3, 'Harry Potter 1', 25.00, 2001, 150),
    (4, '1984', 18.00, 1949, 120),
    (5, 'Kafka on the Shore', 20.00, 2005, 90),
    (6, 'The Alchemist', 16.50, 1993, 110),
    (7, 'Da Vinci Code', 22.00, 2003, 95),
    (8, 'The Shining', 19.00, 1977, 70),
    (9, 'The Old Man and the Sea', 14.00, 1952, 85),
    (10, 'Tom Sawyer', 13.50, 1876, 60),
    (11, 'War and Peace', 30.00, 1869, 40),
    (12, 'Pride and Prejudice', 17.00, 1813, 75),
    (13, 'The Great Gatsby', 15.00, 1925, 100),
    (14, 'Murder on the Orient Express', 21.00, 1934, 65),
    (15, 'Les Miserables', 28.00, 1862, 50),
    (16, 'Harry Potter 2', 26.00, 2002, 140),
    (17, 'Animal Farm', 15.00, 1945, 130),
    (18, 'Inferno', 23.00, 2013, 90),
    (19, 'IT', 24.00, 1986, 55),
    (20, 'Norwegian Wood', 18.50, 1987, 88);

-- Insert mock data into the BOOK_AUTHOR junction table
INSERT INTO BOOK_AUTHOR VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (16, 3),
    (4, 4),
    (17, 4),
    (5, 5),
    (20, 5),
    (6, 6),
    (7, 7),
    (18, 7),
    (8, 8),
    (19, 8),
    (9, 9),
    (10, 10),
    (11, 11),
    (12, 12),
    (13, 13),
    (14, 14),
    (15, 15);

-- Insert mock data into the CUSTOMER table
INSERT INTO CUSTOMER VALUES
    (1, 'Tran Van A', '0900000001', 'a@gmail.com'),
    (2, 'Le Thi B', '0900000002', 'b@gmail.com'),
    (3, 'Pham Van C', '0900000003', 'c@gmail.com'),
    (4, 'Nguyen Thi D', '0900000004', 'd@gmail.com'),
    (5, 'Hoang Van E', '0900000005', 'e@gmail.com'),
    (6, 'Vo Thi F', '0900000006', 'f@gmail.com'),
    (7, 'Dang Van G', '0900000007', 'g@gmail.com'),
    (8, 'Bui Thi H', '0900000008', 'h@gmail.com'),
    (9, 'Do Van I', '0900000009', 'i@gmail.com'),
    (10, 'Ly Thi K', '0900000010', 'k@gmail.com'),
    (11, 'Ngo Van L', '0900000011', 'l@gmail.com'),
    (12, 'Mai Thi M', '0900000012', 'm@gmail.com'),
    (13, 'Pham Van N', '0900000013', 'n@gmail.com'),
    (14, 'Tran Thi O', '0900000014', 'o@gmail.com'),
    (15, 'Le Van P', '0900000015', 'p@gmail.com');

-- Insert mock data into the ORDERS table
INSERT INTO ORDERS VALUES
    (1, 1, '2024-01-10'),
    (2, 2, '2024-01-12'),
    (3, 3, '2024-01-15'),
    (4, 4, '2024-02-01'),
    (5, 5, '2024-02-10'),
    (6, 6, '2024-02-18'),
    (7, 7, '2024-03-01'),
    (8, 8, '2024-03-05'),
    (9, 9, '2024-03-10'),
    (10, 10, '2024-03-15'),
    (11, 11, '2024-04-01'),
    (12, 12, '2024-04-05'),
    (13, 13, '2024-04-10'),
    (14, 14, '2024-04-15'),
    (15, 15, '2024-05-01');

-- Insert mock data into the ORDER_DETAIL table
INSERT INTO ORDER_DETAIL VALUES
    (1, 3, 2, 25.00),
    (1, 4, 1, 18.00),
    (2, 6, 1, 16.50),
    (2, 7, 2, 22.00),
    (3, 1, 3, 15.50),
    (4, 8, 1, 19.00),
    (5, 5, 2, 20.00),
    (6, 9, 1, 14.00),
    (7, 10, 1, 13.50),
    (8, 11, 1, 30.00),
    (9, 12, 2, 17.00),
    (10, 13, 1, 15.00),
    (11, 14, 1, 21.00),
    (12, 15, 1, 28.00),
    (13, 16, 2, 26.00),
    (14, 17, 3, 15.00),
    (15, 18, 1, 23.00),
    (15, 19, 1, 24.00),
    (10, 20, 2, 18.50),
    (5, 2, 1, 12.00);
GO

/* =========================================================================
   6. STORED PROCEDURES
   ========================================================================= */

/* =============================================================================
AUTHOR: Tran Huynh Giac (CE200291)
ROLE: ORDER_DETAIL
============================================================================= */

/* -----------------------------------------------------------------------------
Procedure: sp_AddBookToOrder
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_AddBookToOrder
    @order_id INT,
    @book_id INT,
    @quantity INT,
    @price DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO ORDER_DETAIL (order_id, book_id, quantity, price)
        VALUES (@order_id, @book_id, @quantity, @price);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

/* -----------------------------------------------------------------------------
Procedure: sp_UpdateOrderDetailQuantity
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_UpdateOrderDetailQuantity
    @order_id INT,
    @book_id INT,
    @new_quantity INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE ORDER_DETAIL
        SET quantity = @new_quantity
        WHERE order_id = @order_id AND book_id = @book_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

/* -----------------------------------------------------------------------------
Procedure: sp_RemoveBookFromOrder
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_RemoveBookFromOrder
    @order_id INT,
    @book_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM ORDER_DETAIL
        WHERE order_id = @order_id AND book_id = @book_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

/* =============================================================================
AUTHOR: Huynh Nhat Duy (CE201224)
ROLE: Supporter, ORDER
============================================================================= */

/* -----------------------------------------------------------------------------
Procedure: sp_CancelOrder
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_CancelOrder
    @order_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM ORDER_DETAIL WHERE order_id = @order_id;
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

/* =============================================================================
AUTHOR: Nguyen Phu Trong (CE200340)
ROLE: Supporter, CUSTOMER
============================================================================= */

/* -----------------------------------------------------------------------------
Procedure: sp_CreateCustomerAndOrder
----------------------------------------------------------------------------- */
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

        INSERT INTO CUSTOMER (customer_id, name, phone, email)
        VALUES (@customer_id, @name, @phone, @email);

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
GO

/* =============================================================================
AUTHOR: Nguyen Tran Duc Anh (CE20031)
ROLE: Team Leader, BOOK
============================================================================= */

/* -----------------------------------------------------------------------------
Procedure: sp_BulkUpdateBookPrice
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_BulkUpdateBookPrice
    @percentage_change DECIMAL(5,2),
    @book_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE BOOK
        SET price = price * (1 + @percentage_change / 100)
        WHERE book_id = @book_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

/* =============================================================================
AUTHOR: Le Tien Dung (CE201046)
ROLE: Project Manager, AUTHOR
============================================================================= */

/* -----------------------------------------------------------------------------
Procedure: sp_DeleteAuthor
----------------------------------------------------------------------------- */
CREATE PROCEDURE sp_DeleteAuthor
    @author_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (
            SELECT 1
            FROM BOOK_AUTHOR ba
            JOIN ORDER_DETAIL od ON ba.book_id = od.book_id
            WHERE ba.author_id = @author_id
        )
        BEGIN
            RAISERROR ('Cannot delete author. Associated books exist in order history.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM BOOK_AUTHOR WHERE author_id = @author_id;
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

/* =========================================================================
   7. TRIGGERS
   ========================================================================= */

/* =========================================================================
   Author: Duc Anh
   Trigger: trg_Prevent_Delete_Book
   ========================================================================= */
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
        RAISERROR ('Cannot delete a book that has already been sold.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DELETE FROM BOOK
    WHERE book_id IN (SELECT book_id FROM deleted);
END;
GO

/* =========================================================================
   Author: Nguyen Phu Trong
   Trigger: trg_Prevent_Delete_Customer
   ========================================================================= */
CREATE TRIGGER trg_Prevent_Delete_Customer
ON CUSTOMER
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN ORDERS o ON d.customer_id = o.customer_id
    )
    BEGIN
        RAISERROR ('Cannot delete customer with existing orders.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    DELETE FROM CUSTOMER
    WHERE customer_id IN (SELECT customer_id FROM deleted);
END;
GO

/* =========================================================================
   Author: Huynh Nhat Duy
   Trigger: trg_Insert_OrderDetail
   ========================================================================= */
CREATE TRIGGER trg_Insert_OrderDetail
ON ORDER_DETAIL
AFTER INSERT
AS
BEGIN
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

    UPDATE b
    SET b.quantity = b.quantity - i.quantity
    FROM BOOK b
    JOIN inserted i ON b.book_id = i.book_id;
END;
GO

/* =========================================================================
   Author: Tran Huynh Giac
   Trigger: trg_Delete_OrderDetail
   ========================================================================= */
CREATE TRIGGER trg_Delete_OrderDetail
ON ORDER_DETAIL
AFTER DELETE
AS
BEGIN
    UPDATE b
    SET b.quantity = b.quantity + d.quantity
    FROM BOOK b
    JOIN deleted d ON b.book_id = d.book_id;
END;
GO

/* =========================================================================
   Author: Tran Huynh Giac
   Trigger: trg_Update_OrderDetail
   ========================================================================= */
CREATE TRIGGER trg_Update_OrderDetail
ON ORDER_DETAIL
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON i.order_id = d.order_id
        WHERE i.book_id <> d.book_id
    )
    BEGIN
        RAISERROR ('Cannot change book_id in an existing order detail.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    UPDATE b
    SET b.quantity = b.quantity + d.quantity - i.quantity
    FROM BOOK b
    JOIN inserted i ON b.book_id = i.book_id
    JOIN deleted d ON i.order_id = d.order_id AND i.book_id = d.book_id;

    IF EXISTS (
        SELECT 1
        FROM BOOK
        WHERE quantity < 0
    )
    BEGIN
        RAISERROR ('Stock cannot be negative after update.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO