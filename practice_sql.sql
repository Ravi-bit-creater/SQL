
CREATE TABLE CustomerTransactions (
    id INT PRIMARY KEY,
    login_device VARCHAR(50),
    customer_name VARCHAR(100),
    ip_address VARCHAR(20),
    product VARCHAR(100)
    
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

CREATE TABLE Sales (
    TransactionID INT,
    Store VARCHAR(50),
    SalesAmount DECIMAL(10, 2)
);

INSERT INTO Sales (TransactionID, Store, SalesAmount)
VALUES
    (1, 'A', 100.00),
    (2, 'A', 200.00),
    (3, 'A', 150.00),
    (4, 'B', 250.00),
    (5, 'B', 300.00);

SELECT Store, sum(SalesAmount) from Sales GROUP BY store;

SELECT TransactionID, Store, SalesAmount,
       SUM(SalesAmount) OVER (PARTITION BY Store order by TransactionID ) AS TotalSales
FROM Sales;

SELECT TransactionID, Store, SalesAmount,
      row_number() OVER(PARTITION by store ORDER BY SalesAmount ) as rownumber 
from Sales;

drop table if exists Employees;
CREATE TABLE Employees (
    EmployeeID INT,
    Name VARCHAR(100),
    Department VARCHAR(50),
    HireDate DATE
);


INSERT INTO Employees (EmployeeID, Name, Department, HireDate)
VALUES
    (1, 'Alice', 'HR', '2020-05-01'),
    (1, 'Alice', 'HR', '2022-06-15'),
    (2, 'Bob', 'IT', '2021-07-10'),
    (3, 'Charlie', 'Finance', '2020-09-30'),
    (3, 'Charlie', 'Finance', '2022-05-22');

WITH employeerank AS (
  SELECT
    EmployeeID,
    Name,
    Department,
    HireDate,
    ROW_NUMBER() OVER (PARTITION BY EmployeeID ORDER BY HireDate ASC) AS rownumber
  FROM Employees
)
SELECT  EmployeeID,
    Name,
    Department,
    HireDate FROM employeerank where rownumber = 1;

drop table if exists students;
CREATE TABLE Students (
    StudentID INT,
    StudentName VARCHAR(100),
    ExamScore INT
);

INSERT INTO Students (StudentID, StudentName, ExamScore)
VALUES
    (1, 'Alice', 95),
    (2, 'Bob', 90),
    (3, 'Charlie', 95),
    (4, 'David', 85),
    (5, 'Eva', 90);

SELECT StudentID, StudentName, ExamScore,
rank() OVER(ORDER BY ExamScore desc) AS score_rank
From students;

SELECT StudentID, StudentName, ExamScore,
dense_rank() OVER(ORDER BY ExamScore desc) AS score_rank
From students;

CREATE TABLE ProductSales (
    ProductID INT,
    ProductName VARCHAR(100),
    SalesAmount INT
);

INSERT INTO ProductSales (ProductID, ProductName, SalesAmount) VALUES
(1, 'Product 1', 500),
(2, 'Product 2', 600),
(3, 'Product 3', 550),
(4, 'Product 4', 700),
(5, 'Product 5', 750),
(6, 'Product 6', 800),
(7, 'Product 7', 850),
(8, 'Product 8', 900),
(9, 'Product 9', 950),
(10, 'Product 10', 1000),
(11, 'Product 11', 600),
(12, 'Product 12', 650),
(13, 'Product 13', 700),
(14, 'Product 14', 750),
(15, 'Product 15', 800),
(16, 'Product 16', 850),
(17, 'Product 17', 900),
(18, 'Product 18', 950),
(19, 'Product 19', 1000),
(20, 'Product 20', 100),
(21, 'Product 21', 200),
(22, 'Product 22', 250),
(23, 'Product 23', 300),
(24, 'Product 24', 350),
(25, 'Product 25', 400),
(26, 'Product 26', 450),
(27, 'Product 27', 500),
(28, 'Product 28', 550),
(29, 'Product 29', 600),
(30, 'Product 30', 650),
(31, 'Product 31', 700),
(32, 'Product 32', 750),
(33, 'Product 33', 800),
(34, 'Product 34', 850),
(35, 'Product 35', 900),
(36, 'Product 36', 950),
(37, 'Product 37', 1000),
(38, 'Product 38', 550),
(39, 'Product 39', 600),
(40, 'Product 40', 650),
(41, 'Product 41', 700),
(42, 'Product 42', 750),
(43, 'Product 43', 800),
(44, 'Product 44', 850),
(45, 'Product 45', 900),
(46, 'Product 46', 950),
(47, 'Product 47', 1000),
(48, 'Product 48', 550),
(49, 'Product 49', 600),
(50, 'Product 50', 650);

SELECT ProductID, ProductName, SalesAmount ,
PERCENT_RANK() OVER(ORDER BY SalesAmount desc) as percentrank,
rank() OVER(ORDER BY SalesAmount desc) as sales_rank
from ProductSales;

CREATE TABLE EmployeeSales (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    SalesAmount DECIMAL(10, 2)
);

INSERT INTO EmployeeSales (EmployeeID, EmployeeName, SalesAmount)
VALUES (1, 'Alice', 10000),
    (2, 'Bob', 8500),
    (3, 'Charlie', 7500),
    (4, 'David', 6000),
    (5, 'Eva', 11000),
    (6, 'Frank', 4500),
    (7, 'Grace', 3000),
    (8, 'Hank', 4000),
    (9, 'Ivy', 8000),
    (10, 'Jack', 9500);

SELECT EmployeeID, EmployeeName, SalesAmount,
ntile(3) OVER(ORDER BY SalesAmount) as performacegroup
from EmployeeSales;

drop table if exists EmployeeSalaries;
CREATE TABLE EmployeeSalaries (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10, 2),
    Year INT
);
INSERT INTO EmployeeSalaries (EmployeeID, EmployeeName, Salary, Year) VALUES
(1, 'Alice', 5000, 2023),
(1, 'Alice', 5500, 2024),
(2, 'Bob', 4500, 2023),
(2, 'Bob', 4800, 2024),
(3, 'Charlie', 4000, 2023),
(3, 'Charlie', 4200, 2024),
(4, 'David', 4600, 2023),
(4, 'David', 4700, 2024),
(5, 'Eva', 5200, 2023),
(5, 'Eva', 5400, 2024);

