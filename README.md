# 📚 Book Store Management System (DBI202)

Welcome to the official repository for the **Book Store Management System** database project. This project is part of the **Introduction to Database (DBI202)** course at FPT University. 

This project aims to design and implement a robust relational database to handle core bookstore operations, including inventory management, customer tracking, and order processing.

---

## 👥 Team Members (Group 1)

* **Nguyễn Trần Đức Anh (CE200031)** - Team Leader (Role: `BOOK` table)
* **Lê Tiến Dũng (CE201046)** - Project Manager (Role: `AUTHOR` table)
* **Trần Huỳnh Giác (CE200291)** - Supporter (Role: `ORDER_DETAIL` table)
* **Huỳnh Nhật Duy (CE201224)** - Supporter (Role: `ORDERS` table)
* **Nguyễn Phú Trọng (CE200340)** - Supporter (Role: `CUSTOMER` table)

---

## 🛠 Technology Stack

* **Database Engine:** SQL Server
* **Language:** T-SQL
* **Tools:** SQL Server Management Studio (SSMS) / Azure Data Studio
* **Diagramming:** Draw.io / StarUML

---

## 🗂 Project Structure

The repository is organized into sequential phases for easy deployment and evaluation:

* **`00_Docs/`**: Contains project requirements, the final report, and conceptual/physical database diagrams (ERD, UML).
* **`01_Schema/`**: DDL scripts to initialize the database and create all relational tables.
* **`02_Data/`**: DML scripts containing mock data to populate the database for testing.
* **`03_Queries/`**: A collection of basic, multi-table join, and advanced aggregate/sub-queries demonstrating database capabilities.
* **`04_Programmability/`**: Contains advanced T-SQL logic, including Stored Procedures and automated Triggers for data integrity and inventory calculation.
* **`05_Main/`**: Contains the consolidated `RunAll.sql` script for one-click deployment.

---

## 📊 Database Schema

The system is normalized up to the Third Normal Form (3NF) and consists of the following entities:
* **`CUSTOMER`**: Stores customer profiles and contact details.
* **`BOOK`**: Manages book inventory, pricing, and publication details.
* **`AUTHOR`**: Stores author information.
* **`BOOK_AUTHOR`**: Junction table resolving the Many-to-Many relationship between Books and Authors.
* **`ORDERS`**: Tracks general order information and dates.
* **`ORDER_DETAIL`**: Line items for orders, tracking specific books, purchased quantities, and historical prices.

---

## 📥 Getting Started (Fork & Clone)

To get a local copy of this project up and running, follow these steps using your terminal:

1. **Fork the Repository**: Click the **Fork** button at the top right corner of this repository's GitHub page to create a copy in your own GitHub account.
2. **Clone the Repository**:
   Open your terminal and run the following command:
   ```bash
   git clone https://github.com/DungTLab/DBI202.git
Navigate to the Project Directory:
Once the cloning process is complete, navigate into the project folder:

Bash
cd DBI202
🚀 How to Run the Project
You can deploy the database using either the Quick Setup or the Step-by-Step Setup.

Option 1: Quick Setup (Recommended)
The easiest way to set up the entire database, tables, mock data, and programmability objects is to run the consolidated script.

Open SQL Server Management Studio (SSMS) or Azure Data Studio.

Open the file 05_Main/RunAll.sql.

Execute the script.
(Note: This script will safely drop any existing database named BookStoreManagementSystem before creating a fresh instance).

Option 2: Step-by-Step Setup
If you want to evaluate the project phase-by-phase, execute the scripts in the following strict order to avoid dependency errors:

01_Schema/01_CreateDatabase.sql

01_Schema/02_CreateTables.sql

02_Data/01_InsertData.sql

04_Programmability/01_StoredProcedures.sql

04_Programmability/02_Triggers.sql

✨ Key Features
Automated Inventory Management: Triggers automatically deduct book stock upon new orders and restore stock if an order is canceled or updated.

Strict Data Integrity: Prevents the deletion of books or customers that are tied to existing order histories.

Transactional Safety: Stored procedures use TRY...CATCH blocks and TRANSACTION management to ensure complex operations (like canceling an entire order) are processed safely.