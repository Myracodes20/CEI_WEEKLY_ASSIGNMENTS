CREATE DATABASE IF NOT EXISTS shopease;
USE shopease;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL,
    is_premium BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_customers_state ON customers(state);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    stock_qty INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0)
);

CREATE INDEX idx_products_category ON products(category);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_status ON orders(status);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    discount_pct DECIMAL(5,2) DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);



INSERT INTO customers VALUES
(101, 'Aarav', 'Sharma', 'aarav.s@email.com', 'Mumbai', 'Maharashtra', '2024-01-15', TRUE),
(102, 'Priya', 'Patel', 'priya.p@email.com', 'Ahmedabad', 'Gujarat', '2024-02-20', FALSE),
(103, 'Rohan', 'Gupta', 'rohan.g@email.com', 'Delhi', 'Delhi', '2024-03-10', TRUE),
(104, 'Sneha', 'Reddy', 'sneha.r@email.com', 'Hyderabad', 'Telangana', '2024-04-05', FALSE),
(105, 'Vikram', 'Singh', 'vikram.s@email.com', 'Jaipur', 'Rajasthan', '2024-05-12', TRUE),
(106, 'Ananya', 'Iyer', 'ananya.i@email.com', 'Chennai', 'Tamil Nadu', '2024-06-18', FALSE),
(107, 'Karan', 'Mehta', 'karan.m@email.com', 'Pune', 'Maharashtra', '2024-07-22', TRUE),
(108, 'Divya', 'Nair', 'divya.n@email.com', 'Kochi', 'Kerala', '2024-08-30', FALSE);

INSERT INTO products VALUES
(201, 'Wireless Earbuds', 'Electronics', 'BoAt', 1499.00, 250),
(202, 'Cotton T-Shirt', 'Clothing', 'Levis', 799.00, 500),
(203, 'Smart Watch', 'Electronics', 'Noise', 2999.00, 150),
(204, 'Running Shoes', 'Clothing', 'Nike', 4599.00, 120),
(205, 'Bluetooth Speaker', 'Electronics', 'JBL', 3499.00, 200),
(206, 'Bedsheet Set', 'Home', 'Spaces', 1299.00, 300),
(207, 'Laptop Stand', 'Electronics', 'AmazonBasics', 899.00, 180),
(208, 'Cushion Covers (Set)', 'Home', 'HomeCenter', 599.00, 400);

INSERT INTO orders VALUES
(1001, 101, '2024-08-01', 'Delivered', 4498.00),
(1002, 102, '2024-08-03', 'Delivered', 799.00),
(1003, 103, '2024-08-05', 'Shipped', 7498.00),
(1004, 101, '2024-08-10', 'Delivered', 3499.00),
(1005, 104, '2024-08-12', 'Cancelled', 2999.00),
(1006, 105, '2024-08-15', 'Delivered', 5898.00),
(1007, 106, '2024-08-18', 'Pending', 1299.00),
(1008, 103, '2024-08-20', 'Delivered', 899.00),
(1009, 107, '2024-08-25', 'Shipped', 6098.00),
(1010, 108, '2024-08-28', 'Delivered', 1598.00);

INSERT INTO order_items VALUES
(5001, 1001, 201, 2, 1499.00, 0),
(5002, 1001, 207, 1, 899.00, 10),
(5003, 1002, 202, 1, 799.00, 0),
(5004, 1003, 203, 1, 2999.00, 0),
(5005, 1003, 204, 1, 4599.00, 5),
(5006, 1004, 205, 1, 3499.00, 0),
(5007, 1005, 203, 1, 2999.00, 0),
(5008, 1006, 201, 1, 1499.00, 10),
(5009, 1006, 204, 1, 4599.00, 5),
(5010, 1007, 206, 1, 1299.00, 0),
(5011, 1008, 207, 1, 899.00, 0),
(5012, 1009, 205, 1, 3499.00, 0),
(5013, 1009, 208, 2, 599.00, 15),
(5014, 1010, 206, 1, 1299.00, 0),
(5015, 1010, 208, 1, 599.00, 0);


--section A

--1. Display all columns and rows from customers table
SELECT * FROM customers;

--2. Display only first name, last name, and city from customers table 
SELECT first_name, last_name, city FROM customers;

--3.List all unique categories from products table
SELECT DISTINCT category FROM products;


--4.1 Identify Primary Keys
--for customers table: customer_id
--for products table: product_id
--for orders table: order_id
--for order_items table: item_id

