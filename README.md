# DBMS BASH PROJECT

A Database Management System built entirely with **Bash scripting**. 

This CLI-based project simulates the core functionality of a DBMS, allowing you to execute basic SQL-like queries and manage databases and tables — all through shell scripting and the Linux file system.

---

## Demo Video

Check out a quick demonstration of DBMS-Bash in action! This video will walk you through the core functionalities and show you how to interact with your databases and tables using the command line.


https://github.com/user-attachments/assets/87617869-ca9f-41de-a270-bf58bab7cbb3


---

## How to Use

```bash
# 1. Clone the repository
git clone https://github.com/Naira98/DBMS-Bash.git

# 2. Navigate into the project directory (optional if running directly)
cd DBMS-Bash

# 3. Run the program
source ./main.sh
```
---

## Features:

###  Database Operations
- Create database  
- List all databases  
- Connect to a database  
- Drop a database  

### Table Operations
- Create tables 
- List all tables
- Drop a table  
- Alter table structure:  
  - Rename table  
  - Rename column  
  - Add column  
  - Drop column  
  - Add or drop constraints (e.g., `UNIQUE`, `NOT NULL`, `AUTO-INCREMENT PK`, `DEFAULT VALUE` )  

### Query Operations
- `SELECT` display data in a well-formatted dynamic table
- `INSERT` new records into tables  
- `UPDATE` existing records  
- `DELETE` records based on conditions 


---

## How DBMS-Bash Uses the File System

It directly uses the **Linux file system as its database storage mechanism**. Here's a more detailed breakdown:

* **Databases as Directories:** Each database created in DBMS-Bash is represented as a dedicated **directory**. These database directories are stored within a specific data directory located in the **root directory of your DBMS-Bash project**.

* **Tables as Files:** Inside each database directory, tables are managed using **two distinct files**:
    * **Data File (`<table_name>`):** This file stores the actual records for your table.
    * **Metadata File (`.<table_name>`):** This hidden file stores the table's schema, including column names, data types, and any constraints.

* **Data Storage:** Records within tables are stored in a structured text format (custom delimited format) that Bash scripts can easily read from and write to.

This ingenious approach allows you to simulate a DBMS without needing a traditional database server, relying entirely on shell commands for data manipulation and the robust Linux file system for persistence.

---

## Authors

- [Naira Mokhtar](https://github.com/Naira98)   ( [Portfolio Website](https://naira-portfolio.vercel.app/) )

- [Mohamed Abdrabou](https://github.com/MohamedAbdrabou12)
