Create database if not exists ecommerce_analytics_db;
use ecommerce_analytics_db;

-- Customers Table
create table Customers(
customer_id INT Auto_Increment,
first_name varchar(100) Not Null,
last_name Varchar(100),
city varchar(50),
signup_date Date Not Null Default (Current_date),
primary key(customer_id)
);

Alter table ecommerce_analytics_db.customers
add email Varchar(100) Not Null Unique;

-- Products Table
Create table Products(
product_id INT Auto_Increment,
Product_name Varchar(50) NOT NULL,
category Varchar(100) Not Null,
price Decimal(10,2),
primary key (product_id)
);

-- Orders Table
Create Table Orders (
order_id INT Auto_Increment Primary Key,
customer_id INT Not Null,
order_date Date Not Null,
total_amount Decimal (10,2) Not Null,
Foreign Key (customer_id) References customers(customer_id)
);

-- Order_items Table
create table Order_items(
order_id INT Not Null,
product_id INT Not Null,
quantity Int Not Null,
price_per_unit Decimal(10,2) Not Null,
primary key (order_id, product_id),
foreign key(order_id) References Orders(order_id),
Foreign Key (product_id) References Products(product_id)
);

-- Payments Table
Create Table payments(
payment_id INT Auto_increment,
order_id Int Not Null,
payment_date Date Not Null,
payment_method varchar(50) Not Null,
payment_amount Decimal(10,2) Not Null,
Primary Key(payment_id),
Foreign Key (order_id) references Orders(order_id)
);

-- inserting data into customers table
Insert into Customers (first_name, last_name, city, signup_date, email)
Values('John', 'Doe', 'Lake Zurich', '2024-01-01', 'john.doe@gmail.com'),
('John', 'Smith', 'Lake Bluff', '2024-02-02', 'john@gmail.com'),
('Alice', 'Bob', 'Round Lake', '2024-03-03','Alice@gmail.com'),
('Julie', 'James', 'Arlington Heights', '2024-04-03','Julie@gmail.com'),
('Mark', 'zoe', 'Buffalo grove', '2025-05-01', 'mark@gmail.com');

select * from ecommerce_analytics_db.customers;

-- Inserting into product table

Insert into Products(product_name, category, price) Values
('iPhone 13+', 'Electronics', 1200.25),
('Jeans', 'Clothing', 15.55),
('Earrings', 'Jewellery', 20.5),
('Shirt', 'Clothing', 31.10),
('Cap', 'Accessories', 10.11),
('Ring', 'Jewellery', 12.22),
('Laptop', 'Electronics', 1500.55),
('Watch', 'Accessories', 200.56);

-- Inserting into Orders table
Insert into Orders(customer_id, order_date, total_amount) Values
(1,'2025-01-01', 12.55),
(1, '2025-01-05', 15.55),
(2, '2025-03-09', 14.55),
(3, '2025-12-12', 79.99),
(4, '2026-01-01', 45.99),
(5, '2026-02-02', 60.00),
(4, '2025-12-12',99.99);

select * from ecommerce_analytics_db.orders;

-- Inserting into order_items table
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit) VALUES
(1, 2, 1, 15.55),
(2, 3, 1, 20.50),
(3, 8, 1, 200.56),
(4, 7, 1, 79.99),
(5, 3, 1, 20.50),
(6, 4, 1, 31.10),
(7, 1, 1, 1200.25),
(7, 5, 1, 10.11);

-- Inserting into payments table
INSERT INTO payments (order_id, payment_date, payment_method, payment_amount) VALUES
(1, '2025-01-01', 'Card', 12.55),
(2, '2025-01-05', 'UPI', 15.55),
(3, '2025-03-09', 'PayPal', 14.55),
(4, '2025-12-12', 'Card', 79.99),
(5, '2026-01-01', 'UPI', 45.99),
(6, '2026-02-02', 'Card', 60.00),
(7, '2025-12-12', 'PayPal', 99.99);

-- Tasks
-- 1. Get all orders where total amount > 50
select * from ecommerce_analytics_db.orders where total_amount>50;

-- 2.Find customers whose name starts with “J”
select * from ecommerce_analytics_db.customers where first_name like 'J%' ; 

-- 3. Show products sorted by price (highest first)
select * from ecommerce_analytics_db.products order by price DESC, product_name DESC;

-- 4. Find total revenue per customer
select customer_id, sum(total_amount) As Total_revenue from ecommerce_analytics_db.orders group by customer_id;

-- 5.Count how many orders each customer placed
select customer_id, count(order_id) from ecommerce_analytics_db.orders group by customer_id;

-- 6.Show all customer names in uppercase
select upper(first_name) As First_name, last_name, city from ecommerce_analytics_db.customers;

-- 7.Create full name (first + last name)
select customer_id, concat(first_name,' ', last_name) As Full_name, city, signup_date, email from ecommerce_analytics_db.customers;

-- 8.Find customers whose name length > 4

