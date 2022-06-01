# [8-Week SQL Challenge](https://8weeksqlchallenge.com/)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/sharma-ji/8weeksofsqlchallenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/sharma-ji?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/sharma-ji)


# 🍕 Case Study #2 - Pizza Runner
<p align="center">
<img src="https://github.com/sharma-ji/8weeksofsqlchallenge/blob/main/IMG/org-2.png" width=40% height=40%>

## 🛠️ Problem Statement

> Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”
> 
> Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so **Pizza Runner** was launched!
> 
> Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

---

## 📂 Dataset
Danny has shared with you 6 key datasets for this case study:

### **```runners```**
<details>
<summary>
View table
</summary>

The runners table shows the **```registration_date```** for each new runner.


|runner_id|registration_date|
|---------|-----------------|
|1        |1/1/2021         |
|2        |1/3/2021         |
|3        |1/8/2021         |
|4        |1/15/2021        |

</details>


### **```customer_orders```**

<details>
<summary>
View table
</summary>

Customer pizza orders are captured in the **```customer_orders```** table with 1 row for each individual pizza that is part of the order.

|order_id|customer_id|pizza_id|exclusions|extras|order_time        |
|--------|---------|--------|----------|------|------------------|
|1  |101      |1       |          |      |44197.75349537037 |
|2  |101      |1       |          |      |44197.79226851852 |
|3  |102      |1       |          |      |44198.9940162037  |
|3  |102      |2       |          |*null* |44198.9940162037  |
|4  |103      |1       |4         |      |44200.558171296296|
|4  |103      |1       |4         |      |44200.558171296296|
|4  |103      |2       |4         |      |44200.558171296296|
|5  |104      |1       |null      |1     |44204.87533564815 |
|6  |101      |2       |null      |null  |44204.877233796295|
|7  |105      |2       |null      |1     |44204.88922453704 |
|8  |102      |1       |null      |null  |44205.99621527778 |
|9  |103      |1       |4         |1, 5  |44206.47429398148 |
|10 |104      |1       |null      |null  |44207.77417824074 |
|10 |104      |1       |2, 6      |1, 4  |44207.77417824074 |

</details>

### **```runner_orders```**

<details>
<summary>
View table
</summary>

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The **```pickup_time```** is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. 

The **```distance```** and **```duration```** fields are related to how far and long the runner had to travel to deliver the order to the respective customer.



|order_id|runner_id|pickup_time|distance  |duration|cancellation      |
|--------|---------|-----------|----------|--------|------------------|
|1       |1        |1/1/2021 18:15|20km      |32 minutes|                  |
|2       |1        |1/1/2021 19:10|20km      |27 minutes|                  |
|3       |1        |1/3/2021 0:12|13.4km    |20 mins |*null*             |
|4       |2        |1/4/2021 13:53|23.4      |40      |*null*             |
|5       |3        |1/8/2021 21:10|10        |15      |*null*             |
|6       |3        |null       |null      |null    |Restaurant Cancellation|
|7       |2        |1/8/2020 21:30|25km      |25mins  |null              |
|8       |2        |1/10/2020 0:15|23.4 km   |15 minute|null              |
|9       |2        |null       |null      |null    |Customer Cancellation|
|10      |1        |1/11/2020 18:50|10km      |10minutes|null              |

</details>

### **```pizza_names```**

<details>
<summary>
View table
</summary>

|pizza_id|pizza_name|
|--------|----------|
|1       |Meat Lovers|
|2       |Vegetarian|

</details>

### **```pizza_recipes```**

<details>
<summary>
View table
</summary>

Each **```pizza_id```** has a standard set of **```toppings```** which are used as part of the pizza recipe.


|pizza_id|toppings |
|--------|---------|
|1       |1, 2, 3, 4, 5, 6, 8, 10| 
|2       |4, 6, 7, 9, 11, 12| 

</details>

### **```pizza_toppings```**

<details>
<summary>
View table
</summary>

This table contains all of the **```topping_name```** values with their corresponding **```topping_id```** value.


