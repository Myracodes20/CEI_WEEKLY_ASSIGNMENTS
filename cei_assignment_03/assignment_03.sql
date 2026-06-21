
--STEP 1: SETUP DATA 
--Import the Superstore dataset into a table named superstore_raw.  
--Create these 3 tables from it:  customers ,orders ,products  AND Insert data into these tables using SELECT DISTINCT. 
DROP TABLE IF EXISTS superstore_raw;

CREATE TABLE superstore_raw (
    row_id INTEGER,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(20),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INTEGER,  
    region VARCHAR(20),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(200),
    sales DECIMAL(10,4), 
    quantity INTEGER,
    discount DECIMAL(5,4),  
    profit DECIMAL(10,4)  
); 

--Set date format to match your CSV (MM/DD/YYYY)
SET DateStyle = 'MDY';

-- IMPORT DATA
\COPY superstore_raw FROM 'C:/Users/mejam/OneDrive/Desktop/cei_assignment_03/archive/Sample - Superstore.csv' DELIMITER ',' CSV HEADER;

--CREATE NORMALISED TABLES
--CUSTOMERS AND customer_addresses
CREATE TABLE customer_addresses AS
SELECT DISTINCT 
    customer_id,
    country,
    city,
    state,
    postal_code,
    region
FROM superstore_raw;
CREATE INDEX idx_customer_addresses_id ON customer_addresses(customer_id);

CREATE TABLE customers AS
SELECT DISTINCT ON (customer_id)
    customer_id,
    customer_name,
    segment
FROM superstore_raw
ORDER BY customer_id;

ALTER TABLE customers ADD PRIMARY KEY (customer_id);

--PRODUCTS
CREATE TABLE products AS
SELECT DISTINCT ON (product_id)
    product_id,
    category,
    sub_category,
    product_name
FROM superstore_raw
ORDER BY product_id;

ALTER TABLE products ADD PRIMARY KEY (product_id);


--ORDERS
CREATE TABLE orders AS
SELECT DISTINCT 
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw;

-- Add foreign keys
ALTER TABLE orders ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE orders ADD FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Add indexes for performance
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_product_id ON orders(product_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);


--STEP 2:EXCEUTE THE FOLLOWING SUBQURIES:
--1. Find all orders where sales are greater than the average sales. (Subquery)  
--query 1:
SELECT order_id,customer_id,sales,
ROUND(AVG(sales) OVER(), 2) as avg_sales
FROM orders
WHERE sales > (SELECT AVG(sales) FROM orders)
ORDER BY sales DESC;

--TOTAL COUNT:
SELECT COUNT(*) as orders_above_avg,
ROUND(AVG(sales)::numeric, 2) as avg_sales,
ROUND(MIN(sales)::numeric, 2) as min_sales_above_avg,
ROUND(MAX(sales)::numeric, 2) as max_sales
FROM orders
WHERE sales > (SELECT AVG(sales) FROM orders);



--2. Find the highest sales order for each customer. (Subquery)  
-- query 1 : using subquery with correlated subquery
SELECT customer_id,order_id,sales,(SELECT customer_name FROM customers c WHERE c.customer_id = o.customer_id) as customer_name
FROM orders o
WHERE sales = (
    SELECT MAX(sales) 
    FROM orders o2 
    WHERE o2.customer_id = o.customer_id
)
ORDER BY sales DESC;

--showing top 10 highest sales per customer (for abbreviated output)
SELECT customer_id,order_id,sales,(SELECT customer_name FROM customers c WHERE c.customer_id = o.customer_id) as customer_name
FROM orders o
WHERE sales = (
    SELECT MAX(sales) 
    FROM orders o2 
    WHERE o2.customer_id = o.customer_id
)
ORDER BY sales DESC
LIMIT 10;

--3. Calculate total sales for each customer. (CTE) 
-- Using CTE
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales,
    COUNT(o.order_id) as order_count,
    ROUND(AVG(o.sales)::numeric, 2) as avg_order_value
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT customer_id,customer_name,total_sales,order_count,avg_order_value
FROM customer_sales
ORDER BY total_sales DESC
--LIMIT 10; 

--4. Find customers whose total sales are above average. (CTE + Subquery) 
--LIST OF ALL THE CUSTOMERS:
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,ROUND(SUM(o.sales)::numeric, 2) as total_sales, 
    COUNT(o.order_id) as order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT customer_id,customer_name,total_sales,order_count,
ROUND((SELECT AVG(total_sales) FROM customer_sales)::numeric, 2) as avg_customer_sales,
ROUND(total_sales - (SELECT AVG(total_sales) FROM customer_sales)::numeric, 2) as difference_from_avg
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales)
ORDER BY total_sales DESC;

