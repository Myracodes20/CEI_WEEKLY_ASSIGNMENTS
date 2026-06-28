# CEI_WEEKLY_ASSIGNMENTS

## Week 1: Data Exploration and Cleaning using Pandas

This assignment focused on learning the fundamentals of data analysis and preprocessing using Python and the Pandas library. The e-commerce dataset was loaded into a Pandas DataFrame and explored using various inspection techniques to understand its structure, dimensions, column information, and data types. Missing values were identified and handled appropriately to improve data quality, and the dataset was examined for duplicate records to ensure consistency.

Basic data manipulation operations such as filtering rows and selecting relevant columns were performed as part of the exploration process. A derived feature, `total_amount`, was created using the product of price and quantity to demonstrate feature engineering. Additional transformations were applied to generate useful analytical features and improve the overall usability of the dataset.

After completing the cleaning and preprocessing steps, the dataset was validated to confirm the absence of missing values and duplicate records. The final cleaned dataset was then exported as a new CSV file for further analysis. The deliverables for this assignment include the Jupyter Notebook containing the complete workflow and the cleaned dataset generated through the preprocessing process.


## Week 2: SQL Fundamentals & E-Commerce Database Analysis

This assignment focused on developing SQL proficiency by working with a relational database for an e-commerce platform called ShopEase. The goal was to extract meaningful business insights through structured querying across multiple tables.

### Database Setup & Schema Design

A complete relational database was designed and implemented with four interconnected tables:
- **customers** – Stores customer demographics and premium membership status
- **products** – Contains product catalog with categories, brands, pricing, and inventory levels
- **orders** – Tracks order transactions with status tracking and total amounts
- **order_items** – Records line-level order details including quantities, pricing, and discounts

The schema implements proper relationships using primary and foreign keys, along with constraints (CHECK, NOT NULL, UNIQUE, DEFAULT) to ensure data integrity. Indexes were strategically created on frequently filtered columns (city, state, category, order_date, status) to optimize query performance.

### Skills & Concepts Covered

**Section A – SQL Basics:**
- Data retrieval using SELECT statements with column filtering
- Understanding primary keys and their importance for row uniqueness
- Database constraints and their role in maintaining data quality

**Section B – Filtering & Optimization:**
- Conditional filtering using WHERE clause with multiple conditions (AND, OR, BETWEEN)
- Understanding SARGable queries and why functions on columns prevent index usage
- Practical demonstration that indexes benefit large datasets but add overhead on small tables

**Section C – Aggregation:**
- Grouping data with GROUP BY to calculate category-level metrics
- Aggregate functions: COUNT, SUM, AVG, MIN, MAX
- Filtering grouped results using HAVING clause

**Section D – Joins & Relationships:**
- INNER JOIN to combine orders with customer information
- LEFT JOIN to identify customers with no orders
- Three-table JOIN across orders → order_items → products
- Understanding foreign key constraints and referential integrity

**Section E – Advanced Concepts:**
- CASE statements for conditional logic and price tier classification
- Conditional aggregation using CASE inside aggregate functions
- ACID properties (Atomicity, Consistency, Isolation, Durability) with real-world examples
- Transaction management with START TRANSACTION, COMMIT, and ROLLBACK

 ### Tools Used

- MySQL Server 8.0
- MySQL Shell / VS Code with MySQL extension
 
## Week 3: Advanced SQL - Subqueries, CTEs & Window Functions

### Overview

This week focused on mastering advanced SQL techniques to perform sophisticated data analysis on the Superstore sales dataset. The goal was to go beyond basic queries and leverage subqueries, Common Table Expressions (CTEs), and Window Functions to extract deeper business insights from the data.

### Data Setup & Normalization

The Superstore dataset (9,994 records) was imported into PostgreSQL using a carefully designed two-step process. We first created a staging table with TEXT columns to handle data type conversion issues, then used `\COPY` to import the CSV file, and finally converted the data to proper types using `TO_DATE()` for date conversion and `CAST()` for numeric fields. This approach was chosen to handle the date format mismatch (MM/DD/YYYY vs YYYY-MM-DD) and to manage NULL values gracefully. The raw data was then normalized into five tables: `superstore_raw` (preserving original data), `customers` (unique customers for analytics), `customer_addresses` (preserving all address variations to avoid data loss), `products` (unique products), and `orders` (all transactions with foreign key constraints). Duplicate rows were identified and removed using `SELECT DISTINCT`, and data quality was verified through row count and sales total comparisons.

### Key Challenges & Solutions

Several challenges were encountered during the import process. The date format mismatch was resolved by using `TO_DATE(order_date, 'MM/DD/YYYY')` during the conversion step. Permission errors with `COPY` were addressed by using `\COPY` instead, which reads from the client-side file system. Duplicate customer IDs with different addresses required creating a separate `customer_addresses` table to preserve all variations while keeping the `customers` table clean for analytics. Similarly, duplicate product IDs were handled using `DISTINCT ON (product_id)` to keep one record per product. A single duplicate order row was identified and removed, resulting in 9,993 orders from 9,994 raw rows. Foreign key constraints were added to maintain referential integrity, and indexes were created on frequently queried columns for performance optimization.

### Subqueries