|topping_id|topping_name|
|----------|------------|
|1         |Bacon       | 
|2         |BBQ Sauce   | 
|3         |Beef        |  
|4         |Cheese      |  
|5         |Chicken     |     
|6         |Mushrooms   |  
|7         |Onions      |     
|8         |Pepperoni   | 
|9         |Peppers     |   
|10        |Salami      | 
|11        |Tomatoes    | 
|12        |Tomato Sauce|

</details>

---

## ♻️ Data Preprocessing

### **Data Issues**

Data issues in the existing schema include:

* **```customer_orders``` table**
  - ```null``` values entered as text
  - using both ```NaN``` and ```null``` values
* **```runner_orders``` table**
  - ```null``` values entered as text
  - using both ```NaN``` and ```null``` values
  - units manually entered in ```distance``` and ```duration``` columns

### **Data Cleaning**

**```customer_orders```**
- Converting ```null``` and ```NaN``` values into blanks ```''``` in ```exclusions``` and ```extras```
  - Blanks indicate that the customer requested no extras/exclusions for the pizza, whereas ```null``` values would be ambiguous.
- Saving the transformations in a temporary table
  - We want to avoid permanently changing the raw data via ```UPDATE``` commands if possible.

**```runner_orders```**

- Converting ```'null'``` text values into null values for ```pickup_time```, ```distance``` and ```duration```
- Extracting only numbers and decimal spaces for the distance and duration columns
  - Use regular expressions and ```NULLIF``` to convert non-numeric entries to null values
- Converting blanks, ```'null'``` and ```NaN``` into null values for cancellation
- Saving the transformations in a temporary table

**Result:**

<details>
<summary> 
updated_customer_orders
</summary>

|order_id|customer_id|pizza_id|exclusions|extras|order_time              |
|--------|-----------|--------|----------|------|------------------------|
|1       |101        |1       |          |      |2020-01-01T18:05:02.000Z|
|2       |101        |1       |          |      |2020-01-01T19:00:52.000Z|
|3       |102        |1       |          |      |2020-01-02T12:51:23.000Z|
|3       |102        |2       |          |      |2020-01-02T12:51:23.000Z|
|4       |103        |1       |4         |      |2020-01-04T13:23:46.000Z|
|4       |103        |1       |4         |      |2020-01-04T13:23:46.000Z|
|4       |103        |2       |4         |      |2020-01-04T13:23:46.000Z|
|5       |104        |1       |          |1     |2020-01-08T21:00:29.000Z|
|6       |101        |2       |          |      |2020-01-08T21:03:13.000Z|
|7       |105        |2       |          |1     |2020-01-08T21:20:29.000Z|
|8       |102        |1       |          |      |2020-01-09T23:54:33.000Z|
|9       |103        |1       |4         |1, 5  |2020-01-10T11:22:59.000Z|
|10      |104        |1       |          |      |2020-01-11T18:34:49.000Z|
|10      |104        |1       |2, 6      |1, 4  |2020-01-11T18:34:49.000Z|

</details>

<details>
<summary> 
updated_runner_orders
</summary>

| order_id | runner_id | pickup_time         | distance | duration | cancellation            |
|----------|-----------|---------------------|----------|----------|-------------------------|
| 1        | 1         | 2020-01-01 18:15:34 | 20       | 32       |                         |
| 2        | 1         | 2020-01-01 19:10:54 | 20       | 27       |                         |
| 3        | 1         | 2020-01-02 00:12:37 | 13.4     | 20       |                         |
| 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40       |                         |
| 5        | 3         | 2020-01-08 21:10:57 | 10       | 15       |                         |
| 6        | 3         |                     |          |          | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45 | 25       | 25       |                         |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4     | 15       |                         |
| 9        | 2         |                     |          |          | Customer Cancellation   |
| 10       | 1         | 2020-01-11 18:50:20 | 10       | 10       |                         |

</details>

---

## 🚀 Solutions

<details>
<summary> 
Pizza Metrics
</summary>

### **Q1. How many pizzas were ordered?**
```sql
select count(*) as total_pizza_ordered from pizza_runner.customer_orders_cleaned;
```
|total_pizza_ordered|
|-------------------|
|14                 |

### **Q2. How many unique customer orders were made?**
```sql
select count(DISTINCT customer_id) as order_count from pizza_runner.customer_orders_cleaned;
```
|order_count|
|-----------|
|5          |