SELECT *, lag(salary) OVER(PARTITION by EmployeeID order by YEAR) as performacesalary
from EmployeeSalaries;

SELECT *,
lag(salary) OVER(PARTITION by EmployeeID order by YEAR) as performacesalary,
salary - lag(salary) OVER(PARTITION by EmployeeID order by YEAR) as differncesalary
from EmployeeSalaries;

CREATE TABLE SalesData (
    SaleID INT,
    EmployeeName VARCHAR(100),
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE
);
INSERT INTO SalesData (SaleID, EmployeeName, SaleAmount, SaleDate) VALUES
(1, 'Alice', 5000, '2025-01-01'),
(2, 'Bob', 3000, '2025-01-02'),
(3, 'Charlie', 4000, '2025-01-03'),
(4, 'David', 4500, '2025-01-04'),
(5, 'Eva', 5500, '2025-01-05');

SELECT SaleID, EmployeeName, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM SalesData;

SELECT SaleID, EmployeeName, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount,
       SaleAmount - LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS differneceamount
FROM SalesData;

drop table if exists EmployeeSalaries;
CREATE TABLE EmployeeSalaries (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10, 2),
    Year INT
);
INSERT INTO EmployeeSalaries (EmployeeID, EmployeeName, Salary, Year) VALUES
(1, 'Alice', 5000, 2021),
(1, 'Alice', 5500, 2022),
(1, 'Alice', 6000, 2023),
(1, 'Alice', 6500, 2024),
(1, 'Alice', 7000, 2025),
(2, 'Bob', 4500, 2023),
(2, 'Bob', 4800, 2024),
(3, 'Charlie', 4000, 2023),
(3, 'Charlie', 4200, 2024),
(4, 'David', 4600, 2023),
(4, 'David', 4700, 2024),
(5, 'Eva', 5200, 2023),
(5, 'Eva', 5400, 2024);

