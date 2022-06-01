--A. Pizza Metric

-- 1. How many pizzas were ordered?

select count(*) as total_pizza_ordered from pizza_runner.customer_orders_cleaned;

-- 2. How many unique customer orders were made?

select count(DISTINCT customer_id) as order_count from pizza_runner.customer_orders_cleaned;

-- 3. How many successful orders were delivered by each runner?

select runner_id, count(ORDER_ID) from pizza_runner.runner_orders_cleaned
where cancellation is Null
group by runner_id
order by runner_id;

-- 4. How many of each type of pizza was delivered?

select c.pizza_id, count(c.pizza_id) as pizza_delivered 
from pizza_runner.customer_orders_cleaned c 
left join pizza_runner.runner_orders_cleaned r
on c.order_id = r.ORDER_id
where r.cancellation is Null
group by c.pizza_id;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

select customer_id, 
      SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) as meatlovers,
      SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) as vegetarians from 
pizza_runner.customer_orders_cleaned c
group by customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?

select c.order_id, count(c.pizza_id) as total_pizza from 
pizza_runner.customer_orders_cleaned c
left join pizza_runner.runner_orders_cleaned r
on c.order_id = r.order_id
where r.cancellation is Null
group by order_id
order by total_pizza DESC
limit 1;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT
customer_id,
SUM(CASE WHEN (exclusions IS NOT NULL OR extras IS NOT NULL) THEN 1 ELSE 0 END) as changes,
SUM(CASE WHEN (exclusions IS NULL AND extras IS NULL) THEN 1 ELSE 0 END) as no_changes
FROM 
pizza_runner.customer_orders_cleaned
GROUP BY
customer_id
ORDER BY
customer_id;
-- 8. How many pizzas were delivered that had both exclusions and extras?

select count(a.order_id) as pizza_count
from pizza_runner.customer_orders_Cleaned a
left join pizza_runner.runner_orders_cleaned b
on a.order_id = b.order_id
where b.cancellation is Null and a.exclusions is not NULL and a.extras is not NULL;

-- 9. What was the total volume of pizzas ordered for each hour of the day?

select hour(order_Time) as hour, count(order_id) as total_pizza,
count(order_id)*100/ sum(count(*)) over()  as volume from 
pizza_runner.customer_orders_cleaned
group by hour
order by hour;

-- 10. What was the volume of orders for each day of the week?

select dayofweek(order_Time) as dayss, count(order_id) as total_pizza,
count(order_id)*100/ sum(count(*)) over()  as volume from 
pizza_runner.customer_orders_cleaned
group by dayss;


-- B. Runner and Customer Experience

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select week(REGISTRATION_DATE) as week, count(runner_id) as runners
from pizza_runner.runners
group by week
order by week;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

select a.runner_id , avg(timestampdiff(MINUTE,b.order_time,a.pickup_time)) as average_arrival_time
from pizza_runner.runner_orders_cleaned a 
left join pizza_runner.customer_orders_cleaned b 
on a.order_id = b.order_id
where a.cancellation is Null
group by a.runner_id;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

select a.runner_id , avg(timestampdiff(MINUTE,b.order_time,a.pickup_time)) as avg_time, 
count(b.pizza_id) as num_pizza
from pizza_runner.runner_orders_cleaned a 
left join pizza_runner.customer_orders_cleaned b 
on a.order_id = b.order_id
where a.cancellation is Null
group by a.runner_id;

-- 4. What was the average distance travelled for each customer?

select a.customer_id, avg(b.distance) as avg_distance
from pizza_runner.customer_orders_cleaned a 
left join pizza_runner.runner_orders_cleaned b 
on a.order_id = b.order_id
where b.cancellation is Null
group by a.customer_id;

--5. What was the difference between the longest and shortest delivery times for all orders?

with temp as (
    select min(duration) as shortest,
        max(duration) as longest
        from pizza_runner.runner_orders_cleaned
        where cancellation is Null
)

select (longest-shortest) as diff from temp;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

select runner_id, order_id, round(avg(distance*60/duration),2) as avg_speed, distance
from pizza_runner.runner_orders_cleaned
where cancellation is Null
group by runner_id, order_id
order by runner_id, order_id;

-- Speed is in increasing order for order_id but data is too low for any conclusion

-- 7. What is the successful delivery percentage for each runner?

select runner_id,
(sum(case when cancellation is Null then 1 else 0 end)*100/count(order_id)) as succesful_delivery_per
from pizza_runner.runner_orders_cleaned
group by runner_id;


-- C. Ingredient Optimisation

-- 1. What are the standard ingredients for each pizza?

select a.pizza_id, b.topping_name from pizza_runner.pizza_recipes_cleaned a
left join pizza_runner.pizza_toppings b
on a.toppings = b.topping_id;

-- 2. What was the most commonly added extra?

with temp as (
    select pizza_id, substr(extras,1,1) as extra1,
    substr(extras,4,1) as extra2
    from pizza_runner.customer_orders_cleaned
    where extras is not Null
),
temp2 as(
    select extra1 as extra from TEMP
    union all
    select extra2 as extra from TEMP where extra2 is not Null
)

select b.topping_name, count(a.extra) as counts 
from temp2 a
left join pizza_runner.pizza_toppings b
on a.extra = b.topping_id
group by b.topping_name
order by counts desc
limit 1;

-- 3. What was the most common exclusion?

with temp as (
    select pizza_id, substr(exclusions,1,1) as exclusion1,
    substr(exclusions,4,1) as exclusion2
    from pizza_runner.customer_orders_cleaned
    where exclusions is not Null
),
temp2 as(
    select exclusion1 as exclusion from TEMP
    union all
    select exclusion2 as exclusion from TEMP where exclusion2 is not Null
)

select b.topping_name, count(a.exclusion) as counts 
from temp2 a
left join pizza_runner.pizza_toppings b
on a.exclusion = b.topping_id
group by b.topping_name
order by counts desc
limit 1;


-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers


