-- A. Customer Nodes Exploration

-- 1. How many unique nodes are there on the Data Bank system?

with temp as(select distinct node_id, region_id from data_bank.customer_nodes
order by node_id, region_id)
select count(*) as node_count from temp;

-- 2. What is the number of nodes per region?

select region_id, count(distinct node_id) as cnt 
from data_bank.customer_nodes
group by region_id
order by region_id;

-- 3. How many customers are allocated to each region?

select region_id, count(distinct customer_id) as cnt
from data_bank.customer_nodes
group by region_id
order by region_id;

-- 4. How many days on average are customers reallocated to a different node?

with temp_cte as(
    select customer_id,
    region_id, node_id,
    start_date,
    case 
    when substr(end_date,1,4) = '9999' then concat('2020',substr(end_date,5,6))
    else end_date end as end_date_new
    from data_bank.customer_nodes
)

select avg(datediff(end_date_new, start_date)) as avg_days FROM
temp_cte;

-- 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

with temp_cte as(
    select customer_id,
    region_id, node_id,
    start_date,
    case 
    when substr(end_date,1,4) = '9999' then concat('2020',substr(end_date,5,6))
    else end_date end as end_date_new
    -- datediff(end_date_new, start_date) as diff
    from data_bank.customer_nodes
),
temp_cte2 as(SELECT *,
datediff(end_date_new, start_date) as diff from temp_cte)

select distinct region_id,diff,percentile from (select *, round(percent_rank() over(partition by region_id order by diff),2) percentile
from temp_Cte2) temp_tbl
where percentile in (0.8,0.81,0.82) or percentile = 0.95 or percentile in (0.5,0.51, 0.52)
; 


-- B. Customer Transactions


-- 1.  What is the unique count and total amount for each transaction type?

select txn_type, count(distinct customer_id) as UNIQUE_count,
sum(txn_amount) as txn_amt
from data_bank.customer_transactions
group by txn_type;

-- 2. What is the average total historical deposit counts and amounts for all customers?


-- 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

with temp_cte as(
    select customer_id, month(txn_date) as month, txn_type, 
    count(customer_id) as cnt
    from data_bank.customer_transactions
    group by customer_id, month, txn_type
)
select month, count(customer_id)
from temp_Cte
where (txn_type = 'deposit' and cnt>1) and ((txn_type = 'deposit' and cnt>1) or ())


--4. 