SELECT *,
first_value(salary) OVER(PARTITION by EmployeeID ORDER BY YEAR ) as first_salary
from EmployeeSalaries;

select *,
last_value (Salary) over (partition by EmployeeID order by Year 
                         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as lastsalary,
last_value (Salary) over (partition by EmployeeID order by Year 
                         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)- salary as diff
                         from EmployeeSalaries;
SELECT EmployeeID, EmployeeName, Salary,
       NTH_VALUE(Salary, 2) OVER (PARTITION BY EmployeeID ORDER BY year
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS ThirdSalary
FROM EmployeeSalaries;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS contractors;
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    position    VARCHAR(50),
    salary      DECIMAL(10,2)
);

CREATE TABLE contractors (
    contractor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    position      VARCHAR(50),
    hourly_rate   DECIMAL(10,2)
);


INSERT INTO employees (first_name, last_name, position, salary)
VALUES
('Alice', 'Smith', 'Developer', 70000.00),
('Bob', 'Johnson', 'Developer', 75000.00),
('Charlie', 'Lee', 'Manager', 90000.00);

INSERT INTO contractors (first_name, last_name, position, hourly_rate)
VALUES
('Dave', 'Williams', 'Developer', 40.00),
('Eve', 'Brown', 'Tester', 35.00),
('Bob', 'Johnson', 'Developer', 45.00);

select first_name, last_name, position from employees
UNION all
select first_name, last_name, position from contractors;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    city        VARCHAR(100) NOT NULL
);

CREATE index idx_email on customers(email);

INSERT INTO customers (first_name, last_name, email, city)
VALUES
('John', 'Doe', 'john@example.com', 'New York'),
('Jane', 'Smith', 'jane.smith@example.com', 'Los Angeles'),
('Michael', 'Brown', 'michael.brown@example.com', 'Chicago'),
('Emily', 'Johnson', 'emily.johnson@example.com', 'Houston'),
('Robert', 'Green', 'robert.green@example.com', 'Phoenix');

select * from customers where email = "john@example.com";

explain
select * from customers where email = "john@example.com";

explain analyze
select * from customers where email = "john@example.com";

explain format = json
select * from customers where email = "john@example.com";

create database test;
use test;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id   INT AUTO_INCREMENT ,
    order_date DATE NOT NULL, 
    customer_name VARCHAR(50),
    amount     DECIMAL(10,2),
PRIMARY KEY(order_id, order_date)
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p_before_2020 VALUES LESS THAN (2020),
    PARTITION p_2020       VALUES LESS THAN (2021),
    PARTITION p_2021       VALUES LESS THAN (2022),
    PARTITION p_2022       VALUES LESS THAN (2023),
    PARTITION p_future     VALUES LESS THAN MAXVALUE
);

INSERT INTO orders (order_date, customer_name, amount)
VALUES
('2019-05-10', 'Alice', 100.00),
('2020-01-15', 'Bob', 200.50),
('2020-12-01', 'Charlie', 300.00),
('2021-07-20', 'Diana', 150.75),
('2022-03-02', 'Edward', 500.00),
('2025-06-18', 'FutureMan', 9999.99);

select * from orders;

show create table orders;

SELECT 
    PARTITION_NAME,
    PARTITION_METHOD,
    PARTITION_EXPRESSION,
    SUBPARTITION_METHOD,
    SUBPARTITION_EXPRESSION
FROM information_schema.PARTITIONS
WHERE TABLE_SCHEMA = 'test'
  AND TABLE_NAME   = 'orders';

select * from orders where order_date = 2020;

