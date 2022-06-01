-- A. Customer Journey

with temp as (
    select distinct customer_id from foodie_fi.subscriptions
ORDER BY RAND()
LIMIT 8
)

select a.customer_id, a.start_date, b.plan_name,b.price from
(select * from foodie_fi.subscriptions where customer_id in (select * from temp)) a
left join foodie_fi.plans b
on a.plan_id = b.plan_id;
 
-- ONly 1 in 8 customers leave us, 6 in 8 people opt for pro plan

-- B. Data Analysis Questions

-- 1. How many customers has Foodie-Fi ever had?

select count(distinct customer_id) as total_customers from foodie_fi.subscriptions;

-- 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

select month(start_date) as month, count(distinct customer_id) as customers
from foodie_fi.subscriptions 
where plan_id = 0
group by month
order by month;


-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

select b.plan_name, count(a.customer_id)
from foodie_fi.subscriptions a 
left join foodie_fi.plans b
on a.plan_id = b.plan_id
where a.start_date > '2020-12-31'
group by b.plan_name;

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

select 
sum(case when plan_id = 4 then 1 else 0 end) as customer_counts,
round(sum(case when plan_id = 4 then 1 else 0 end)*100/count(distinct customer_id),1) as customer_perc
from foodie_fi.subscriptions;

-- 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

with temp as(select customer_id, start_date, plan_id,
lead(plan_id,1) over( PARTITION BY Customer_id order by start_Date) plan_id2
from foodie_fi.subscriptions
order by customer_id, start_date)


select
sum(case when plan_id = 0 and plan_id2 = 4 then 1 else 0 end) as count_customers,
round(sum(case when plan_id = 0 and plan_id2 = 4 then 1 else 0 end)*100/count(distinct customer_id),1) as customer_perc
from temp;


-- 6. What is the number and percentage of customer plans after their initial free trial?
with temp as(select customer_id, start_date, plan_id,
lead(plan_id,1) over( PARTITION BY Customer_id order by plan_id) plan_id2
from foodie_fi.subscriptions)

select plan_id2, count(*) as customer_count,
count(*)*100/(select count(distinct customer_id) from temp) as perc
from temp
where plan_id = 0
group by plan_id2;

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

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


Check it 

-- 8.How many customers have upgraded to an annual plan in 2020?

select count(distinct customer_id) as unique_customer
from foodie_fi.subscriptions
where plan_id = 3 and year(start_date)=2020;

-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

with temp as (
    select a.customer_id, a.plan_id, a.start_date, b.plan_id as next_plan, 
    b.start_date as next_date
    from foodie_fi.subscriptions a
    left join foodie_fi.subscriptions b on 
    a.customer_id = b.customer_id
    where a.plan_id = 0 and b.plan_id = 3
)

select avg(datediff(next_date,start_date)) from temp;

-- 10 Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

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


-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?


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


-- C. Challenge Payment Question



-- D. Outside The Box Questions
-- 1. How would you calculate the rate of growth for Foodie-Fi?

-- Solution : By calcualting month on churn rate, month on month new trial customers rate

-- 2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?
-- Solution: Active User Base

-- 3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?
-- Solution: customers down grading their subscriptions

-- 4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?
-- Solution: How many shows were irrelevant, how is recommendation and search engine working,
-- is UI the issue. Is the lngth of content optimal, the language or speed to speaker is appropriate

-- 5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?
-- Solution: By introducing short length content, introducing exotic dishes show and then doing A/B testing