Subqueries were used to perform comparisons and filtering based on aggregate calculations. A simple subquery in the WHERE clause was used to find all orders with sales greater than the average sales. A correlated subquery was used to find the highest sales order for each customer, where the inner query references the outer query's `customer_id`. This approach works well for simple comparisons but can be slower on large datasets since correlated subqueries execute row by row.

### Common Table Expressions (CTEs)

CTEs were used to create temporary named result sets that improve query readability and allow reuse within the same query. We used CTEs to calculate total sales per customer and then filter for customers above average using a subquery. CTEs are particularly useful for breaking down complex queries into logical steps, making them easier to understand and maintain. They can also be referenced multiple times within the same query, reducing redundancy.

### Window Functions

Window functions were used to perform calculations across rows without collapsing them into groups. `RANK()` was used to rank customers by total sales, handling ties appropriately. `ROW_NUMBER()` with `PARTITION BY` was used to assign sequential numbers to orders within each customer based on order date. This is useful for identifying purchase patterns and order sequences. Unlike `GROUP BY`, window functions preserve all rows while adding calculated columns, making them powerful for analytical queries.

### Combined Queries

The final combined query demonstrates the integration of all three techniques: a CTE calculates customer sales using a JOIN, and a Window Function adds the rank. This showcases how these techniques complement each other to produce comprehensive analytical results.

### Edge Cases Considered

Several edge cases were addressed to ensure accurate analysis. Ties in ranking were handled using `RANK()` to show equal ranks properly. Customers with no orders were excluded from bottom 5 analysis to avoid skewing results. Negative profit orders were tracked separately to identify loss-making customers. Duplicate orders were identified using `row_id` uniqueness. NULL dates were handled using `COALESCE` and `CASE` statements. Outliers were considered when calculating averages, with median used as a more robust alternative when needed.

### Business Insights

Five key business questions were answered: top 5 customers by total sales, bottom 5 customers, customers who made only one order, customers with above-average sales, and highest order value per customer. These insights help identify high-value customers, one-time buyers, and customer spending patterns for targeted marketing and retention strategies.

### Key Takeaways

Subqueries work well for simple comparisons and single-value returns. CTEs greatly improve query readability and allow multiple references. Window Functions provide powerful ranking and grouping capabilities without collapsing rows. Combining these techniques (JOIN + CTE + Window Function) creates robust analytical queries. Always verify data quality through row counts and sales totals before analysis. Normalize data to reduce redundancy but preserve original data for audit purposes.

### Tools Used

PostgreSQL, pgAdmin 4 / VS Code with PostgreSQL extension, Superstore dataset (9,994 records).

## Week 4: Azure Cloud Fundamentals & Data Pipeline Implementation using ADF

### Task 1: Azure Portal & Resource Group

This task focused on exploring the Azure Portal and understanding fundamental cloud concepts. A Resource Group was created to serve as a logical container for organizing and managing all related Azure resources. Resource Groups enable simplified management, access control, and cleanup of multiple services as a single unit, similar to a project folder that groups all related files together.

### Task 2: Storage Setup

A Storage Account was created to provide scalable cloud storage for the data pipeline, configured with Standard performance and Locally Redundant Storage (LRS). A Blob Container was created within the Storage Account to organize the CSV files, and a sample CSV file containing employee data (EmployeeID, FirstName, LastName, Department, Salary) was uploaded. Access keys and connection strings were retrieved to enable secure connections from other Azure services.

### Task 3: ADF Basics

Azure Data Factory was created as a fully managed ETL and data integration service. The ADF interface was explored through three main tabs: Author (for designing pipelines), Monitor (for tracking execution), and Manage (for configuring connections). A Linked Service was established to securely connect ADF to the Storage Account using the connection string, making the connection reusable across multiple pipelines. Two datasets were created – a source dataset pointing to the uploaded CSV file and a destination dataset for the processed output. A Get Metadata activity was added to validate file existence and capture file properties such as name, size, and last modified date.

### Task 4: Pipeline Development

A pipeline was built to orchestrate the data movement process. The Copy Data activity was added as the primary workhorse for transferring data from source to destination. The source dataset was configured to read from the uploaded CSV file, and the destination dataset was configured to write to a new output file. Column mapping was imported to ensure proper data structure preservation. The Get Metadata and Copy Data activities were connected with a dependency, ensuring that the copy operation runs only after successful validation.

### Task 5: Pipeline Execution

The pipeline was tested using Debug mode for development validation. After successful debugging, the pipeline was triggered for production execution using the "Trigger now" option. The Monitor tab was used to track the execution status, confirming both activities (Get Metadata and Copy Data) with "Succeeded" status, verifying that the pipeline successfully read the CSV file from the source and wrote it to the destination location.

### Task 6: IAM Roles

Identity and Access Management roles were assigned to enable secure communication between Azure Data Factory and the Storage Account. The Reader role was assigned to allow ADF to view and read data from the Storage Account, while the Contributor role was assigned to enable writing data to the destination. The roles were assigned using Managed Identity, where Azure creates a service account identity for ADF, eliminating the need to store credentials in the pipeline code and following the principle of least privilege.

### Mini Project (Final Task)

A complete pipeline was built that reads a CSV file from Blob Storage and processes it using Azure Data Factory. The pipeline successfully copied data from the source to a new destination location with metadata validation. The Copy Data activity transferred the CSV content while the Get Metadata activity validated file properties. The pipeline executed successfully with data copied to the destination and metadata validated, demonstrating the complete end-to-end data flow from source to destination.

