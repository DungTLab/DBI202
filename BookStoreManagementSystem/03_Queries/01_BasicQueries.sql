/* Basic Queries for Customer Table */

/*show all customers */
SELECT * 
FROM CUSTOMER;

/* show customers with email is null */
SELECT *
FROM CUSTOMER
WHERE email IS NULL;

/*show number of customers */
SELECT COUNT(*) AS total_customers
FROM CUSTOMER;