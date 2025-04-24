create database retail_analytics;
use retail_analytics;
create table customers (
	customer_id int auto_increment primary key,
    customer_name varchar(100),
    region varchar(50),
    signup_date date
);

create table products (
	product_id int auto_increment primary key,
    product_name varchar(100),
    category varchar(50),
    price decimal(10,2),
    stock int
);

create table orders (
	order_id int auto_increment primary key,
    customer_id int,
    product_id int,
    quantity int,
    order_date date,sys_config
    decimal(10,2),
    foreign key (customer_id) references customers(customer_id),
    foreign key (product_id) references products(product_id)
);

select * from project_customers limit 10;
select * from project_orders limit 10;
select * from project_products limit 10;

select
	p.category,
    sum(o.total_price) as total_revenue
from
	project_orders o
join
	project_products p on o.product_id = p.product_id
group by
	p.category;
Describe project_orders;

select
	date_format(order_date, '%y-%m') as month,
    sum(total_price) as monthly_sales
from
	project_orders
where 
	order_date >= date_sub(curdate(), interval 12 month)
group by
	month
order by month;

select
	c.customer_id,
    c.customer_name,
    sum(o.total_price) as total_spent
from
	project_orders o
join
	project_customers c on o.customer_id = c.customer_id
group by
	c.customer_id, c.customer_name
order by
	total_spent desc
limit 5;

select
	category,
	product_name,
    quantity_sold
from(
	select
		p.category,
        p.product_name,
        sum(o.quantity) as quantity_sold,
        rank() over (partition by p.category order by sum(o.quantity) desc)as rank_in_category
	from
		project_orders o
	join 
		project_products p on o.product_id= p.product_id
	group by
		p.category, p.product_name
) ranked
where
	rank_in_category <= 2;

select
	o.customer_id
from
	project_orders o
join
	project_products p on o.product_id = p.product_id
group by
	o.customer_id
having
	count(distinct p.category) >= 3;
    
select
	customer_id,
    count(*) as total_orders
from
	project_orders
group by
	customer_id
having
	count(*) > 3;
    
select
	product_id,
    product_name,
    stock_qty
from
	project_products
where
	stock_qty < 50;
    
select
	c.region,
    sum(o.quantity * p.price) as total_revenue
from
	project_orders o
join
	project_customers c on o.customer_id = c.customer_id
join
	project_products p on o.product_id = p.product_id
group by
	c.region;
    
select
	o.customer_id,
    round(sum(o.quantity * p.price) / count(o.order_id), 2) as avg_revenue_per_order
from
	project_orders o
join
	project_products p on o.product_id = p.product_id
group by
	o.customer_id;
    
select 
	c.customer_id,
    c.customer_name,
    sum(o.quantity * p.price) as cltv
from
	project_customers c
join
	project_orders o on c.customer_id = o.customer_id
join
	project_products p on o.product_id = p.product_id
where
	c.signup_date < curdate() - interval 1 year
group by
	c.customer_id, c.customer_name;
    
    