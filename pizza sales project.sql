create database pizzahut;
use pizzahut;

create table orders 
(	
	order_id int not null,
    order_date date not null,
    order_time time not null,
    primary key(order_id)
);

create table order_details 
(	
	order_details_id int not null,
    order_it int not null,
    pizza_id text not null,
	quantity int not null,
    primary key(order_details_id)
);


-- Basic:
-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
select round(sum(order_details.Quantity*pizzas.price),2) as total_revenue
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1 offset 0;

-- Identify the most common pizza quantity ordered.
select quantity, count(*) as count 
from order_details
group by quantity;

-- Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) 
from pizzas join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by count(order_details.order_details_id) desc
limit 1 offset 0;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas on 
pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on 
pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by quantity desc
limit 5 offset 0;

-- Intermediate: 
-- Join the necessary tables to find the total quantity of each pizza category ordered. 
select pizza_types.category as category, sum(order_details.quantity) as total_quantity
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by sum(order_details.quantity) desc;

-- Determine the distribution of orders by hour of the day. 
select hour(order_time) as hours, count(order_id) from orders
group by hour(order_time)
order by hours asc;

-- Join relevant tables to find the category-wise distribution of pizzas. 
select category, count(*) from pizza_types 
group by category ;

-- Group the orders by date and calculate the average number of pizzas ordered per day. 
select date(orders.order_date) as _date, 
round(avg(order_details.quantity),1) as average
from orders join order_details
on orders.order_id = order_details.order_id
group by date(orders.order_date);

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pizza_type, (quantity_ordered * price) AS revenue
FROM pizza_orders
ORDER BY revenue DESC
LIMIT 3;