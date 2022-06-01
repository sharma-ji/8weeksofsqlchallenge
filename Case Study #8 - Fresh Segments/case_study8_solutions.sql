-- Data Exploration and Cleansing

-- 1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month

ALTER TABLE fresh_segments.interest_metrics
ADD month_year2 DATE;

update fresh_segments.interest_metrics
set month_year2 = date_format(str_to_date(month_year, '%m-%Y'),'%Y-%m-01');

-- 2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?

select month_year2, count(*) from fresh_segments.interest_metrics
group by month_year2
order by month_year2;

-- 3. What do you think we should do with these null values in the fresh_segments.interest_metrics

SELECT 
 (SUM(CASE WHEN interest_id IS NULL THEN 1 END)*100  /
    COUNT(*)) AS null_pct
FROM fresh_segments.interest_metrics;

DELETE FROM fresh_segments.interest_metrics
WHERE interest_id IS NULL;

SELECT 
 (SUM(CASE WHEN interest_id IS NULL THEN 1 END)*100  /
    COUNT(*)) AS null_pct
FROM fresh_segments.interest_metrics;

-- 4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?

with temp_cte as(
select a.*,b.* 
from fresh_segments.interest_metrics a
FULL OUTER JOIN fresh_segments.interest_map b
on a.interest_id = b.id)

select count(*) from temp_cte where id is NULL;

-- 5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table

SELECT COUNT(*)
FROM fresh_segments.interest_map

-- 6. What sort of table join should we perform for our analysis and why? Check your logic 
-- by checking the rows where interest_id = 21246 in your joined output and include all 
-- columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.

select a.*,b.*
from fresh_segments.interest_metrics a
inner join fresh_segments.interest_map b
on a.interest_id = b.id
where a.interest_id = 21246
and a.month_year2 is not NULL;

-- 7. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? 
-- Do you think these values are valid and why?

select a.*,b.*
from fresh_segments.interest_metrics a
inner join fresh_segments.interest_map b
on a.interest_id = b.id
where a.month_year2 < b.created_at
and a.month_year2 is not NULL;

--Yes since we started our date with 01 of every MONTH


-- Interest Analysis

-- 1. Which interests have been present in all month_year dates in our dataset?

with temp_Cte as(
    select interest_id, count(distinct month_year) as total_months
    from fresh_segments.interest_metrics
    where month_year2 is not Null
    group by interest_id
)

select interest_id, total_months
from temp_cte 
where total_months = 14;


-- 2. Using this same total_months measure - calculate the cumulative percentage of all
-- records starting at 14 months - which total_months value passes the 90% cumulative 
-- percentage value?

with temp_Cte as(
    select interest_id, count(distinct month_year) as total_months
    from fresh_segments.interest_metrics
    where month_year2 is not Null
    group by interest_id
),
temp_cte2 as (
    select total_months,
    count(distinct interest_id) as total_interests
    from temp_cte 
    group by total_months
    order by total_months desc
)

select total_months,
total_interests,
sum(total_interests) over( order by total_months desc) / sum(total_interests) over() *100 cum_perc
from temp_Cte2;

-- 3. If we were to remove all interest_id values which are lower than the total_months value
-- we found in the previous question - how many total data points would we be removing?

with temp_Cte as(
    select interest_id, count(distinct month_year) as total_months
    from fresh_segments.interest_metrics
    where month_year2 is not Null
    group by interest_id
)
select count(distinct interest_id) as total_interests
    from temp_cte 
    where total_months < 6;

-- 4. Does this decision make sense to remove these data points from a business perspective? 
-- Use an example where there are all 14 months present to a removed interest example for your 
-- arguments - think about what it means to have less months present from a segment perspective.

with temp_Cte as(
    select interest_id, count(distinct month_year) as total_months
    from fresh_segments.interest_metrics
    where month_year2 is not Null
    group by interest_id
),
temp_cte2 as(
select interest_id
    from temp_cte 
    where total_months < 6)

DELETE FROM fresh_segments.interest_metrics WHERE interest_id in
(select interest_id from temp_cte2);