--4.2 Why must PK be unique and NOT NULL? 
--Primary Keys must be unique to ensure that each record can be uniquely identified. 
--prevents duplicate entries and maintains data integrity.
--cannot be NULL because they are essential for identifying records
--a NULL value would mean that the record cannot be identified, which defeats the purpose of having a primary key.

--5.1 What constraints are applied to the email column in the customers table? 
--unique contraint(ensures no duplicate emails) 
--not null constraint (ensures every customer has an email address).

--5.2  What would happen if you tried to insert a duplicate email?
INSERT INTO customers VALUES (109, 'Test', 'User', 'aarav.s@email.com', 'Test City', 'Test State', '2024-01-01', FALSE);
--fails as we cannot do duplicate entry(unique contraint violation)

--6 Try inserting a product with unit_price = -50. What happens and which constraint prevents it? Write both the INSERT statement and explain the error.
INSERT INTO products VALUES (999, 'Test Product', 'Test', 'Test Brand', -50.00, 100);
--fails due to CHECK constraint on unit_price(ensures that the price must be greater than 0.)

--section B

--7 Retrieve all orders with status = 'Delivered'. 
SELECT * FROM orders 
WHERE status = 'Delivered';

--8 Find all products in the 'Electronics' category with a unit_price greater than ₹2000. 
SELECT * FROM products 
WHERE category = 'Electronics' 
AND unit_price > 2000;

--9 List all customers who joined in the year 2024 and belong to the state 'Maharashtra'. 
SELECT * FROM customers 
WHERE YEAR(join_date) = 2024 
AND state = 'Maharashtra';

--OR(for better performance(in 2ms))

SELECT * FROM customers 
WHERE join_date 
BETWEEN '2024-01-01' 
AND '2024-12-31'
AND state = 'Maharashtra';

--10 Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive) that are NOT cancelled. 
SELECT * FROM orders 
WHERE order_date >= '2024-08-10' 
AND order_date <= '2024-08-25' 
AND status != 'Cancelled';

--OR(for better performance(in 2ms))

SELECT * FROM orders 
WHERE order_date 
BETWEEN '2024-08-10' 
AND '2024-08-25' 
AND status != 'Cancelled';

--11.1 Explain what the index idx_orders_date does. 
--The idx_orders_date index is created on the order_date column of the orders table.
--creates a sorted data structure (B-tree) that allows MySQL to quickly locate rows based on date values without scanning the entire table.

--11.2 How would it improve the performance of a query that filters orders by order_date? 
--Without an index, a query filtering by order_date would require a full table scan (checking every row). 
--With the index, MySQL can jump directly to the relevant date range.

--11.3 Write a sample query that would benefit from this index. 
SELECT * FROM orders 
WHERE order_date = '2024-08-15';

SELECT * FROM orders 
WHERE order_date 
BETWEEN '2024-08-01' 
AND '2024-08-31';

--12.1 If you run: SELECT * FROM customers WHERE YEAR(join_date) = 2024; — would the index on join_date be used? Explain why or why not.
SELECT * FROM customers 
WHERE YEAR(join_date) = 2024;
--No, the index on join_date would not be used because the YEAR() function 
--if our dataset was huge, it prevents MySQL from utilizing the index effectively (non-SARGable).
--but since our dataset is small, it is much faster than the range query.(1ms)

--12.2 rewrite the query to be index-friendly (SARGable). 

--To make it index-friendly, we can rewrite the query using a range that does not involve a function on the indexed column:
SELECT * FROM customers 
WHERE join_date >= '2024-01-01' 
AND join_date <= '2024-12-31';
--2ms

--section C  

--13 Count the total number of orders in the orders table. 
SELECT COUNT(*) AS total_orders FROM orders;

--14 Find the total revenue (SUM of total_amount) from all 'Delivered' orders. 
SELECT SUM(total_amount) 
AS total_revenue 
FROM orders 
WHERE status = 'Delivered';

--15 Calculate the average unit_price of products in each category. 
SELECT category, AVG(unit_price) 
AS avg_unitprice 
FROM products 
GROUP BY category;

--16 For each order status, find the count of orders and the total revenue. Sort the result by total revenue in descending order. 
SELECT status, COUNT(*) AS order_count, SUM(total_amount) AS total_revenue 
FROM orders 
GROUP BY status 
ORDER BY total_revenue DESC;

--17 Find the most expensive (MAX) and cheapest (MIN) product in each category. 
SELECT category, MAX(unit_price) AS max_price, MIN(unit_price) AS min_price 
FROM products 
GROUP BY category;