explain format = json
select * from orders where order_date = 2021;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    department  VARCHAR(50),
    primary key (employee_id,department)
)
PARTITION BY LIST COLUMNS (department) (
    PARTITION p_sales       VALUES IN ('Sales'),
    PARTITION p_hr          VALUES IN ('HR'),
    PARTITION p_engineering VALUES IN ('Engineering', 'DevOps'),
    PARTITION p_other       VALUES IN ('Finance', 'Marketing', 'Operations')
);


INSERT INTO employees (first_name, last_name, department)
VALUES
('Alice', 'Smith', 'Sales'),
('Bob', 'Johnson', 'HR'),
('Charlie', 'Lee', 'Engineering'),
('Diana', 'Lopez', 'DevOps'),
('Eve', 'Turner', 'Marketing');

select * from employees where department='sales';

DROP TABLE IF EXISTS sensor_data;

CREATE TABLE sensor_data (
    sensor_id     INT NOT NULL,
    reading_time  DATETIME NOT NULL,
    reading_value DECIMAL(10,2),
    PRIMARY KEY (sensor_id, reading_time)
)
PARTITION BY HASH(sensor_id)
PARTITIONS 2;

INSERT INTO sensor_data (sensor_id, reading_time, reading_value)
VALUES
(101, '2025-01-01 10:00:00', 23.50),
(102, '2025-01-01 10:05:00', 24.10),
(103, '2025-01-01 10:10:00', 22.75),
(104, '2025-01-01 10:15:00', 25.00),
(105, '2025-01-01 10:20:00', 20.00),
(106, '2025-01-01 10:25:00', 21.60);

explain format=json
select * from sensor_data where sensor_id=102;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id      INT AUTO_INCREMENT ,
    order_date    DATE NOT NULL,
    customer_name VARCHAR(50),
    amount        DECIMAL(10,2),
    primary key(order_id, order_date)
)
PARTITION by RANGE (YEAR(order_date))(
    PARTITION p_before_2020 VALUES LESS than    (2020),
    partition p_2020 values less than (2021),
    partition p_2021 values less than (2022),
    partition p_2022 values less than (2023),
    partition p_future values less than MAXVALUE
);

create index idx_order_date on orders(order_date);

INSERT INTO orders (order_date, customer_name, amount)
VALUES
('2019-05-10', 'Alice', 100.00),
('2020-01-15', 'Bob', 200.50),
('2020-12-01', 'Charlie', 300.00),
('2021-07-20', 'Diana', 150.75),
('2022-03-02', 'Edward', 500.00),
('2025-06-18', 'FutureMan', 9999.99);

SELECT *
FROM orders
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31';

CREATE DATABASE IF NOT EXISTS datetime_vs_timestamp;
USE datetime_vs_timestamp;

DROP TABLE IF EXISTS demo_events;
CREATE TABLE demo_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO demo_events (event_name, event_date)
VALUES
    ('New Year Celebration', '2025-01-01 00:00:00'),
    ('Summer Fest', '2025-06-15 12:30:00');

select * from demo_events;

select event_id, event_name, event_date, year(event_date) as eventdate from demo_events;
select event_id, event_name, event_date, month(event_date) as eventdate from demo_events;
select event_id, event_name, event_date, day(event_date) as eventdate from demo_events;
select event_id, event_name, event_date + INTERVAL 30 day as plus30days from demo_events;
select event_id, event_name, event_date - INTERVAL 30 day as plus30days from demo_events;
select event_id, event_name, event_date, date_format(event_date, '%W, %M, %e, %Y') as eventdate from demo_events;
select event_id, event_name, event_date, date_format(event_date, '%h:%i %p') as eventdate from demo_events;

DROP TABLE IF EXISTS regex_samples;
CREATE TABLE regex_samples (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sample_text VARCHAR(100)
);

INSERT INTO regex_samples (sample_text) VALUES 
('apple'),         -- id=1
('Banana'),        -- id=2 (note the capital B)
('cherry'),        -- id=3
('date'),          -- id=4
('elderberry'),    -- id=5
('fig'),           -- id=6
('grape'),         -- id=7
('honeydew'),      -- id=8
('running'),       -- id=9 (ends with "ing")
('123abc');        -- id=10 (starts with digits)

