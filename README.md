
# BikeStores Sales Analysis using SQL

## Overview

This project provides a comprehensive, end-to-end analysis of the BikeStores sample database using only SQL. It is designed to answer critical business questions by querying the data directly, demonstrating a strong command of T-SQL for data exploration and reporting.

The repository contains all the necessary scripts to create the database schema, load the data, and run a full suite of analytical queries, making the entire project fully reproducible.

---

## Key Business Questions Addressed

The core of this project is a series of SQL queries designed to answer key business questions, including:

-   What is the sales revenue per store?
-   Which product categories are the most and least popular?
-   Which brands generate the most sales?
-   Who are the top customers and what are their order histories?
-   Which staff members are processing the most orders?
-   What is the inventory status of top-selling products?
-   Which geographical regions (states) are performing the best in terms of sales?

---

## Technical Workflow & Project Structure

This project uses a set of SQL scripts to manage and analyze the database:

-   `BikeStores Sample Database - create objects.sql`: Contains the Data Definition Language (DDL) statements (`CREATE TABLE`, etc.) to build the entire database schema from scratch.
-   `BikeStores Sample Database - load data.sql`: Contains the `INSERT` statements to populate all the tables with the sample data.
-   `final_project.sql`: The main analysis script. It contains over 20 well-commented SQL queries that perform data exploration and answer the business questions listed above.
-   `BikeStores Sample Database - drop all objects.sql`: A utility script to cleanly remove all database objects created by this project.

---

## Tools and Technologies

-   **Database:** Microsoft SQL Server
-   **Language:** T-SQL (Transact-SQL)
-   **Development Environment:** SQL Server Management Studio (SSMS) or Azure Data Studio

---


## Sample Analysis Query

Here is an example query from `final_project.sql` that calculates the total sales revenue per store:

```sql
-- What’s the sales/revenue per store?
SELECT 
    Store_id, 
    SUM(list_price * quantity * (1 - discount)) AS 'Sales'
FROM 
    sales.order_items
JOIN 
    sales.orders ON sales.order_items.order_id = sales.orders.order_id
GROUP BY 
    Store_id;
```

---