-- COUNT OF CUSTOMERS:
WITH customer_sales AS (
    SELECT customer_id,SUM(sales) as total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT 
    COUNT(*) as customers_above_avg,
    (SELECT COUNT(*) FROM customer_sales) as total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_sales), 2) as percentage_above_avg
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales); 

--5. Rank all customers based on total sales. (Window Function)  
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales,
    COUNT(o.order_id) as order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT customer_id,customer_name,total_sales,order_count,
RANK() OVER (ORDER BY total_sales DESC) as sales_rank,
DENSE_RANK() OVER (ORDER BY total_sales DESC) as dense_rank,
ROW_NUMBER() OVER (ORDER BY total_sales DESC) as row_number
FROM customer_sales
ORDER BY sales_rank


--6. Assign row numbers to each order within a customer. (Window Function + PARTITION BY)  

SELECT o.order_id,o.customer_id,c.customer_name,o.order_date,o.sales,
ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) as order_number_by_date,
RANK() OVER (PARTITION BY o.customer_id ORDER BY o.sales DESC) as sales_rank_within_customer,
COUNT(*) OVER (PARTITION BY o.customer_id) as customer_total_orders,
ROUND(AVG(o.sales) OVER (PARTITION BY o.customer_id)::numeric, 2) as customer_avg_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.customer_id, o.order_date;


--7. Display top 3 customers based on total sales. (Window Function)  
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales,
    COUNT(o.order_id) as order_count,
    ROUND(AVG(o.sales)::numeric, 2) as avg_order_value
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
),
ranked_customers AS (
    SELECT customer_id,customer_name,total_sales,order_count,avg_order_value,
    RANK() OVER (ORDER BY total_sales DESC) as sales_rank
    FROM customer_sales
)
SELECT customer_id,customer_name,total_sales,order_count,avg_order_value,sales_rank
FROM ranked_customers
WHERE sales_rank <= 3
ORDER BY sales_rank;

--Step 3: Final Combined Query
--Customer Name, Total Sales, and Rank(Use JOIN + CTE + Window Function together)
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT customer_name,total_sales,
RANK() OVER (ORDER BY total_sales DESC) as sales_rank
FROM customer_sales
ORDER BY sales_rank;

--MINI PROJECT:CUSTOMER SALES INSIGHTS
-- 1.	Who are the top 5 customers? 
-- (BASED ON TOTAL SALES)
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales,
    COUNT(o.order_id) as order_count,
    ROUND(AVG(o.sales)::numeric, 2) as avg_order_value
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT customer_name,total_sales,order_count,avg_order_value,
RANK() OVER (ORDER BY total_sales DESC) as sales_rank
FROM customer_sales
ORDER BY sales_rank
LIMIT 5;


-- 2.	Who are the bottom 5 customers? 
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales,
    COUNT(o.order_id) as order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT customer_name,total_sales,order_count,
RANK() OVER (ORDER BY total_sales ASC) as sales_rank_asc
FROM customer_sales
WHERE total_sales > 0  
ORDER BY total_sales ASC
LIMIT 5;

--NOTE:EXCLUDING CUSTOMERS WITH ZERO SALES TO FOCUS ON LOW-PERFORMING CUSTOMERS RATHER THAN INACTIVE ONES.

-- 3.	Which customers made only one order? 
WITH customer_order_counts AS (
    SELECT o.customer_id,c.customer_name,
    COUNT(o.order_id) as order_count,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
    HAVING COUNT(o.order_id) = 1
)
SELECT customer_name,order_count,total_sales,
RANK() OVER (ORDER BY total_sales DESC) as sales_rank
FROM customer_order_counts
ORDER BY customer_name;


-- 4.	Which customers have above-average sales? 
WITH customer_sales AS (
    SELECT o.customer_id,c.customer_name,
    ROUND(SUM(o.sales)::numeric, 2) as total_sales,
    COUNT(o.order_id) as order_count
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
),
avg_sales AS (
    SELECT AVG(total_sales) as avg_total_sales
    FROM customer_sales
)
SELECT customer_name,total_sales,order_count,
ROUND(total_sales - (SELECT avg_total_sales FROM avg_sales), 2) as difference_from_avg,
RANK() OVER (ORDER BY total_sales DESC) as sales_rank
FROM customer_sales
WHERE total_sales > (SELECT avg_total_sales FROM avg_sales)
ORDER BY total_sales DESC;

-- 5.	What is the highest order value per customer?
--NOTE:LIMITING TO 10 CUSTOMERS 
SELECT o.customer_id,c.customer_name,
MAX(o.sales) as highest_order_value,
ROUND(AVG(o.sales)::numeric, 2) as avg_order_value,
COUNT(o.order_id) as total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY highest_order_value DESC
LIMIT 10;
