/* =========================================================================
   PHASE 1: INDEPENDENT TABLES (No Foreign Keys)
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


/* =========================================================================
   PHASE 2: DEPENDENT TABLES LEVEL 1 (References Independent Tables)
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


/* =========================================================================
   PHASE 3: DEPENDENT TABLES LEVEL 2 (References Level 1 Tables)
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