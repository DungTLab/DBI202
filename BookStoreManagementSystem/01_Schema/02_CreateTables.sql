CREATE TABLE
    AUTHOR (
        author_id INT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        nationality VARCHAR(50)
    );

CREATE TABLE
    BOOK (
        book_id INT PRIMARY KEY,
        title VARCHAR(100) NOT NULL,
        price DECIMAL(10, 2) CHECK (price > 0),
        public_year INT CHECK (public_year <= YEAR (GETDATE ())),
        quantity INT CHECK (quantity >= 0)
    );

CREATE TABLE
    BOOK_AUTHOR (
        book_id INT,
        author_id INT,
        PRIMARY KEY (book_id, author_id),
        FOREIGN KEY (book_id) REFERENCES BOOK (book_id),
        FOREIGN KEY (author_id) REFERENCES AUTHOR (author_id)
    );

CREATE TABLE
    CUSTOMER (
        customer_id INT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        phone VARCHAR(15),
        email VARCHAR(100) UNIQUE
    );

CREATE TABLE
    ORDERS (
        order_id INT PRIMARY KEY,
        customer_id INT,
        order_date DATE NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES CUSTOMER (customer_id)
    );

CREATE TABLE
    ORDER_DETAIL (
        order_id INT,
        book_id INT,
        quantity INT CHECK (quantity > 0),
        price DECIMAL(10, 2) CHECK (price > 0),
        PRIMARY KEY (order_id, book_id),
        FOREIGN KEY (order_id) REFERENCES ORDERS (order_id),
        FOREIGN KEY (book_id) REFERENCES BOOK (book_id)
    );