# [8-Week SQL Challenge](https://8weeksqlchallenge.com/)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/sharma-ji/8weeksofsqlchallenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/sharma-ji?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/sharma-ji)


# 🥑 Case Study #3 - Foodie-Fi
<p align="center">
<img src="https://github.com/sharma-ji/8weeksofsqlchallenge/blob/main/IMG/org-3.png" width=40% height=40%>


## 🛠️ Problem Statement

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

## 📂 Dataset
Danny has shared with you 2 key datasets for this case study:

### **```plan```**

<details>
<summary>
View table
</summary>

The plan table shows which plans customer can choose to join Foodie-Fi when they first sign up.

* **Trial:** can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel

* **Basic plan:** limited access and can only stream user videos
* **Pro plan** no watch time limits and video are downloadable with 2 subscription options: **monthly** and **annually**


| "plan_id" | "plan_name"     | "price" |
|-----------|-----------------|---------|
| 0         | "trial"         | 0.00    |
| 1         | "basic monthly" | 9.90    |
| 2         | "pro monthly"   | 19.90   |
| 3         | "pro annual"    | 199.00  |
| 4         | "churn"         | NULL    |


</details>


### **```subscriptions```**


<details>
<summary>
View table
</summary>

Customer subscriptions show the exact date where their specific ```plan_id``` starts.

If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the ```start_date``` in the ```subscriptions``` table will reflect the date that the actual plan changes.

In this part, I will display the first 20 rows of this dataset since the original one is super long:


| "customer_id" | "plan_id" | "start_date" |
|---------------|-----------|--------------|
| 1             | 0         | "2020-08-01" |
| 1             | 1         | "2020-08-08" |
| 2             | 0         | "2020-09-20" |
| 2             | 3         | "2020-09-27" |
| 3             | 0         | "2020-01-13" |
| 3             | 1         | "2020-01-20" |
| 4             | 0         | "2020-01-17" |
| 4             | 1         | "2020-01-24" |
| 4             | 4         | "2020-04-21" |
| 5             | 0         | "2020-08-03" |
| 5             | 1         | "2020-08-10" |
| 6             | 0         | "2020-12-23" |
| 6             | 1         | "2020-12-30" |
| 6             | 4         | "2021-02-26" |
| 7             | 0         | "2020-02-05" |
| 7             | 1         | "2020-02-12" |
| 7             | 2         | "2020-05-22" |
| 8             | 0         | "2020-06-11" |
| 8             | 1         | "2020-06-18" |
| 8             | 2         | "2020-08-03" |


</details>



## 🚀 Solutions

<details>
<summary> 
Customer Journey
</summary>

### **Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey. Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!**

```SQL
with temp as (
    select distinct customer_id from foodie_fi.subscriptions
ORDER BY RAND()
LIMIT 8
)

select a.customer_id, a.start_date, b.plan_name,b.price from
(select * from foodie_fi.subscriptions where customer_id in (select * from temp)) a
left join foodie_fi.plans b
on a.plan_id = b.plan_id;
```


| customer_id | start_date | plan_name     | price  |
|-------------|------------|---------------|--------|
| 35          | 2020-09-03 | trial         | 0.00   |
| 35          | 2020-09-10 | pro monthly   | 19.90  |
| 120         | 2020-05-14 | trial         | 0.00   |
| 120         | 2020-05-21 | pro monthly   | 19.90  |
| 120         | 2020-09-21 | pro annual    | 199.00 |
| 313         | 2020-01-15 | trial         | 0.00   |
| 313         | 2020-01-22 | basic monthly | 9.90   |
| 313         | 2020-06-29 | pro annual    | 199.00 |
| 329         | 2020-04-26 | trial         | 0.00   |
| 329         | 2020-05-03 | churn         | null   |
| 691         | 2020-06-15 | trial         | 0.00   |
| 691         | 2020-06-22 | pro monthly   | 19.90  |
| 691         | 2020-11-22 | pro annual    | 199.00 |
| 744         | 2020-04-15 | trial         | 0.00   |
| 744         | 2020-04-22 | pro monthly   | 19.90  |
| 744         | 2020-09-11 | churn         | null   |
| 780         | 2020-08-13 | trial         | 0.00   |
| 780         | 2020-08-20 | basic monthly | 9.90   |
| 780         | 2020-12-27 | pro monthly   | 19.90  |
| 780         | 2021-04-27 | pro annual    | 199.00 |
| 942         | 2020-12-06 | trial         | 0.00   |
| 942         | 2020-12-13 | basic monthly | 9.90   |
| 942         | 2021-01-18 | churn         | null   |

