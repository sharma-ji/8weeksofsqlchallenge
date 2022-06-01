-- CREATE DATABASE PIZZA_RUNNER;
-- CREATE TABLE pizza_runner.runners (
--   runner_id INTEGER,
--   registration_date DATE
-- );

-- INSERT INTO pizza_runner.runners
--   (runner_id, registration_date)
-- VALUES
--   (1, '2021-01-01'),
--   (2, '2021-01-03'),
--   (3, '2021-01-08'),
--   (4, '2021-01-15');

-- CREATE TABLE pizza_runner.customer_orders (
--   order_id INTEGER,
--   customer_id INTEGER,
--   pizza_id INTEGER,
--   exclusions VARCHAR(4),
--   extras VARCHAR(4),
--   order_time TIMESTAMP
-- );

-- INSERT INTO pizza_runner.customer_orders
--   (order_id, customer_id, pizza_id, exclusions, extras, order_time)
-- VALUES
--   ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
--   ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
--   ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
--   ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
--   ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
--   ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
--   ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
--   ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
--   ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
--   ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
--   ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
--   ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
--   ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
--   ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


-- CREATE TABLE pizza_runner.runner_orders (
--   order_id INTEGER,
--   runner_id INTEGER,
--   pickup_time VARCHAR(19),
--   distance VARCHAR(7),
--   duration VARCHAR(10),
--   cancellation VARCHAR(23)
-- );


-- INSERT INTO pizza_runner.runner_orders
--   (order_id, runner_id, pickup_time, distance, duration, cancellation)
-- VALUES
--   ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
--   ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
--   ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
--   ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
--   ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
--   ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
--   ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
--   ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
--   ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
--   ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


-- CREATE TABLE pizza_runner.pizza_names (
--   pizza_id INTEGER,
--   pizza_name TEXT
-- );
-- INSERT INTO pizza_runner.pizza_names
--   (pizza_id, pizza_name)
-- VALUES
--   (1, 'Meatlovers'),
--   (2, 'Vegetarian');

-- CREATE TABLE pizza_runner.pizza_recipes (
--   pizza_id INTEGER,
--   toppings TEXT
-- );

-- INSERT INTO pizza_runner.pizza_recipes
--   (pizza_id, toppings)
-- VALUES
--   (1, '1, 2, 3, 4, 5, 6, 8, 10'),
--   (2, '4, 6, 7, 9, 11, 12');

-- CREATE TABLE pizza_runner.pizza_recipes_cleaned (
--   pizza_id INTEGER,
--   toppings TEXT
-- );

-- INSERT INTO pizza_runner.pizza_recipes_cleaned
--   (pizza_id, toppings)
-- VALUES
--   (1, '1'), (1,'2'), (1,'3'), (1,'4'), (1,'5'), (1,'6'), 
--   (1,'8'), (1,'10'),
--   (2, '4'), (2,'6'), (2,'7'), (2,'9'), (2,'11'), 
--   (2,'12');


-- CREATE TABLE pizza_runner.pizza_toppings (
--   topping_id INTEGER,
--   topping_name TEXT
-- );

-- INSERT INTO pizza_runner.pizza_toppings
--   (topping_id, topping_name)
-- VALUES
--   (1, 'Bacon'),
--   (2, 'BBQ Sauce'),
--   (3, 'Beef'),
--   (4, 'Cheese'),
--   (5, 'Chicken'),
--   (6, 'Mushrooms'),
--   (7, 'Onions'),
--   (8, 'Pepperoni'),
--   (9, 'Peppers'),
--   (10, 'Salami'),
--   (11, 'Tomatoes'),
--   (12, 'Tomato Sauce');

-- CREATE TABLE PIZZA_RUNNER.customer_orders_cleaned with temp AS(
--     select order_id,customer_id, pizza_id,
--     case when exclusions = 'null' or exclusions = '' then NULL
--     else exclusions end as exclusions,
--     case when extras in ('', 'NaN', 'null') then NULL
--     else extras end as extras,
--     order_time
--     from pizza_runner.customer_orders
-- )
-- select ROW_NUMBER() Over (ORDER BY order_id, pizza_id) as row_number_order,
--  order_id,customer_id, pizza_id,exclusions, extras,order_time
--  from temp;

    -- CREATE TABLE pizza_runner.runner_orders_cleaned AS WITH temp AS (
    --   SELECT
    --     order_id,
    --     runner_id,
    --     CAST(
    --       CASE
    --         WHEN pickup_time = 'null' THEN NULL
    --         ELSE pickup_time
    --       END AS DATETIME
    --     ) AS pickup_time,
    --     CASE
    --       WHEN distance = '' THEN NULL
    --       WHEN distance = 'null' THEN NULL
    --       ELSE distance
    --     END as distance,
    --     CASE
    --       WHEN duration = '' THEN NULL
    --       WHEN duration = 'null' THEN NULL
    --       ELSE duration
    --     END as duration,
    --     CASE
    --       WHEN cancellation = '' THEN NULL
    --       WHEN cancellation = 'null' THEN NULL
    --       ELSE cancellation
    --     END as cancellation
    --   FROM
    --     pizza_runner.runner_orders
    -- )
    -- SELECT
    --   order_id,
    --   runner_id,
    --   CASE WHEN order_id = '3' THEN (pickup_time + INTERVAL 13 HOUR) ELSE pickup_time END AS pickup_time,
    --   CAST( regexp_replace(distance, '[a-z]+', '' ) AS DECIMAL(5,2) ) AS distance,
    -- 	regexp_replace(duration, '[a-z]+', '' ) AS duration,
    -- 	cancellation
    -- FROM
    --   temp;