select * from regex_samples
where sample_text regexp '^a';

select * from regex_samples
where sample_text regexp 'e$';

select * from regex_samples
where sample_text regexp '^[0-9]';

select * from regex_samples
where sample_text regexp 'ing$';

select * from regex_samples
where sample_text regexp '(.)\\1';

select * from regex_samples
where sample_text regexp '^[A-Za-z]+$';

select * from regex_samples
where sample_text regexp '.{5}$';

select * from regex_samples
where sample_text regexp '^[A-Z]';

select * from regex_samples
where sample_text regexp '^(apple|banana)';

select * from regex_samples
where sample_text regexp '^[0-9]{3}[A-Za-z]+$';

CREATE TABLE demo_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(50),
    phone VARCHAR(25),
    email VARCHAR(100),
    date_col VARCHAR(10),   -- Storing as VARCHAR for the demo
    status VARCHAR(20),
    sku VARCHAR(20),
    username VARCHAR(30),
    notes VARCHAR(100)
);


INSERT INTO demo_data (full_name, phone, email, date_col, status, sku, username, notes)
VALUES
-- 1
('John Smith', 
 '123-456-7890', 
 'john@example.com', 
 '2025-02-07', 
 'pending', 
 'ABCD', 
 'johnsmith', 
 'Ships to CA'),

-- 2
('Alice Johnson', 
 '(987) 654-3210', 
 'alice@@example.net', 
 '2025-02-07', 
 'inactive', 
 'SKU-123', 
 'alice', 
 'NY location'),

-- 3
('Bob Williams', 
 '+1-555-123-4567', 
 'bob@sample.org', 
 '20250207', 
 'complete', 
 '1SKU', 
 'bob123', 
 'Shipping to CA'),

-- 4
('Mary 1 White', 
 '(123) 123-4567', 
 'mary123@example.com', 
 '2025-13-31', 
 'PENDING', 
 'abc-999', 
 'mary_white', 
 'Something about CA or'),

-- 5
('Mark-Spencer', 
 '1234567890', 
 'mark@example.com', 
 '2024-11-02', 
 'active', 
 'SKU-9999', 
 'mark', 
 'Random note'),

-- 6
('Jane O''Connor',   -- Note the doubled apostrophe for SQL
 '987-654-3210', 
 'jane.o.connor@example.org', 
 '2024-12-31', 
 'inactive', 
 'ABCDE', 
 'janeO', 
 'Contains CA or NY'),

-- 7
('Invalid Mail', 
 '000-000-0000', 
 'invalid@@example..com', 
 '2023-01-15', 
 'inactive', 
 'XYZ000', 
 'invalid', 
 'Double @ and dots'),

-- 8
('NoSpacesHere', 
 '+12-345-678-9012',
 'nospaces@example.co',
 '2025-02-07',
 'pending',
 'SKU999',
 'NoSpaces',
 'Ends with .co domain');


select * from demo_data 
where date_col regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

SELECT *
FROM demo_data
WHERE full_name REGEXP '^[A-Za-z ]+$';

CREATE TABLE Accounts (
  AccountID INT PRIMARY KEY,
  AccountHolder VARCHAR(100),
  Balance DECIMAL(10,2)
);

INSERT INTO Accounts (AccountID, AccountHolder, Balance)
VALUES (1, 'Alice', 5000.00);

CREATE USER 'jane_doe'@'localhost' IDENTIFIED BY 'StrongP@ssw0rd';

grant select, insert on test.* to 'jane_doe'@'localhost';

FLUSH PRIVILEGES;

select user, host  from mysql.user;

REVOKE SELECT, INSERT ON test.* FROM 'jane_doe'@'localhost';
FLUSH PRIVILEGES;
show tables;
select * from accounts;
select * from demo_data;