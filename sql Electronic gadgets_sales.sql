CREATE DATABASE ecommerce;

CREATE TABLE customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR (50),
email VARCHAR (50),
phone_number INT
);

ALTER TABLE customers 
MODIFY phone_number VARCHAR (50);

INSERT INTO customers (customer_id, customer_name, email, phone_number)
VALUES
(1001, 'Alice Johnson', 'alice.johnson@example.com', 1234567890),
(1002, 'Bob Smith', 'bob.smith@example.com', 234567-8901),
(1003, 'Charlie Brown', 'charlie.brown@example.com', 3456789012),
(1004, 'Diana Green', 'diana.green@example.com', 4567890123),
(1005, 'Eve White', 'eve.white@example.com', 5678901234);


CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
order_date VARCHAR (30) NOT NULL,
total_amount DECIMAL (10,2)
);

INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES
(1, 1002, '2024-11-01', 1300.00),
(2, 1004, '2024-11-03', 850.00),
(3, 1001, '2024-11-05', 450.00),
(4, 1003, '2024-11-07', 1550.00),
(5, 1005, '2024-11-09', 320.00),
(6, 1005,  '2024-11-10', 500.00),
(7, 1001, '2024-11-11', 200.00),
(8, 1003, '2024-11-12', 700.00),
(9, 1003, '2024-11-13', 1100.00),
(10, 1005, '2024-11-14', 600.00),
(11, 1002, '2024-11-15', 800.00),
(12, 1004, '2024-11-16', 1000.00),
(13, 1004, '2024-11-17', 350.00),
(14, 1002, '2024-11-18', 1200.00),
(15, 1005, '2024-11-19', 700.00);


CREATE TABLE products (
product_id INT PRIMARY KEY,
product_name VARCHAR (50),
price DECIMAL (10,2)
);

INSERT INTO products (product_id, product_name, price)
VALUES
(1101, 'Laptop', 1200.00),
(1102, 'Smartphone', 800.00),
(1104, 'Tablet', 450.00),
(1105, 'Headphones', 150.00),
(1106, 'Mouse', 25.00),
(1107, 'Keyboard', 50.00),
(1108, 'Monitor', 300.00),
(1109, 'Charger', 30.00),
(1110, 'USB Cable', 10.00),
(1111, 'Webcam', 80.00);


CREATE TABLE order_items(
order_item_id INT PRIMARY KEY,
order_id INT,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
product_id INT,
FOREIGN KEY (product_id) REFERENCES products(product_id),
quantity INT
);

INSERT INTO order_items( order_item_id, order_id, product_id, quantity)
VALUES
(201, 1, 1102, 1),
(202, 2, 1106, 1),
(203, 3, 1107, 1),
(204, 5, 1104, 2),
(205, 6, 1101, 1),
(206, 7, 1111, 2),
(207, 4, 1108, 3),
(208, 3, 1105, 1),
(209, 8, 1104, 3),
(210, 9, 1108, 1),
(211, 10,1109, 2),
(212, 1, 1102, 1),
(213, 2, 1105, 1),
(214, 4, 1106, 1),
(215, 6, 1109, 1);

-- Retrieve all customers from the "customers" table: 
SELECT * FROM customers;

-- Retrieve the details of the orders made by a specific customer:
SELECT o.order_id, o.order_date, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 1002;

-- Retrive total amount of each order along with the customer name: 
SELECT c.customer_name, o.order_id, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Retrive the products that have a price greater than a specified amount:
SELECT * FROM products
WHERE price > 100;

-- Retrive the total quantity sold for each product:
SELECT p.product_name, SUM(oi.quantity) AS total_quantity_ordered
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP By p.product_name;

-- Retrive the customer who made the highest total purchase amount:
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

-- Retrieve the customers who have not placed any orders:
SELECT * FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- Retrieve the order with the highest total amount:
SELECT * FROM orders
ORDER BY total_amount DESC
LIMIT 1;

-- Retrieve the product that have been ordered the most:
SELECT p.product_name, SUM(oi.quantity) AS total_quantity_ordered
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_ordered DESC
LIMIT 1;

-- Retrieve the customers who have places orders for a specific product:
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.product_id = 1105;

-- Update thr price of a specific product
UPDATE products
SET price = 1200
WHERE product_id = 1108;

-- Update the customer details for a specific customer:
UPDATE customers
SET customer_name  = 'Johnathan Doe', phone_number = 9876543210
WHERE customer_id = 1004;

-- Perform an inner join between the "orders" and "customers" tables to retrieve the order details along with the customer name:
SELECT o.order_id, o.order_date, o.total_amount, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Perform a left join between the "customers" and "orders" tables to retrieve all customers, including those who have not placed any orders:
SELECT c.customer_name, o.order_id, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- ADD a unique constraint on the email column of the "customers" table:
ALTER TABLE customers ADD CONSTRAINT unique_email UNIQUE (email);


-- ADD a foreign key constraint on the customer_id column of the "orders" table, referencing the customer_id column of the "customers" table:
ALTER TABLE orders
ADD CONSTRAINT fk_customer 
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

