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
 
