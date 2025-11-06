
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