### **Q3. How many successful orders were delivered by each runner?**
```sql
select runner_id, count(ORDER_ID) from pizza_runner.runner_orders_cleaned
where cancellation is Null
group by runner_id
order by runner_id;
```

| runner_id | successful_orders |
|-----------|-------------------|
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |


### **Q4. How many of each type of pizza was delivered?**
```SQL
select c.pizza_id, count(c.pizza_id) as pizza_delivered 
from pizza_runner.customer_orders_cleaned c 
left join pizza_runner.runner_orders_cleaned r
on c.order_id = r.ORDER_id
where r.cancellation is Null
group by c.pizza_id;
```

| pizza_id | pizza_type_count |
|----------|------------------|
| 1        | 9                |
| 2        | 3                |


### **Q5. How many Vegetarian and Meatlovers were ordered by each customer?**
```SQL
select customer_id, 
      SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) as meatlovers,
      SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) as vegetarians from 
pizza_runner.customer_orders_cleaned c
group by customer_id;
```

| customer_id | meatlovers | vegetarians |
|-------------|------------|-------------|
| 101         | 2          | 1           |
| 102         | 2          | 1           |
| 103         | 3          | 1           |
| 104         | 3          | 0           |
| 105         | 0          | 1           |


### **Q6. What was the maximum number of pizzas delivered in a single order?**
```SQL
select c.order_id, count(c.pizza_id) as total_pizza from 
pizza_runner.customer_orders_cleaned c
left join pizza_runner.runner_orders_cleaned r
on c.order_id = r.order_id
where r.cancellation is Null
group by order_id
order by total_pizza DESC
limit 1;
 ``` 

| order_id | total_pizza |
|----------|-------------|
| 4        | 3           |


### **Q7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```SQL
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
```

| customer_id | changes | no_changes |
|-------------|---------|------------|
| 101         | 0       | 3          |
| 102         | 0       | 3          |
| 103         | 4       | 0          |
| 104         | 2       | 1          |
| 105         | 1       | 0          |



### **Q8. How many pizzas were delivered that had both exclusions and extras?**
```SQL
select count(a.order_id) as pizza_count
from pizza_runner.customer_orders_Cleaned a
left join pizza_runner.runner_orders_cleaned b
on a.order_id = b.order_id
where b.cancellation is Null and a.exclusions is not NULL and a.extras is not NULL;

```  

| pizza_count |
|-------------|
| 1           |


### **Q9. What was the total volume of pizzas ordered for each hour of the day?**
```SQL
SELECT
  DATE_PART('hour', order_time::TIMESTAMP) AS hour_of_day,
  COUNT(*) AS pizza_count
