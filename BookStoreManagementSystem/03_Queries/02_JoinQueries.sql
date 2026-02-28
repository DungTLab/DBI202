-- Join Queries for Book Store Management System
SELECT b.title, a.name
FROM BOOK b
JOIN BOOK_AUTHOR ba ON b.book_id = ba.book_id
JOIN AUTHOR a ON ba.author_id = a.author_id;
