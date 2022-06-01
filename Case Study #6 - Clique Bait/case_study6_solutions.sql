-- 2. Digital Analysis

-- 1. How many users are there?

select count(distinct user_id) from clique_bait.users;

-- 2. How many cookies does each user have on average?

select avg(a.cnt) from
(select user_id, count(cookie_id) as cnt
from clique_bait.users
group by user_id) a;

-- 3. What is the unique number of visits by all users per month?

--Need to solve

-- 4. What is the number of events for each event type?

select b.event_name, count(a.visit_id) as cnt
from clique_bait.events a
left join clique_bait.event_identifier b
on a.event_type = b.event_type
group by b.event_name;

-- 5. What is the percentage of visits which have a purchase event?

select distinct perc from 
(select event_type,count(visit_id) over(partition by event_type)/count(visit_id) over() *100 as perc
from clique_bait.events) a
where event_type=3;

-- 6. What is the percentage of visits which view the checkout page but do not have a purchase event?

select sum(cnt1)/cnt2*100 as perc
from (select distinct event_type, page_id, count(visit_id) over(partition by page_id, event_type) cnt1,
count(visit_id) over() cnt2
from clique_bait.events) a
where event_type<>3 and page_id =12;

-- 7. What are the top 3 pages by number of views?

select b.page_name, count(a.visit_id) as cnt
from clique_bait.events a
left join clique_bait.page_hierarchy b
on a.page_id = b.page_id
where a.event_type = 1
group by b.page_name
order by cnt desc
limit 3;

-- 8. What is the number of views and cart adds for each product category?
select b.product_category,c.event_type, count(a.visit_id) as cnt
from clique_bait.events a
left join clique_bait.page_hierarchy b
on a.page_id = b.page_id
left join clique_bait.event_identifier c
on a.event_type = c.event_type
where a.event_type in (1,2) and b.product_category is not Null
group by b.product_category,c.event_type
order by b.product_category;

-- 9. What are the top 3 products by purchases?

select b.product_category, a.event_type, count(a.visit_id) as CNT
from clique_bait.events a
left join clique_bait.page_hierarchy b
on a.page_id = b.page_id
group by b.product_category, a.event_type
order by cnt;

select page_id, count(visit_id) CNT
from clique_bait.events
group by page_id;