> Only 1 in 8 customers leave us, 6 in 8 people opt for pro plan

</details>

<details>
<summary> 
Data Analysis Questions
</summary>

### **Q1. How many customers has Foodie-Fi ever had?**
```sql
select count(distinct customer_id) as total_customers from foodie_fi.subscriptions;

```
|total_customer |
|---------------|
|1000           |

### **Q2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value**

```sql
select month(start_date) as month, count(distinct customer_id) as customers
from foodie_fi.subscriptions 
where plan_id = 0
group by month
order by month;
```
| month | customers |
|-------|-----------|
| 1     | 88        |
| 2     | 68        |
| 3     | 94        |
| 4     | 81        |
| 5     | 88        |
| 6     | 79        |
| 7     | 89        |
| 8     | 88        |
| 9     | 87        |
| 10    | 79        |
| 11    | 75        |
| 12    | 84        |



### **Q3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name**

```sql
select b.plan_name, count(a.customer_id)
from foodie_fi.subscriptions a 
left join foodie_fi.plans b
on a.plan_id = b.plan_id
where a.start_date > '2020-12-31'
group by b.plan_name;
```

| plan_name     | count(a.customer_id) |
|---------------|----------------------|
| churn         | 71                   |
| pro monthly   | 60                   |
| pro annual    | 63                   |
| basic monthly | 8                    |


### **Q4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?**
```SQL
select 
sum(case when plan_id = 4 then 1 else 0 end) as customer_counts,
round(sum(case when plan_id = 4 then 1 else 0 end)*100/count(distinct customer_id),1) as customer_perc
from foodie_fi.subscriptions;
```

| customer_counts | customer_perc |
|-----------------|---------------|
| 307             | 30.7          |


### **Q5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?**
```SQL
with temp as(select customer_id, start_date, plan_id,
lead(plan_id,1) over( PARTITION BY Customer_id order by start_Date) plan_id2
from foodie_fi.subscriptions
order by customer_id, start_date)


select
sum(case when plan_id = 0 and plan_id2 = 4 then 1 else 0 end) as count_customers,
round(sum(case when plan_id = 0 and plan_id2 = 4 then 1 else 0 end)*100/count(distinct customer_id),1) as customer_perc
from temp;

```

| count_customers | customer_perc |
|-----------------|---------------|
| 92              | 9.2           |


### **Q6. What is the number and percentage of customer plans after their initial free trial?**
```SQL
with temp as(select customer_id, start_date, plan_id,
lead(plan_id,1) over( PARTITION BY Customer_id order by plan_id) plan_id2
from foodie_fi.subscriptions)

select plan_id2, count(*) as customer_count,
count(*)*100/(select count(distinct customer_id) from temp) as perc
from temp
where plan_id = 0
group by plan_id2;
 ``` 

| plan_id2 | customer_count | perc    |
|----------|----------------|---------|
| 1        | 546            | 54.6000 |
| 3        | 37             | 3.7000  |
| 2        | 325            | 32.5000 |
| 4        | 92             | 9.2000  |


### **What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?**
```SQL
with temp as(
    select a.*, b.plan_name from foodie_fi.subscriptions a
    left join foodie_fi.plans B
    on a.plan_id = b.plan_id
    where a.start_date <= '2020-12-31'
)
select plan_name, count(customer_id),
count(distinct customer_id)*100/(select count(distinct customer_id) from temp) as perc
from TEMP
group by plan_name;
```

