-- High Level Sales Analysis

-- 1. What was the total quantity sold for all products?

select sum(qty) as total_products_sold from balanced_tree.sales;

-- 2. What is the total generated revenue for all products before discounts?

select sum(price*qty) as total_revenue from balanced_tree.sales;

-- 3. What was the total discount amount for all products?

select sum(price*qty*discount/100) as total_discount from balanced_tree.sales;

-- Transaction Analysis

-- 1. How many unique transactions were there?

select count(distinct txn_id) as total_unique_txn from balanced_tree.sales;

-- 2. What is the average unique products purchased in each transaction?

with temp_cte as(select txn_id, count(distinct prod_id) as unique_prod 
from balanced_tree.sales
group by txn_id)

select avg(UNIQUE_PROD) as avg_unique_PROD
from temp_cte;

-- 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?

with temp_cte as(select txn_id, sum(qty*price*(1-discount/100))/count(txn_id) as revenue_per_txn from
balanced_tree.sales
group by txn_id),

temp_cte2 as( select txn_id, revenue_per_txn,
round(PERCENT_RANK() over(order by revenue_per_txn),2)percentile
from temp_Cte)

select percentile, avg(revenue_per_txn) as revenue_per_txn from temp_cte2 
where percentile in (0.25,0.50,0.75)
group by percentile;

-- 4. What is the average discount value per transaction?

with temp_cte as(select txn_id, sum(price*qty*discount/100) as avg_discount_per_txn
from balanced_tree.sales
group by txn_id)

select avg(avg_discount_per_txn) as avg_discount_per_txn from temp_cte; 

-- 5. What is the percentage split of all transactions for members vs non-members?

select distinct member,count(txn_id) over(partition by member)/count(txn_id) over() perc
from (select distinct txn_id, member from balanced_tree.sales) a;

-- 6. What is the average revenue for member transactions and non-member transactions?

select member, avg(qty*price*(1-discount/100)) as avg_revenue from balanced_tree.sales
group by member;


-- Product Analysis

-- 1. What are the top 3 products by total revenue before discount?

with temp_cte as (select prod_id, sum(qty*price) as revenue from balanced_tree.sales
group by prod_id)

select b.product_name, a.revenue from temp_cte a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
order by a.revenue desc
limit 3;

-- 2. What is the total quantity, revenue and discount for each segment?

select b.segment_name, sum(a.qty) as total_quantity, 
sum(a.qty*a.price*(1-a.discount/100)) as revenue,
sum(a.qty*a.price*a.discount/100) as discount
from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.segment_name;


-- 3. What is the top selling product for each segment?
with temp_cte as(
    select b.segment_name, b.product_name, count(a.prod_id) as counts
    from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.segment_name, b.product_name
),
temp_cte2 as(
    select segment_name, product_name, counts,
    dense_rank() over(partition by segment_name order by counts desc) ranking
    from temp_cte
)

select * from temp_cte2 where ranking =1;

-- 4. What is the total quantity, revenue and discount for each category?

select b.category_name, sum(a.qty) as total_quantity, 
sum(a.qty*a.price*(1-a.discount/100)) as revenue,
sum(a.qty*a.price*a.discount/100) as discount
from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.category_name;

-- 5. What is the top selling product for each category?

with temp_cte as(
    select b.category_name, b.product_name, count(a.prod_id) as counts
    from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.category_name, b.product_name
),
temp_cte2 as(
    select category_name, product_name, counts,
    dense_rank() over(partition by category_name order by counts desc) ranking
    from temp_cte
)

select * from temp_cte2 where ranking =1;

-- 6. What is the percentage split of revenue by product for each segment?

with temp_cte as(
    select b.segment_name, b.product_name,
sum(a.qty*a.price*(1-a.discount/100)) as revenue
from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.segment_name, b.product_name
)

select segment_name, product_name,
revenue, round(revenue*100/sum(revenue) over(partition by segment_name),2) as revenue_prct
from temp_cte; 


-- 7. What is the percentage split of revenue by segment for each category?

with temp_cte as(
    select b.category_name, b.segment_name, 
sum(a.qty*a.price*(1-a.discount/100)) as revenue
from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.category_name, b.segment_name
)

select category_name, segment_name,
revenue, revenue*100/sum(revenue) over(partition by category_name) as revenue_prct
from temp_cte; 

-- 8. What is the percentage split of total revenue by category?

with temp_cte as(
    select b.category_name,
sum(a.qty*a.price*(1-a.discount/100)) as revenue
from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.category_name
)

select category_name,
revenue, revenue*100/sum(revenue) over() as revenue_prct
from temp_cte; 


-- 9. What is the total transaction “penetration” for each product? 

with temp_cte as(
    select prod_id,
    count(distinct txn_id) as prod_txn
    from balanced_tree.sales
    group by prod_id
),
temp_cte2 as(
    select count(distinct txn_id) as total_txn
    from
    balanced_tree.sales
)

select c.product_name,
    (100 * a.prod_txn /b.total_txn) as
    penetration_percentage
    from temp_cte a
    cross join temp_cte2 b
    left join balanced_tree.product_details c
    on a.prod_id = c.product_id
    order by penetration_percentage desc;

-- 10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?

--Yet to complete

