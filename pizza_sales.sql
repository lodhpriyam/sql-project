create table orders(
order_id INT primary key,
order_date date,
order_time time)



SELECT * from orders
SELECT * from pizza
select * from  pizza_type
-- retrive the total number of orders placed
SELECt count(order_id) AS total_orders from orders

-- calculate total revenue generated from pizza sales

select * from pizza

SELECt sum(price) AS total_revenue from pizza

CREATE table order_details(
order_detail_id INT primary key,
order_id INT,
pizza_id VARCHAR(20),
quantity INT, 
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (pizza_id) REFERENCES pizza(pizza_id)
)

SELECt * FROM order_details




-- identify the higest price pizza

SELECT * FROM order_details
JOIN 
pizza
ON 
order_details.pizza_id=pizza.pizza_id
join 
orders
on 
orders.order_id=order_details.order_id
ORDER BY price DESC
LIMIT 1


-- identify the most common pizza size ordered

select size,count(order_id) AS total_pizzas
FROM 
order_details
join 
pizza
on
order_details.pizza_id=pizza.pizza_id
group by size
order by total_pizzas DESC
LIMIT 1


-- list the top 5 most ordered pizaa along with their quantities


SELECT 
    pizza.pizza_types,
    SUM(order_details.quantity) AS total_orders
FROM pizza
JOIN pizza_type ON pizza.pizza_types = pizza_type.pizza_types
JOIN order_details ON pizza.pizza_id = order_details.pizza_id
GROUP BY pizza.pizza_types
ORDER BY total_orders DESC
LIMIT 5

-- determain the distibution of orders by hours of the day

SELECT hour(order_time) As orders_time,
count(order_id) AS total_order
FROM orders
GROUP BY orders_time
ORDER BY orders_time ASC

-- join relevent tables to find catagory wise disribution of pizzas
SELECT catagory,count(pizza_name) AS toal_pizzas
FROM pizza_type
GROUP BY catagory

-- group the order by date and calculate the avarage orders of pizza order per day

SELECt ROUND(AVG(order_details.quantity),0) AS total_quantities,
order_date
FROM order_details
join
orders
on
order_details.order_id=orders.order_id
GROUP BY order_date


-- DEtermain the top 3 most ordered pizza based on their revenue

SELECt pizza_name,SUM(order_details.quantity*pizza.price) AS total_revenue
 FROM pizza
join
pizza_type
ON
pizza.pizza_types=pizza_type.pizza_types
join
order_details
ON
pizza.pizza_id=order_details.pizza_id
GROUP BY pizza.pizza_types
ORDER BY total_revenue DESC
LIMIT 3




-- calculate the cumulative revenue generated over time

SELECt orders.order_date,
ROUND(SUM(order_details.quantity*pizza.price),2) AS total_revenue
from pizza
join
order_details
ON
pizza.pizza_id=order_details.pizza_id
join
orders
on
order_details.order_id=orders.order_id
GROUP BY orders.order_date

-- Determain the top 3 most ordered pizza based on the revenue of each pizza catagory

SELECt pizza_type.catagory,pizza_type.pizza_name,
ROUND(SUM(order_details.quantity*pizza.price),2) AS total_revenue
from pizza
join
order_details
on
pizza.pizza_id=order_details.pizza_id
join
pizza_type
on
pizza.pizza_types=pizza_type.pizza_types
GROUP BY pizza_type.catagory,pizza_type.pizza_name
ORDER BY total_revenue DESC
LIMIT 3

SELECT catagory, pizza_name, total_revenue
FROM (
    SELECT 
        pizza_type.catagory,
        pizza_type.pizza_name,
        ROUND(SUM(order_details.quantity * pizza.price), 2) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY pizza_type.catagory ORDER BY SUM(order_details.quantity * pizza.price) DESC) AS rn
    FROM pizza
    JOIN order_details ON pizza.pizza_id = order_details.pizza_id
    JOIN pizza_type ON pizza.pizza_types = pizza_type.pizza_types
    GROUP BY pizza_type.catagory, pizza_type.pizza_name
) AS ranked
WHERE rn <= 3;


-- calculate the percentage contribution of each pizza type to total revenue