| plan_name     | count(customer_id) | perc     |
|---------------|--------------------|----------|
| basic monthly | 538                | 53.8000  |
| churn         | 236                | 23.6000  |
| pro annual    | 195                | 19.5000  |
| pro monthly   | 479                | 47.9000  |
| trial         | 1000               | 100.0000 |



### **Q8. How many customers have upgraded to an annual plan in 2020?**
```SQL
select count(distinct customer_id) as unique_customer
from foodie_fi.subscriptions
where plan_id = 3 and year(start_date)=2020;

```  

| unique_customer |
|-----------------|
| 195             |



### **Q9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?**
```SQL
with temp as (
    select a.customer_id, a.plan_id, a.start_date, b.plan_id as next_plan, 
    b.start_date as next_date
    from foodie_fi.subscriptions a
    left join foodie_fi.subscriptions b on 
    a.customer_id = b.customer_id
    where a.plan_id = 0 and b.plan_id = 3
)

select avg(datediff(next_date,start_date)) from temp;
```

| avg(datediff(next_date,start_date)) |
|-------------------------------------|
| 104.6202                            |

### **Q10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)**
```SQL
with temp as (
    select a.customer_id, a.plan_id, a.start_date as start_date, b.plan_id as next_plan, 
    b.start_date as next_date, datediff(b.start_date, a.start_date) as diff
    from foodie_fi.subscriptions a
    left join foodie_fi.subscriptions b on 
    a.customer_id = b.customer_id
    where a.plan_id = 0 and b.plan_id = 3
)


select 
case when diff <= 30 then '0-30'
when diff <= 60 and diff > 30 then '31-60'
when diff <= 90 and diff > 60 then '61-90'
when diff <= 120 and diff > 90 then '91-120'
when diff <= 150 and diff > 120 then '121-150'
when diff <= 180 and diff > 150 then '151-180'
when diff <= 210 and diff > 180 then '181-210'
when diff <= 240 and diff > 210 then '211-240'
when diff <= 270 and diff > 240 then '241-270'
when diff <= 300 and diff > 270 then '271-300'
when diff <= 330 and diff > 300 then '301-330'
when diff <= 360 and diff > 330 then '331-360'
else 'Null' end as bkt, count(customer_id) as cnt
from temp
group by bkt
;
```

| bkt     | cnt |
|---------|-----|
| 0-30    | 49  |
| 121-150 | 42  |
| 61-90   | 34  |
| 31-60   | 24  |
| 151-180 | 36  |
| 91-120  | 35  |
| 181-210 | 26  |
| 331-360 | 1   |
| 241-270 | 5   |
| 211-240 | 4   |
| 271-300 | 1   |
| 301-330 | 1   |

### **Q11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?**

```SQL
with temp as (
    select a.customer_id, a.plan_id, a.start_date as start_date, b.plan_id as next_plan, 
    b.start_date as next_date
    from foodie_fi.subscriptions a
    left join foodie_fi.subscriptions b on 
    a.customer_id = b.customer_id
    where a.plan_id = 2 and b.plan_id = 1
    and a.start_date<=b.start_date 
    and year(b.start_date) = 2020
)
select * from temp;
```

</details>

<details>
<summary>
Outside The Box Questions
</summary>

### **Q1. How would you calculate the rate of growth for Foodie-Fi?**

> By calcualting month on churn rate, month on month new trial customers rate

### **Q2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?**

> Active User Base

### **Q3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?**

> customers down grading their subscriptions

### **Q4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?**

> How many shows were irrelevant, how is recommendation and search engine working, is UI the issue. Is the lngth of content optimal, the language or speed to speaker is appropriate


### **Q5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?**

> By introducing short length content, introducing exotic dishes show and then doing A/B testing

---
<p>&copy; 2022 Mukul Sharma</p>