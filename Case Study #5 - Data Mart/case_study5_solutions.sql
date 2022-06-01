-- 1. Data Cleansing Steps

-- Convert the week_date to a DATE format

-- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
-- Add a month_number with the calendar month for each week_date value as the 3rd column
-- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
-- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value
-- Add a new demographic column using the following mapping for the first letter in the segment values
-- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns
-- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record

create View weekly_sales_cleaned as

with temp_cte as(
    select 
    cast(
    (case when length(week_date) = 6 then concat('20',substr(week_date,5,2), '-0', substr(week_date,3,1), '-0', substr(week_date,1,1))
    when length(week_date) = 7 then concat('20', substr(week_date, 6,2), '-0', substr(week_date,4,1),'-', substr(week_date, 1,2))
    end
    ) as Date) week_date,YEARWEEK(WEEK_DATE) as week_number, month(week_date) as month_number,
    year(week_Date) as calender_year,
    case when length(segment) = 2 then 
        case when substr(segment,2,1) = "1" then "Young Adults"
            when substr(segment,2,1) = "2" then "Middle Aged"
            when substr(segment,2,1) = "3" or substr(segment,2,1) = "4" then "	Retirees"
        end
    else "unknown" END as age_band,
    case when length(segment) = 2 then 
        case when substr(segment,1,1) = "C" then "Couples"
            when substr(segment,1,1) = "F" then "Families"
        end
    else "unknown" END as demographic,
    region,platform,segment,customer_type, transactions,sales,
    round(sales/transactions,2)
from data_mart.weekly_sales)

select * from temp_Cte;

-- 1. What day of the week is used for each week_date value? 

select distinct dayofweek(week_date) as day_of_week from weekly_sales_cleaned;

-- 2. What range of week numbers are missing from the dataset?

select distinct week(week_date) as week from weekly_sales_cleaned
order by week;

-- 1-11 and 35-52

-- 3. How many total transactions were there for each year in the dataset?

select year(week_date) as year_txn, sum(TRANSACTIONS) as total_txn from weekly_sales_cleaned
group by year_txn
order by year_txn;

-- 4. What is the total sales for each region for each month?

select month(week_Date) as month_txn, region, sum(sales) as total_sales
from weekly_sales_cleaned
group by month_txn,region
order by month_txn, region;

-- 5. What is the total count of transactions for each platform

select platform, count(TRANSACTIONs) from weekly_Sales_Cleaned
group by platform;

-- 6. What is the percentage of sales for Retail vs Shopify for each month?

with temp_cte as (
    select month(week_date) as txn_month,
    platform,
    sum(sales) as sales 
    from weekly_sales_cleaned
    group by txn_month, platform
),
temp_cte2 as (
    select month(week_date) as txn_month,
    sum(sales) as SALES
    from weekly_sales_cleaned
    group by txn_month
)

select a.txn_month, a.platform, (a.sales*100/b.sales) as txn_perc 
from temp_cte a
left join temp_cte2 b
on a.txn_month = b.txn_month;

-- 7. What is the percentage of sales by demographic for each year in the dataset?


with temp_cte as (
    select year(week_date) as txn_year,
    demographic,
    sum(sales) as sales 
    from weekly_sales_cleaned
    group by txn_year, demographic
),
temp_cte2 as (
    select year(week_date) as txn_year,
    sum(sales) as SALES
    from weekly_sales_cleaned
    group by txn_year
)

select a.txn_year, a.demographic, (a.sales*100/b.sales) as txn_perc 
from temp_cte a
left join temp_cte2 b
on a.txn_year = b.txn_year
order by a.txn_year;


-- 8. Which age_band and demographic values contribute the most to Retail sales?

select age_band, demographic, platform,sum(sales) as total_sales 
from weekly_sales_cleaned 
group by age_band, demographic, platform
order by total_sales desc;

--unknown age_band and UNKNOWN demographic contributes max retial business

-- 9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

select year(week_Date) as txn_year, platform, sum(sales)/sum(TRANSACTIONS) as avg_txn
from weekly_sales_cleaned 
group by txn_year, platform
order by txn_year;

-- 3. Before & After Analysis

-- 1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?

with temp_cte as(select 
case 
when week_Date <'2020-06-15' and week_date>=date_sub('2020-06-15', INTERVAL 4 WEEK) then 'before'
when week_date >='2020-06-15' and week_date<=date_add('2020-06-15', INTERVAL 4 WEEK) then 'after'
else Null end as time_period,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period
having time_period is not Null),
temp_cte2 as(
    select time_period,
    total_sales,
    lag(total_sales) over() lagged_sales
    from temp_cte
)
select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;