select * from ecommerce_analytics_db.customers where length(first_name)>4;

-- 9.Extract first 3 letters of product name
select product_id, substring(product_name, 1,3) as ExtractString from ecommerce_analytics_db.products;

-- 10.Round product prices to 1 decimal
select round(price,1) as rounded_value from ecommerce_analytics_db.products;

-- 11. Find average order value
select avg(total_amount) as average_total from ecommerce_analytics_db.orders;

-- 12. Find max and min product price
select min(price) as minimum_value, max(price) as maximum_value from ecommerce_analytics_db.products;

-- 13.Calculate total revenue from order_items
select order_id, sum(quantity * price_per_unit) As Total_revenue from ecommerce_analytics_db.order_items group by order_id;

-- 14. Extract year from order_date
select order_id, year(order_date) As order_year from ecommerce_analytics_db.orders;

-- 15. Extract month from order_date
select month(order_date) from ecommerce_analytics_db.orders;

-- 16.Calculate days between signup and order
select customers.signup_date, orders.order_date, datediff(signup_date,order_date) AS Date_diff from customers
join orders on customers.customer_id=orders.customer_id;

-- 17.Show monthly revenue
select Month(payment_date), sum(payment_amount) from ecommerce_analytics_db.payments group by month(payment_date);

-- 18. CASE STATEMENTS (categorize orders)
Select 
	*, 
	Case
		when total_amount > 100 Then 'High Cost'
		when total_amount between 50 and 100 Then 'Medium Cost'
		else 'Low Cost'
	End  As price_category
from ecommerce_analytics_db.orders;

-- 19.Categorize customers based on total spending
select concat(c.first_name, ' ', c.last_name) As full_name, sum(o.total_amount) as total_revenue,
	case
		when sum(o.total_amount)>100 Then 'High'
        when sum(o.total_amount) Between 50 and 100 Then 'Medium'
        else 'Low'
        End As Spending_category
from ecommerce_analytics_db.customers c
join ecommerce_analytics_db.orders o on c.customer_id=o.customer_id group by concat(c.first_name, ' ', c.last_name);

-- 20.Show customer name + order_id

select concat(c.first_name, ' ', c.last_name) as customer_name, o.order_id from ecommerce_analytics_db.customers c
join ecommerce_analytics_db.orders o on c.customer_id=o.customer_id;

-- 21. Show customer + product + quantity
select concat(c.first_name, ' ', last_name) as customer_name, product_name, quantity from ecommerce_analytics_db.customers c
join ecommerce_analytics_db.orders o on c.customer_id=o.customer_id
join ecommerce_analytics_db.order_items oi on oi.order_id=o.order_id
join ecommerce_analytics_db.products p on p.product_id=oi.product_id;

-- 22.Show revenue per product
select oi.product_id, sum(oi.quantity * oi.price_per_unit) As total_revenue, p.product_name
from ecommerce_analytics_db.order_items oi join ecommerce_analytics_db.Products p
on oi.product_id=p.product_id group by oi.product_id,p.product_name;

-- 23. Top 3 highest spending customers

SELECT 
    p.product_name,
    SUM(oi.quantity * oi.price_per_unit) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_name, p.product_id
ORDER BY total_revenue DESC
LIMIT 3;

-- 24.Create a view: order_id, customer_id, total order value (calculated)

create view order_summary_view As 
Select o.order_id, o.customer_id, sum(oi.quantity * oi.price_per_unit) as total_order_value from ecommerce_analytics_db.orders o
join ecommerce_analytics_db.order_items oi on o.order_id=oi.order_id group by o.order_id, o.customer_id;

select * from order_summary_view;

-- 25. Use the view to get top customers
select customer_id, sum(total_order_value) as total_order_value from order_summary_view group by customer_id order by total_order_value DESC Limit 3;

-- 26. Create stored procedure: Input: customer_id, Output: their orders

Delimiter //
create procedure get_customer_order(IN cust_id INT)
Begin
	Select * from ecommerce_analytics_db.orders where Customer_id=cust_id;
End //

call get_customer_order(1);

-- 27.Create stored procedure Procedure, Input: product_id, Output: total revenue of that product

	Delimiter //
	create procedure total_revenue_of_product(In p_id INT)
	Begin
		select product_id, sum(oi.quantity * oi.price_per_unit) As total_revenue from ecommerce_analytics_db.order_items oi where oi.product_id=p_id group by product_id;
	End //

call total_revenue_of_product(1);

-- 28.CTE for customer total spending
With customer_total_spending As(
	select customer_id, sum(total_amount) As total_spending
    From ecommerce_analytics_db.orders
    Group by customer_id
)
Select * from customer_total_spending;

-- Window Functions
-- 29.Give each order a sequence number
select customer_id, order_id, order_date, row_number() over(partition by customer_id order by order_date) As row_num from ecommerce_analytics_db.orders;

SELECT 
    customer_id,
    order_id,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_id
    ) AS running_total
FROM ecommerce_analytics_db.orders;


		