FROM updated_customer_orders
WHERE order_time IS NOT NULL
GROUP BY hour_of_day
ORDER BY hour_of_day;
```

| hour | total_pizza | volume  |
|------|-------------|---------|
| 11   | 1           | 7.1429  |
| 13   | 3           | 21.4286 |
| 18   | 3           | 21.4286 |
| 19   | 1           | 7.1429  |
| 21   | 3           | 21.4286 |
| 23   | 3           | 21.4286 |

### **Q10. What was the volume of orders for each day of the week?**
```SQL
select dayofweek(order_Time) as dayss, count(order_id) as total_pizza,
count(order_id)*100/ sum(count(*)) over()  as volume from 
pizza_runner.customer_orders_cleaned
group by dayss;
```

| dayss | total_pizza | volume  |
|-------|-------------|---------|
| 4     | 5           | 35.7143 |
| 5     | 3           | 21.4286 |
| 7     | 5           | 35.7143 |
| 6     | 1           | 7.1429  |

</details>

<details>
<summary>
Runner and Customer Experience
</summary>

### **Q1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**
```SQL
select week(REGISTRATION_DATE) as week, count(runner_id) as runners
from pizza_runner.runners
group by week
order by week;
```

| week | runners |
|------|---------|
| 0    | 1       |
| 1    | 2       |
| 2    | 1       |

### **Q2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**
```SQL
select a.runner_id , avg(timestampdiff(MINUTE,b.order_time,a.pickup_time)) as average_arrival_time
from pizza_runner.runner_orders_cleaned a 
left join pizza_runner.customer_orders_cleaned b 
on a.order_id = b.order_id
where a.cancellation is Null
group by a.runner_id;
```
| runner_id | average_arrival_time |
|-----------|----------------------|
| 1         | 275.3333             |
| 2         | 23.4000              |
| 3         | 10.0000              |

### **Q3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**
```SQL
select a.runner_id , avg(timestampdiff(MINUTE,b.order_time,a.pickup_time)) as avg_time, 
count(b.pizza_id) as num_pizza
from pizza_runner.runner_orders_cleaned a 
left join pizza_runner.customer_orders_cleaned b 
on a.order_id = b.order_id
where a.cancellation is Null
group by a.runner_id;
```

| runner_id | avg_time | num_pizza |
|-----------|----------|-----------|
| 1         | 275.3333 | 6         |
| 2         | 23.4000  | 5         |
| 3         | 10.0000  | 1         |

### **Q4. What was the average distance travelled for each customer?**
```SQL
select a.customer_id, avg(b.distance) as avg_distance
from pizza_runner.customer_orders_cleaned a 
left join pizza_runner.runner_orders_cleaned b 
on a.order_id = b.order_id
where b.cancellation is Null
group by a.customer_id;
```

| customer_id | avg_distance |
|-------------|--------------|
| 101         | 20.000000    |
| 102         | 16.333333    |
| 103         | 23.000000    |
| 104         | 10.000000    |
| 105         | 25.000000    |

### **Q5. What was the difference between the longest and shortest delivery times for all orders?**
```SQL
with temp as (
    select min(duration) as shortest,
        max(duration) as longest
        from pizza_runner.runner_orders_cleaned
        where cancellation is Null
)

select (longest-shortest) as diff from temp;
```

| diff |
|------|
| 30   |

### **Q6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**
```SQL
select runner_id, order_id, round(avg(distance*60/duration),2) as avg_speed, distance
from pizza_runner.runner_orders_cleaned
where cancellation is Null
group by runner_id, order_id
order by runner_id, order_id;
```

| runner_id | order_id | avg_speed | distance |
|-----------|----------|-----------|----------|
| 1         | 1        | 37.5      | 20.00    |
| 1         | 2        | 44.44     | 20.00    |
| 1         | 3        | 39        | 13.00    |
| 1         | 10       | 60        | 10.00    |
| 2         | 4        | 34.5      | 23.00    |
| 2         | 7        | 60        | 25.00    |
| 2         | 8        | 92        | 23.00    |
| 3         | 5        | 40        | 10.00    |

**Finding:**
> *Speed is in increasing order for order_id but data is too low for any conclusion*  

### **Q7. What is the successful delivery percentage for each runner?**
```sql
select runner_id,
(sum(case when cancellation is Null then 1 else 0 end)*100/count(order_id)) as succesful_delivery_per
from pizza_runner.runner_orders_cleaned
group by runner_id;
```

| runner_id | succesful_delivery_per |
|-----------|------------------------|
| 1         | 100.0000               |
| 2         | 75.0000                |
| 3         | 50.0000                |


</details>

<details>
<summary>
Ingredient Optimisation
</summary>

### **Q1. What are the standard ingredients for each pizza?**
```sql
select a.pizza_id, b.topping_name from pizza_runner.pizza_recipes_cleaned a
left join pizza_runner.pizza_toppings b
on a.toppings = b.topping_id;
```
| pizza_id | topping_name |
|----------|--------------|
| 1        | Bacon        |
| 1        | BBQ Sauce    |
| 1        | Beef         |
| 1        | Cheese       |
| 1        | Chicken      |
| 1        | Mushrooms    |
| 1        | Pepperoni    |
| 1        | Salami       |
| 2        | Cheese       |
| 2        | Mushrooms    |
| 2        | Onions       |
| 2        | Peppers      |
| 2        | Tomatoes     |
| 2        | Tomato Sauce |

### **Q2. What was the most commonly added extra?**
```sql
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
```

| topping_name | counts |
|--------------|--------|
| Bacon        | 4      |

### **Q3. What was the most common exclusion?**
```sql
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
```
| topping_name | counts |
|--------------|--------|
| Cheese       | 4      |


---
<p>&copy; 2022 Mukul Sharma</p>