-- 2. What about the entire 12 weeks before and after?


with temp_cte as(select 
case 
when week_Date <'2020-06-15' and week_date>=date_sub('2020-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2020-06-15' and week_date<=date_add('2020-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period
having time_period is not Null),
temp_cte2 as(
    select time_period,
    total_sales,
    lag(total_sales) over() lagged_sales
    from temp_cte
)
select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;



-- 3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

-- For year 2018

with temp_cte as(select 
case 
when week_Date <'2018-06-15' and week_date>=date_sub('2018-06-15', INTERVAL 4 WEEK) then 'before'
when week_date >='2018-06-15' and week_date<=date_add('2018-06-15', INTERVAL 4 WEEK) then 'after'
else Null end as time_period,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period
having time_period is not Null),
temp_cte2 as(
    select time_period,
    total_sales,
    lag(total_sales) over() lagged_sales
    from temp_cte
)
select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;


with temp_cte as(select 
case 
when week_Date <'2018-06-15' and week_date>=date_sub('2018-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2018-06-15' and week_date<=date_add('2018-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period
having time_period is not Null),
temp_cte2 as(
    select time_period,
    total_sales,
    lag(total_sales) over() lagged_sales
    from temp_cte
)
select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;


-- For Year 2019


with temp_cte as(select 
case 
when week_Date <'2019-06-15' and week_date>=date_sub('2019-06-15', INTERVAL 4 WEEK) then 'before'
when week_date >='2019-06-15' and week_date<=date_add('2019-06-15', INTERVAL 4 WEEK) then 'after'
else Null end as time_period,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period
having time_period is not Null),
temp_cte2 as(
    select time_period,
    total_sales,
    lag(total_sales) over() lagged_sales
    from temp_cte
)
select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;



with temp_cte as(select 
case 
when week_Date <'2019-06-15' and week_date>=date_sub('2019-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2019-06-15' and week_date<=date_add('2019-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period
having time_period is not Null),
temp_cte2 as(
    select time_period,
    total_sales,
    lag(total_sales) over() lagged_sales
    from temp_cte
)
select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;


-- Bonus Question

-- REGION

with temp_cte as(select 
case 
when week_Date <'2020-06-15' and week_date>=date_sub('2020-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2020-06-15' and week_date<=date_add('2020-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
region,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period,
region
having time_period is not Null),
temp_cte2 as(
    select time_period,region,
    total_sales,
    lag(total_sales) over(partition by region order by time_period) lagged_sales
    from temp_cte
)

select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;

-- Platform

with temp_cte as(select 
case 
when week_Date <'2020-06-15' and week_date>=date_sub('2020-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2020-06-15' and week_date<=date_add('2020-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
platform,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period,
platform
having time_period is not Null),
temp_cte2 as(
    select time_period,platform,
    total_sales,
    lag(total_sales) over(partition by platform order by time_period) lagged_sales
    from temp_cte
)

select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;



--Age_band

with temp_cte as(select 
case 
when week_Date <'2020-06-15' and week_date>=date_sub('2020-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2020-06-15' and week_date<=date_add('2020-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
age_band,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period,
age_band
having time_period is not Null),
temp_cte2 as(
    select time_period,age_band,
    total_sales,
    lag(total_sales) over(partition by age_band order by time_period) lagged_sales
    from temp_cte
)

select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;



--Demographic

with temp_cte as(select 
case 
when week_Date <'2020-06-15' and week_date>=date_sub('2020-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2020-06-15' and week_date<=date_add('2020-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
Demographic,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period,
Demographic
having time_period is not Null),
temp_cte2 as(
    select time_period,Demographic,
    total_sales,
    lag(total_sales) over(partition by Demographic order by time_period) lagged_sales
    from temp_cte
)

select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;

--Customer_type

with temp_cte as(select 
case 
when week_Date <'2020-06-15' and week_date>=date_sub('2020-06-15', INTERVAL 12 WEEK) then 'before'
when week_date >='2020-06-15' and week_date<=date_add('2020-06-15', INTERVAL 12 WEEK) then 'after'
else Null end as time_period,
Customer_type,
sum(sales) as total_SALES
from weekly_sales_cleaned group by time_period,
Customer_type
having time_period is not Null),
temp_cte2 as(
    select time_period,Customer_type,
    total_sales,
    lag(total_sales) over(partition by Customer_type order by time_period) lagged_sales
    from temp_cte
)

select a.*, a.sales_diff*100/a.total_sales as diff_perc
from (select *,(lagged_sales-total_sales) as sales_diff from temp_cte2) a
where a.sales_diff is not Null;


--Customer Graphic has the highest negative impact.