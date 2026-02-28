SELECT a.name, COUNT(ba.book_id) AS total_books
From AUTHOR a
JOIN BOOK_AUTHOR ba ON a.author_id = ba.author_id
GROUP BY a.name
ORDER BY total_books DESC;