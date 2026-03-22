/* =========================================================================
   TABLE CREATION (DDL)
   ========================================================================= */

-- Create the AUTHOR table to store author details
CREATE TABLE AUTHOR (
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50)
);

-- Create the BOOK table to store book inventory and pricing
CREATE TABLE BOOK (
    book_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price > 0),
    public_year INT CHECK (public_year <= YEAR(GETDATE())),
    quantity INT CHECK (quantity >= 0)
);

-- Create the BOOK_AUTHOR junction table for the many-to-many relationship
CREATE TABLE BOOK_AUTHOR (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id),
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id)
);

-- Create the CUSTOMER table to store client contact information
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

-- Create the ORDERS table to track customer purchases
CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
);

-- Create the ORDER_DETAIL table to map specific books and quantities to an order
CREATE TABLE ORDER_DETAIL (
    order_id INT,
    book_id INT,
    quantity INT CHECK (quantity > 0),
    price DECIMAL(10, 2) CHECK (price > 0),
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (book_id) REFERENCES BOOK(book_id)
);