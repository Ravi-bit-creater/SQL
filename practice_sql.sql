
CREATE TABLE CustomerTransactions (
    id INT PRIMARY KEY,
    login_device VARCHAR(50),
    customer_name VARCHAR(100),
    ip_address VARCHAR(20),
    product VARCHAR(100),
    amount DECIMAL(10, 2),
    is_placed BOOLEAN,
    is_viewed BOOLEAN,
    transaction_status VARCHAR(20)
);

INSERT INTO CustomerTransactions VALUES
(1, 'Mobile', 'Ravi', '192.168.1.1', 'Laptop', 50000.00, TRUE, FALSE, 'Completed'),
(2, 'Desktop', 'Priya', '192.168.1.2', 'Smartphone', 20000.00, TRUE, TRUE, 'Completed'),
(3, 'Tablet', 'Arjun', '192.168.1.3', 'Headphones', 1500.00, FALSE, TRUE, 'Failed'),
(4, 'Mobile', 'Meena', '192.168.1.4', 'Shoes', 2500.00, TRUE, FALSE, 'Completed'),
(5, 'Desktop', 'Karthik', '192.168.1.5', 'Watch', 5000.00, TRUE, TRUE, 'Completed'),
(6, 'Mobile', 'Sowmya', '192.168.1.6', 'Tablet', 15000.00, TRUE, TRUE, 'Completed'),
(7, 'Tablet', 'Ramesh', '192.168.1.7', 'Smartphone', 25000.00, FALSE, TRUE, 'Failed'),
(8, 'Desktop', 'Divya', '192.168.1.8', 'Laptop', 60000.00, TRUE, FALSE, 'Completed'),
(9, 'Mobile', 'Arun', '192.168.1.9', 'Smartwatch', 12000.00, TRUE, TRUE, 'Completed'),
(10, 'Tablet', 'Deepa', '192.168.1.10', 'Laptop', 55000.00, FALSE, FALSE, 'Pending');

SELECT * FROM customertransactions;

SELECT COUNT(*) FROM customertransactions WHERE transaction_status NOT IN ('Failed','Pending');

SELECT avg(amount) AS avg_transaction FROM CustomerTransactions;

SELECT MIN(amount) AS min_transaction FROM customertransactions;

SELECT max(amount) AS max_transaction FROM customertransactions;

SELECT sum(amount) AS sum_transaction FROM customertransactions;

SELECT login_device, sum(amount) AS sum_transaction
FROM customertransactions
GROUP BY login_device;

SELECT login_device, sum(amount) AS sum_transaction
FROM customertransactions
GROUP BY login_device
HAVING sum(amount) > 80000;

CREATE TABLE CustomerData (
    id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(15),
    address VARCHAR(200),
    amount DECIMAL(10, 2)
);

INSERT INTO CustomerData VALUES
(1, 'Ravi', 'ravi@example.com', '98765', 'Chennai', 5000.00),
(2, 'Priya', NULL, '98765', 'Bangalore', NULL),
(3, 'Arjun', 'arjun@example.com', NULL, 'Hyderabad', 1500.00),
(4, 'Meena', NULL, NULL, 'Mumbai', 2500.00),
(5, 'Karthik', 'karthik@example.com', '98765', NULL, 3000.00);

SELECT * FROM customerdata;

SELECT customer_name, amount, 
CASE
WHEN amount > 4000 THEN 'Highest Spender'
WHEN amount BETWEEN 2000 AND 4000 THEN 'Medium Spender'
WHEN amount <= 2000 THEN 'Low Spender'
ELSE 'No Data'
END as spending
FROM customerdata;

SELECT customer_name, amount, 
CASE
 when email is null and phone_number is null then '9999'  -- ordering matters
    when email is null  then phone_number
    else email
END as Contaxct
FROM customerdata;

SELECT count(*) AS null_values
FROM customerdata
WHERE phone_number IS NULL;

SELECT count(*) AS null_values
FROM customerdata
WHERE phone_number IS NOT NULL;

SELECT customer_name, email, phone_number
FROM customerdata
WHERE email IS NULL OR
phone_number is NULL OR
address IS NULL;

SELECT customer_name, COALESCE(amount, '00.0') 
AS adjust_amount FROM customerdata; 

