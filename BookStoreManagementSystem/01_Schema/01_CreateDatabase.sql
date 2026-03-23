/* =========================================================================
   1. DATABASE INITIALIZATION
   Purpose: Safely drop the existing database (disconnecting active users) 
            and create a fresh instance.
   ========================================================================= */

USE [master];
GO

-- Check if the database already exists
IF EXISTS (SELECT name
FROM master.dbo.sysdatabases
WHERE name = N'BookStoreManagementSystem')
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