--18 List all product categories where the average unit_price is greater than ₹2000. (Hint: Use HAVING clause) 
SELECT category, AVG(unit_price) AS avg_unitprice 
FROM products 
GROUP BY category 
HAVING avg_unitprice > 2000;

--section D

--19 Write an INNER JOIN query to display each order along with the customer first_name and last_name. 
-- Show: order_id, order_date, first_name, last_name, total_amount. 
SELECT o.order_id, o.order_date, c.first_name, c.last_name, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

--20 Using a LEFT JOIN, list ALL customers and their orders (if any). 
--Customers with no orders should still appear with NULL values for order columns. 
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

--21 Write a query using JOINs across three tables (orders → order_items → products) to show: order_id, product_name, quantity, unit_price, and discount_pct for each order item. 
SELECT o.order_id,p.product_name,oi.quantity,oi.unit_price,oi.discount_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id, oi.item_id;

--22.1 Explain the difference between LEFT JOIN and RIGHT JOIN with an example from this schema. 
--LEFT JOIN returns all records from the left table (customers) and matched records from the right table (orders).
--RIGHT JOIN returns all records from the right table (orders) and matched records from the left table (customers).
--Example(left join):
SELECT c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

--Example(right join):
SELECT c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- note: due to the foreign key constraint, every order must have a valid customer,so both queries will give same result

--22.2 When would you use a FULL OUTER JOIN? 
--used when you want to retrieve all records from both tables, regardless of whether there is a match.
--mySQL does not support FULL OUTER JOIN directly.


--23.1 Identify all Foreign Key relationships in the schema. 
--orders.customer_id - customers.customer_id
--order_items.order_id - orders.order_id
--order_items.product_id - products.product_id

--23.2 Explain what would happen if you tried to insert an order with customer_id = 999 (which doesnt exist in customers).
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 999, '2024-09-01', 'Pending', 1000.00);
-- it would result in a foreign key constraint violation, and the insertion would fail.

--section E

--24. Write a query using CASE to classify products into price tiers: 
-- • 'Budget'    → unit_price < 1000 
-- • 'Mid-Range' → unit_price BETWEEN 1000 AND 3000 
--  • 'Premium'   → unit_price > 3000 
--Display: product_name, unit_price, price_tier. 
SELECT product_name,unit_price,
CASE 
    WHEN unit_price < 1000 THEN 'Budget'
    WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
    WHEN unit_price > 3000 THEN 'Premium'
END AS price_tier
FROM products;

--25 Using a CASE statement inside an aggregate function, count how many orders are 'Delivered' vs 'Not Delivered' (all other statuses). Display the result in a single row. 
SELECT 
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status != 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;

--26.1 Explain ACID.
-- ACID stands for Atomicity, Consistency, Isolation, and Durability.
-- It is a set of properties that ensure database transactions are processed reliably.
-- Atomicity: All operations of a transaction are completed successfully or none at all.
-- Consistency: The database state is consistent before and after the transaction.
-- Isolation: Concurrent transactions do not interfere with each other.
-- Durability: Once a transaction is committed, its changes are permanent.

--26.2 Give a real-world example (e.g., bank transfer) showing why each property is important.
-- Example: A bank transfer from account A to account B.
-- Atomicity: If the transfer of funds from A to B fails midway, the entire transaction is rolled back, ensuring no partial transfer occurs.
-- Consistency: The total amount of money in the system remains the same before and after the transfer, ensuring that the database remains in a valid state.
-- Isolation: If two transfers are happening simultaneously, they do not interfere with each other, preventing issues like double spending.
-- Durability: Once the transfer is completed and committed, the changes are permanent, even in the event of a system crash, ensuring that the transaction is not lost.

--27 Write a SQL transaction that does the following atomically: 
  --1. Insert a new order  
  --2. Insert two order items for that order 
  --3. Update the stock_qty of the purchased products 
  --4. If any step fails, ROLLBACK the entire transaction. Otherwise, COMMIT. 
-- Write the complete BEGIN...COMMIT/ROLLBACK block.
 
START TRANSACTION;
 
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (1011, 102, CURDATE(), 'Pending', 1598.00);

INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES 
(5016, 1011, 205, 1, 3499.00, 0),
(5017, 1011, 208, 2, 599.00, 10);
 
UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 205;
UPDATE products SET stock_qty = stock_qty - 2 WHERE product_id = 208;
 

COMMIT;
-- ROLLBACK; 