SELECT
length(customer_name) as length_of_customername,
upper(customer_name) as upper_customername,
lower(customer_name) as lower_customername,
concat(customer_name,'-', address,'-','TN') as combined,
substring(customer_name, 1,3) as sub_string,
trim('    chennai   ') as trimed,
lpad(customer_name, 10, '*') as left_pad,
rpad(customer_name, 10, '*') as rightpad,
REVERSE(customer_name) as reverse_name,
REPLACE(email,'@',"&") as replaced,
instr(customer_name, 'a') as position_of_a,
RIGHT(customer_name, 2) as last_2_character,
left(customer_name,2) as firts_2_character,
FORMAT(9387878787,2) as formatting
FROM customerdata;

CREATE TABLE orders (
    order_id INT,
    customer_id INT PRIMARY KEY,
    order_date DATE,
    order_amount DECIMAL(10,2));

INSERT INTO orders (order_id, customer_id, order_date, order_amount)
VALUES
(101, 1, '2025-11-01', 2500.00),
(102, 2, '2025-11-02', 1800.50),
(103, 3, '2025-11-03', 3200.75),
(104, 4, '2025-11-04', 1500.00),
(105, 5, '2025-11-05', 2750.25),
(106, 6, '2025-11-06', 1999.99);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(100),
    FOREIGN KEY (customer_id) references orders(customer_id)
);

INSERT INTO customer (customer_id, customer_name, city)
VALUES
(1, 'Ravi Kumar', 'Coimbatore'),
(2, 'Anjali Sharma', 'Chennai'),
(3, 'Vikram Rao', 'Bangalore'),
(4, 'Meena Devi', 'Madurai'),
(5, 'Suresh Babu', 'Salem');

SELECT customer_name,
(SELECT max(order_amount)FROM orders) as max_order_amount
FROM customer;

SELECT customer_name FROM customer
WHERE customer_id IN (
    SELECT customer_id FROM orders WHERE order_amount > 2000
);

SELECT customer_name,
(SELECT max(order_amount)FROM orders) as max_order_amount
FROM customer;

SELECT customer_name 
FROM customer
WHERE customer_id IN 
(SELECT customer_id FROM orders
WHERE order_amount > 2000);

SELECT customer_name
FROM customer
WHERE EXISTS(
    SELECT 1 FROM orders
    where 
    orders.customer_id = customer.customer_id AND
    order_date >= CURRENT_DATE - INTERVAL 30 day
);

SELECT customer_name, city,
(SELECT sum(order_amount) FROM orders o 
where o.customer_id = c.customer_id) as total_orders
FROM customer c;

SELECT customer_name, city,CASE
when (SELECT sum(order_amount) FROM orders where
orders.customer_id = customer.customer_id) > 
(SELECT avg(order_amount) FROM orders) THEN 'Above Average'
ELSE 'Below Average'
END as order_category
FROM customer;

SELECT customer_name, (
    SELECT max(order_amount) from orders where
    order_amount < (SELECT max(order_amount) from orders) )as second_highest_order
from customer;

-- Create the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    Salary     DECIMAL(10,2),
    Department VARCHAR(50)
);

-- Insert sample data into the Employees table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Salary, Department)
VALUES
    (1, 'Alice', 'Johnson', 55000.00, 'Sales'),
    (2, 'Bob',   'Smith',   60000.00, 'IT'),
    (3, 'Carol', 'Davis',   52000.00, 'Sales'),
    (4, 'Dave',  'Wilson',  58000.00, 'HR');

CREATE view sales_department AS
SELECT FirstName, LastName, Salary from Employees where Department = 'Sales';

SELECT * from sales_department;

DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Restaurants;

CREATE TABLE Restaurants (
    id INT  PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);

INSERT INTO Restaurants (id, name, location) VALUES
(1, 'ABC Bistro', 'New York'),
(2, 'The Foodie', 'Los Angeles'),
(3, 'Tasty Treat', 'Chicago');

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    order_date DATE NOT NULL
);

INSERT INTO Orders (order_id,restaurant_id, order_date) VALUES
(1, 1, '2023-01-01'),
(2, 1, '2023-01-02'),
(3, 2, '2023-01-05'),
(4, 4, '2023-01-07');  

SELECT 
r.name, o.order_date
from Restaurants r 
join Orders o on 
r.id = o.restaurant_id;

SELECT 
r.name, o.order_date
from Restaurants r 
left join Orders o on 
r.id = o.restaurant_id;

SELECT 
r.name, o.order_date
from Restaurants r 
right join Orders o on 
r.id = o.restaurant_id;