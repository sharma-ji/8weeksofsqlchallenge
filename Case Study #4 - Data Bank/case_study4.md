# [8-Week SQL Challenge](https://8weeksqlchallenge.com/)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/sharma-ji/8weeksofsqlchallenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/sharma-ji?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/sharma-ji)
# 💸 Case Study #4 - Data Bank
<p align="center">
<img src="https://github.com/sharma-ji/8weeksofsqlchallenge/blob/main/IMG/org-4.png" width=40% height=40%>



## 🛠️ Problem Statement
> Danny thought that there should be some sort of intersection between these new age banks, cryptocurrency and the data world…so he decides to launch a new initiative - **Data Bank**!
> 
> The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.
> 
>This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments!

## 📂 Dataset
Danny has shared with you 2 key datasets for this case study:
### **```region```**

<details>
<summary>
View table
</summary>

This ```regions``` table contains the ```region_id``` and their respective ```region_name``` values

| "region_id" | "region_name" |
|-------------|---------------|
| 1           | "Australia"   |
| 2           | "America"     |
| 3           | "Africa"      |
| 4           | "Asia"        |
| 5           | "Europe"      |
</details>

### **```Customer Nodes```**

<details>
<summary>
View table
</summary>

Customers are randomly distributed across the nodes according to their region - this also specifies exactly which node contains both their cash and data.
This random distribution changes frequently to reduce the risk of hackers getting into Data Bank’s system and stealing customer’s money and data!
Below is a sample of the top 10 rows of the ```data_bank.customer_nodes```

| "customer_id" | "region_id" | "node_id" | "start_date" | "end_date"   |
|---------------|-------------|-----------|--------------|--------------|
| 1             | 3           | 4         | "2020-01-02" | "2020-01-03" |
| 2             | 3           | 5         | "2020-01-03" | "2020-01-17" |
| 3             | 5           | 4         | "2020-01-27" | "2020-02-18" |
| 4             | 5           | 4         | "2020-01-07" | "2020-01-19" |
| 5             | 3           | 3         | "2020-01-15" | "2020-01-23" |
| 6             | 1           | 1         | "2020-01-11" | "2020-02-06" |
| 7             | 2           | 5         | "2020-01-20" | "2020-02-04" |
| 8             | 1           | 2         | "2020-01-15" | "2020-01-28" |
| 9             | 4           | 5         | "2020-01-21" | "2020-01-25" |
| 10            | 3           | 4         | "2020-01-13" | "2020-01-14" |
</details>

### **```Customer Transactions```**

<details>
<summary>
View table
</summary>

This table stores all customer deposits, withdrawals and purchases made using their Data Bank debit card.

| "customer_id" | "txn_date"   | "txn_type" | "txn_amount" |
|---------------|--------------|------------|--------------|
| 429           | "2020-01-21" | "deposit"  | 82           |
| 155           | "2020-01-10" | "deposit"  | 712          |
| 398           | "2020-01-01" | "deposit"  | 196          |
| 255           | "2020-01-14" | "deposit"  | 563          |
| 185           | "2020-01-29" | "deposit"  | 626          |
| 309           | "2020-01-13" | "deposit"  | 995          |
| 312           | "2020-01-20" | "deposit"  | 485          |
| 376           | "2020-01-03" | "deposit"  | 706          |
| 188           | "2020-01-13" | "deposit"  | 601          |
| 138           | "2020-01-11" | "deposit"  | 520          |
</details>

---

## 🚀 Solutions
### **A. Customer Nodes Exploration**

<details>
<summary>
View solutions
</summary>

### **Q1. How many unique nodes are there on the Data Bank system?**

```sql
with temp as(select distinct node_id, region_id from data_bank.customer_nodes
order by node_id, region_id)
select count(*) as node_count from temp;
```

| node_count |
|------------|
| 5          |

### **Q2. What is the number of nodes per region?**

```sql
select region_id, count(distinct node_id) as cnt 
from data_bank.customer_nodes
group by region_id
order by region_id;

```

| region_id | cnt |
|-----------|-----|
| 1         | 5   |
| 2         | 5   |
| 3         | 5   |
| 4         | 5   |
| 5         | 5   |

### **Q3. How many customers are allocated to each region?**

```sql
select region_id, count(distinct customer_id) as cnt
from data_bank.customer_nodes
group by region_id
order by region_id;
```

| region_id | cnt |
|-----------|-----|
| 1         | 110 |
| 2         | 105 |
| 3         | 102 |
| 4         | 95  |
| 5         | 88  |


### **Q4. How many days on average are customers reallocated to a different node?**

```sql
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
```

| avg_days |
|----------|
| 49.2689  |


### **Q5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?**

```sql
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
```

| region_id | diff | percentile |
|-----------|------|------------|
| 1         | 18   | 0.51       |
| 1         | 28   | 0.8        |
| 1         | 29   | 0.82       |
| 1         | 264  | 0.95       |
| 1         | 265  | 0.95       |
| 1         | 266  | 0.95       |
| 1         | 267  | 0.95       |
| 2         | 18   | 0.5        |
| 2         | 28   | 0.81       |
| 2         | 264  | 0.95       |
| 2         | 265  | 0.95       |
| 2         | 266  | 0.95       |
| 2         | 267  | 0.95       |
| 3         | 18   | 0.5        |
| 3         | 28   | 0.8        |
| 3         | 29   | 0.82       |
| 3         | 265  | 0.95       |
| 3         | 266  | 0.95       |
| 3         | 267  | 0.95       |
| 3         | 268  | 0.95       |
| 4         | 28   | 0.81       |
| 4         | 268  | 0.95       |
| 4         | 269  | 0.95       |
| 4         | 270  | 0.95       |
| 4         | 271  | 0.95       |
| 5         | 19   | 0.52       |
| 5         | 29   | 0.82       |
| 5         | 259  | 0.95       |


</details>


### **B. Customer Transactions**

<details>
<summary>
View solutions
</summary>

### **Q1. What is the unique count and total amount for each transaction type?**

```sql
SELECT 
	txn_type,
	COUNT(txn_type) AS unique_count,
	SUM(txn_amount) AS total_amount
FROM data_bank.customer_transactions
GROUP BY txn_type;
```

| txn_type   | UNIQUE_count | txn_amt |
|------------|--------------|---------|
| deposit    | 500          | 1359168 |
| purchase   | 448          | 806537  |
| withdrawal | 439          | 793003  |


### **Q2. What is the average total historical deposit counts and amounts for all customers?**



### **Q3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?**

### **Q4. What is the closing balance for each customer at the end of the month?**

### **Q5. What is the percentage of customers who increase their closing balance by more than 5%?**


</details>

---
<p>&copy; 2022 Mukul Sharma</p>