-- 5. After removing these interests - how many unique interests are there for each month?

select month_year, count(distinct interest_id) as interest_id
from fresh_segments.interest_metrics
group by month_year;


-- Segment Analysis

-- 1. Using our filtered dataset by removing the interests with less than 6 
-- months worth of data, which are the top 10 and bottom 10 interests which 
-- have the largest composition values in any month_year? Only use the maximum 
-- composition value for each interest but you must keep the corresponding month_year

with temp_cte as (
    select interest_id, month_year, max(composition) as composition
    from fresh_segments.interest_metrics
    group by interest_id, month_year
    order by composition
),
temp_cte2 as(
select * 
from temp_cte order by composition desc limit 10),
temp_cte3 as(
select *
from temp_cte order by composition limit 10
)

select * from temp_cte2
union 
select * from temp_cte3;

-- 2. Which 5 interests had the lowest average ranking value?

select interest_id, avg(ranking) as ranking from 
fresh_segments.interest_metrics
group by interest_id
order by ranking 
limit 5;


-- 3. Which 5 interests had the largest standard deviation in their percentile_ranking value?
select interest_id, std(percentile_ranking) as std_ranking from 
fresh_segments.interest_metrics
group by interest_id
order by std_ranking desc
limit 5;

-- 4. For the 5 interests found in the previous question - what was minimum and maximum 
-- percentile_ranking values for each interest and its corresponding year_month value? 
-- Can you describe what is happening for these 5 interests?

with temp_cte as (
    select interest_id, std(percentile_ranking) as std_ranking from 
fresh_segments.interest_metrics
group by interest_id
order by std_ranking desc
limit 5
),
temp_cte2 as (
select interest_id,
max(percentile_ranking) max_rank,
min(percentile_ranking) min_rank
from fresh_segments.interest_metrics
where interest_id in (select interest_id from temp_cte)
group by interest_id)

select a.interest_id, a.max_rank, a.min_rank,b.month_year as max_month_year,
c.month_year as min_month_year
from temp_cte2 a
left join fresh_segments.interest_metrics b
on a.interest_id = b.interest_id and round(a.max_rank,2) = round(b.percentile_ranking,2)
left join fresh_segments.interest_metrics c
on a.interest_id = c.interest_id and round(a.min_rank,2) = round(c.percentile_ranking,2);

-- These 5 interest are hitting their lowest percentile ranking after 1 year


-- 5. How would you describe our customers in this segment based off their composition and 
-- ranking values? What sort of products or services should we show to these customers and 
-- what should we avoid?


-- Index Analysis

-- 1. What is the top 10 interests by the average composition for each month?

with temp_cte as (
    select month_year, interest_id, round(composition/index_value,2) as avg_comp
    from fresh_segments.interest_metrics
    where month_year is not Null
),
temp_cte2 as (
    select month_year, interest_id,
    avg_comp,
    row_number() over(partition by month_year order by avg_comp desc) ranking
    from temp_cte
)
select * from temp_cte2 where ranking <=10;

-- 2. For all of these top 10 interests - which interest appears the most often?

with temp_cte as (
    select month_year, interest_id, round(composition/index_value,2) as avg_comp
    from fresh_segments.interest_metrics
    where month_year is not Null
),
temp_cte2 as (
    select month_year, interest_id,
    avg_comp,
    row_number() over(partition by month_year order by avg_comp desc) ranking
    from temp_cte
)
select interest_id, count(*) as total_interest
from temp_cte2 where ranking <=10
group by interest_id
order by total_interest DESC
limit 1;

-- 3.What is the average of the average composition for the top 10 interests for each month?

with temp_cte as (
    select month_year, interest_id, round(composition/index_value,2) as avg_comp
    from fresh_segments.interest_metrics
    where month_year is not Null
),
temp_cte2 as (
    select month_year, interest_id,
    avg_comp,
    row_number() over(partition by month_year order by avg_comp desc) ranking
    from temp_cte
)
select month_year, round(avg(avg_comp),2) as avg_comp
from temp_cte2 where ranking <=10
group by month_year
;




