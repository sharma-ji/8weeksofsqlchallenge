1
select a.customer_id, sum(b.price) as total_spend 
from dannys_diner.sales a
left join dannys_diner.menu b
on a.product_id = b.product_id
group by a.customer_id;


2
select customer_id, count(distinct order_date) as total_days 
from dannys_diner.sales
group by customer_id;

3
with ordered_sales as(
    select a.customer_id, a.order_date, a.product_id,b.product_name, 
    dense_rank() over(partition by a.customer_id order by a.order_date) ranking 
    from dannys_diner.sales a 
    left join dannys_diner.menu b
    on a.product_id = b.product_id
)
select distinct customer_id, product_name
from ordered_sales 
where ranking = 1;

4

select b.product_name, count(a.order_date) as item_bought 
from dannys_diner.sales a
left join dannys_diner.menu b
on a.product_id = b.product_id
group by b.product_name
order by item_bought desc
limit 1;


5

with temp as(
    select a.customer_id, b.product_name, count(a.order_date) as item_bought_count,
    dense_rank() over (partition by a.customer_id order by count(a.order_date) desc) ranking 
    from dannys_diner.sales a 
    left join dannys_diner.menu b
    on a.product_id = b.product_id
    group by a.customer_id, b.product_name
)

SELECT customer_id, product_name, item_bought_count
FROM temp
WHERE ranking = 1;

6
with temp_cte as(
    select a.customer_id, a.order_date,b.product_name,
    dense_rank() over(partition by a.customer_id order by a.order_date) ranking 
    from dannys_diner.sales a
    inner join dannys_diner.members c
    on a.customer_id = c.customer_id 
    left join dannys_diner.menu b 
    on a.product_id = b.product_id
    where a.order_date >= c.join_date
) 

select customer_id, order_Date, product_name
from temp_cte where ranking = 1;

7.

with temp_cte as(
    select a.customer_id, a.order_Date, b.product_name,
    dense_rank() over(partition by a.customer_id order by order_date desc) ranking
    from dannys_diner.sales a
    inner join dannys_diner.members c
    on a.customer_id = c.customer_id 
    left join dannys_diner.menu b 
    on a.product_id = b.product_id
    where a.order_date < c.join_date
)

select customer_id, order_date,product_name
from temp_cte where ranking = 1;

8.

select a.customer_id, count(a.product_id) as total_items, sum(b.price) as total_amount
from dannys_diner.sales a
left join dannys_diner.menu b
on a.product_id = b.product_id
left join dannys_diner.members c
on a.customer_id = c.customer_id
where a.order_date < c.join_date
group by a.customer_id;

9.

with pointer_cte as (
    select product_id,
    case when product_id = 1 then price*20
    else price*10 end as multiplier
    from dannys_diner.menu
)
select a.customer_id,sum(b.multiplier) as points
from dannys_diner.sales a
left join pointer_cte b
on a.product_id = b.product_id
group by a.customer_id;

10

with date_cte as (
    select *,
    DATE_ADD(join_date, INTERVAL 6 DAY) as valid_date
    from dannys_diner.members
)

select d.customer_id,
sum(case
when b.product_id = 1 then 20*b.price
when a.order_date between d.join_date and d.valid_date then 20*b.PRICE
else 10*b.price end) as pointer
from date_cte d
left join dannys_diner.sales a
on d.customer_id = a.customer_id
left join dannys_diner.menu b 
on a.product_id = b.product_id
where a.order_date < '2021-01-31'
group by a.customer_id;


Bonus Questions

select a.customer_id, a.order_date, b.product_name,
b.price,
CASE
WHEN c.join_date > a.order_date THEN 'N'
WHEN c.join_date <= a.order_date THEN 'Y'
ELSE 'N' end as member
from dannys_diner.sales a
left join dannys_diner.menu b
on a.product_id = b.product_id
left join dannys_diner.members C
on a.customer_id = c.customer_id
order by a.customer_id, a.order_date, b.product_name;


with temp_cte as(select a.customer_id, a.order_date, b.product_name,
b.price,
CASE
WHEN c.join_date > a.order_date THEN 'N'
WHEN c.join_date <= a.order_date THEN 'Y'
ELSE 'N' end as member
from dannys_diner.sales a
left join dannys_diner.menu b
on a.product_id = b.product_id
left join dannys_diner.members C
on a.customer_id = c.customer_id
order by a.customer_id, a.order_date, b.product_name)

select *, CASE
when member = 'N' then 'null'
else rank() over(PARTITION by customer_id, member order by order_date) end as ranking
from temp_cte;


 

 

