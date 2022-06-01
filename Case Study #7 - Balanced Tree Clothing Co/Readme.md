# [8-Week SQL Challenge](https://8weeksqlchallenge.com/)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/sharma-ji/8weeksofsqlchallenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/sharma-ji?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/sharma-ji)


# 🌲 Case Study #7 - Balanced Tree Clothing Co.
<p align="center">
<img src="/IMG/org-7.png" width=40% height=40%>


## 🛠️ Problem Statement

> Balanced Tree Clothing Company prides themselves on providing an optimised range of clothing and lifestyle wear for the modern adventurer!
> 
> Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams analyse their sales performance and generate a basic financial report to share with the wider business.

## 📂 Dataset
For this case study there is a total of 4 datasets for this case study. However you will only need to utilise 2 main tables to solve all of the regular questions:

### **```Product Details```**

<details>
<summary>
View table
</summary>

`balanced_tree.product_details` includes all information about the entire range that Balanced Clothing sells in their store.

| "product_id" | "price" | "product_name"                     | "category_id" | "segment_id" | "style_id" | "category_name" | "segment_name" | "style_name"          |
|--------------|---------|------------------------------------|---------------|--------------|------------|-----------------|----------------|-----------------------|
| "c4a632"     | 13      | "Navy Oversized Jeans - Womens"    | 1             | 3            | 7          | "Womens"        | "Jeans"        | "Navy Oversized"      |
| "e83aa3"     | 32      | "Black Straight Jeans - Womens"    | 1             | 3            | 8          | "Womens"        | "Jeans"        | "Black Straight"      |
| "e31d39"     | 10      | "Cream Relaxed Jeans - Womens"     | 1             | 3            | 9          | "Womens"        | "Jeans"        | "Cream Relaxed"       |
| "d5e9a6"     | 23      | "Khaki Suit Jacket - Womens"       | 1             | 4            | 10         | "Womens"        | "Jacket"       | "Khaki Suit"          |
| "72f5d4"     | 19      | "Indigo Rain Jacket - Womens"      | 1             | 4            | 11         | "Womens"        | "Jacket"       | "Indigo Rain"         |
| "9ec847"     | 54      | "Grey Fashion Jacket - Womens"     | 1             | 4            | 12         | "Womens"        | "Jacket"       | "Grey Fashion"        |
| "5d267b"     | 40      | "White Tee Shirt - Mens"           | 2             | 5            | 13         | "Mens"          | "Shirt"        | "White Tee"           |
| "c8d436"     | 10      | "Teal Button Up Shirt - Mens"      | 2             | 5            | 14         | "Mens"          | "Shirt"        | "Teal Button Up"      |
| "2a2353"     | 57      | "Blue Polo Shirt - Mens"           | 2             | 5            | 15         | "Mens"          | "Shirt"        | "Blue Polo"           |
| "f084eb"     | 36      | "Navy Solid Socks - Mens"          | 2             | 6            | 16         | "Mens"          | "Socks"        | "Navy Solid"          |
| "b9a74d"     | 17      | "White Striped Socks - Mens"       | 2             | 6            | 17         | "Mens"          | "Socks"        | "White Striped"       |
| "2feb6b"     | 29      | "Pink Fluro Polkadot Socks - Mens" | 2             | 6            | 18         | "Mens"          | "Socks"        | "Pink Fluro Polkadot" |

</details>

### **```Product Sales```**

<details>
<summary>
View table
</summary>

`balanced_tree.sales` contains product level information for all the transactions made for Balanced Tree including quantity, price, percentage discount, member status, a transaction ID and also the transaction timestamp.

Below is the display of the first 10 rows in this dataset:


| "prod_id" | "qty" | "price" | "discount" | "member" | "txn_id" | "start_txn_time"           |
|-----------|-------|---------|------------|----------|----------|----------------------------|
| "c4a632"  | 4     | 13      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "5d267b"  | 4     | 40      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "b9a74d"  | 4     | 17      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "2feb6b"  | 2     | 29      | 17         | True     | "54f307" | "2021-02-13 01:59:43.296"  |
| "c4a632"  | 5     | 13      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "e31d39"  | 2     | 10      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "72f5d4"  | 3     | 19      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "2a2353"  | 3     | 57      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "f084eb"  | 3     | 36      | 21         | True     | "26cc98" | "2021-01-19 01:39:00.3456" |
| "c4a632"  | 1     | 13      | 21         | False    | "ef648d" | "2021-01-27 02:18:17.1648" |

</details>

## 🚀 Solutions
### **A. High Level Sales Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. What was the total quantity sold for all products?**
```sql
select sum(qty) as total_products_sold from balanced_tree.sales;
```

**Result:**
| total_products_sold |
|---------------|
| 45216         |


**Q2. What is the total generated revenue for all products before discounts?**
```sql
select sum(price*qty) as total_revenue from balanced_tree.sales;
```

**Result:**
| total_revenue |
|-----------------|
| 1289453         |

**Q3. What was the total discount amount for all products?**
```sql
select sum(price*qty*discount/100) as total_discount from balanced_tree.sales;
```

**Result:**
| total_discount |
|------------------|
| 156229.1400           |


</details>

---

### **B. Transaction Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. How many unique transactions were there?**

```sql
select count(distinct txn_id) as total_unique_txn from balanced_tree.sales;
```


**Result:**
| total_unique_txn |
|--------------|
| 2500         |


**Q2. What is the average unique products purchased in each transaction?**
```sql
with temp_cte as(select txn_id, count(distinct prod_id) as unique_prod 
from balanced_tree.sales
group by txn_id)

select avg(UNIQUE_PROD) as avg_unique_PROD
from temp_cte;
```

**Result:**

| avg_unique_PROD |
|------------------|
| 6.0380            |



**Q3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?**
```sql
with temp_cte as(select txn_id, sum(qty*price*(1-discount/100))/count(txn_id) as revenue_per_txn from
balanced_tree.sales
group by txn_id),

temp_cte2 as( select txn_id, revenue_per_txn,
round(PERCENT_RANK() over(order by revenue_per_txn),2)percentile
from temp_Cte)

select percentile, avg(revenue_per_txn) as revenue_per_txn from temp_cte2 
where percentile in (0.25,0.50,0.75)
group by percentile;
```

**Result:**
| percentile | revenue_per_txn |
|------------|-----------------|
| 0.25       | 59.434057618800 |
| 0.5        | 73.524657242083 |
| 0.75       | 88.744221904800 |



**Q4. What is the average discount value per transaction?**
```sql
with temp_cte as(select txn_id, sum(price*qty*discount/100) as avg_discount_per_txn
from balanced_tree.sales
group by txn_id)

select avg(avg_discount_per_txn) as avg_discount_per_txn from temp_cte; 
```

**Result:**
| avg_discount_per_txn |
|-----------------------|
| 62.49165600          |


**Q5. What is the percentage split of all transactions for members vs non-members?**
```sql
select distinct member,count(txn_id) over(partition by member)/count(txn_id) over() perc
from (select distinct txn_id, member from balanced_tree.sales) a;
```

**Result:**
| member | perc   |
|--------|--------|
| f      | 0.3980 |
| t      | 0.6020 |




**Q6. What is the average revenue for member transactions and non-member transactions?**
```sql
select member, avg(qty*price*(1-discount/100)) as avg_revenue from balanced_tree.sales
group by member;
```

**Result:**

| member | avg_revenue |
|--------|-------------|
| t      | 75.43054078 |
| f      | 74.53558668 |



</details>

---

### **C. Product Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. What are the top 3 products by total revenue before discount?**
```sql
with temp_cte as (select prod_id, sum(qty*price) as revenue from balanced_tree.sales
group by prod_id)

select b.product_name, a.revenue from temp_cte a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
order by a.revenue desc
limit 3;
```

**Result:**
| product_name                 | revenue |
|--------------------------------|-----------------|
| "Blue Polo Shirt - Mens"       | 217683          |
| "Grey Fashion Jacket - Womens" | 209304          |
| "White Tee Shirt - Mens"       | 152000          |




**Q2. What is the total quantity, revenue and discount for each segment?**
```sql
select b.segment_name, sum(a.qty) as total_quantity, 
sum(a.qty*a.price*(1-a.discount/100)) as revenue,
sum(a.qty*a.price*a.discount/100) as discount
from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.segment_name;
```

**Result:**
| segment_name | total_quantity | revenue     | discount   |
|--------------|----------------|-------------|------------|
| Jeans        | 11349          | 183006.0300 | 25343.9700 |
| Shirt        | 11265          | 356548.7300 | 49594.2700 |
| Socks        | 11217          | 270963.5600 | 37013.4400 |
| Jacket       | 11385          | 322705.5400 | 44277.4600 |



**Q3. What is the top selling product for each segment?**
```sql
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

select * from temp_cte2 where ranking =1;;
```

**Result:**
| segment_name | product_name                  | counts | ranking |
|--------------|-------------------------------|--------|---------|
| Jacket       | Grey Fashion Jacket - Womens  | 1275   | 1       |
| Jeans        | Navy Oversized Jeans - Womens | 1274   | 1       |
| Shirt        | White Tee Shirt - Mens        | 1268   | 1       |
| Shirt        | Blue Polo Shirt - Mens        | 1268   | 1       |
| Socks        | Navy Solid Socks - Mens       | 1281   | 1       |



**Q4. What is the total quantity, revenue and discount for each category?**
```sql
select b.category_name, sum(a.qty) as total_quantity, 
sum(a.qty*a.price*(1-a.discount/100)) as revenue,
sum(a.qty*a.price*a.discount/100) as discount
from balanced_tree.sales a
left join balanced_tree.product_details b
on a.prod_id = b.product_id
group by b.category_name;
```

**Result:**
| category_name | total_quantity | revenue     | discount   |
|---------------|----------------|-------------|------------|
| Womens        | 22734          | 505711.5700 | 69621.4300 |
| Mens          | 22482          | 627512.2900 | 86607.7100 |




**Q5. What is the top selling product for each category?**
```sql
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
```

**Result:**

| category_name | product_name                 | counts | ranking |
|---------------|------------------------------|--------|---------|
| Mens          | Navy Solid Socks - Mens      | 1281   | 1       |
| Womens        | Grey Fashion Jacket - Womens | 1275   | 1       |


**Q6. What is the percentage split of revenue by product for each segment?**
```sql
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
```

**Result:**

| segment_name | product_name                     | revenue     | revenue_prct |
|--------------|----------------------------------|-------------|--------------|
| Jacket       | Indigo Rain Jacket - Womens      | 62740.4700  | 19.44        |
| Jacket       | Khaki Suit Jacket - Womens       | 76052.9500  | 23.57        |
| Jacket       | Grey Fashion Jacket - Womens     | 183912.1200 | 56.99        |
| Jeans        | Navy Oversized Jeans - Womens    | 43992.3900  | 24.04        |
| Jeans        | Black Straight Jeans - Womens    | 106407.0400 | 58.14        |
| Jeans        | Cream Relaxed Jeans - Womens     | 32606.6000  | 17.82        |
| Shirt        | White Tee Shirt - Mens           | 133622.4000 | 37.48        |
| Shirt        | Blue Polo Shirt - Mens           | 190863.9300 | 53.53        |
| Shirt        | Teal Button Up Shirt - Mens      | 32062.4000  | 8.99         |
| Socks        | White Striped Socks - Mens       | 54724.1900  | 20.20        |
| Socks        | Pink Fluro Polkadot Socks - Mens | 96377.7300  | 35.57        |
| Socks        | Navy Solid Socks - Mens          | 119861.6400 | 44.24        |




**Q7. What is the percentage split of revenue by segment for each category?**
```sql
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
```

**Result:**
| category_name | segment_name | revenue     | revenue_prct |
|---------------|--------------|-------------|--------------|
| Mens          | Shirt        | 356548.7300 | 56.81940190  |
| Mens          | Socks        | 270963.5600 | 43.18059810  |
| Womens        | Jeans        | 183006.0300 | 36.18782738  |
| Womens        | Jacket       | 322705.5400 | 63.81217262  |

**Q8. What is the percentage split of total revenue by category?**
```sql
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
```

**Result:**
| category_name | revenue     | revenue_prct |
|---------------|-------------|--------------|
| Womens        | 505711.5700 | 44.62591972  |
| Mens          | 627512.2900 | 55.37408028  |



**Q9. What is the total transaction “penetration” for each product?**
```sql
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
```

**Result:**
| product_name                     | penetration_percentage |
|----------------------------------|------------------------|
| Navy Solid Socks - Mens          | 51.2400                |
| Grey Fashion Jacket - Womens     | 51.0000                |
| Navy Oversized Jeans - Womens    | 50.9600                |
| Blue Polo Shirt - Mens           | 50.7200                |
| White Tee Shirt - Mens           | 50.7200                |
| Pink Fluro Polkadot Socks - Mens | 50.3200                |
| Indigo Rain Jacket - Womens      | 50.0000                |
| Khaki Suit Jacket - Womens       | 49.8800                |
| Black Straight Jeans - Womens    | 49.8400                |
| White Striped Socks - Mens       | 49.7200                |
| Cream Relaxed Jeans - Womens     | 49.7200                |
| Teal Button Up Shirt - Mens      | 49.6800                |



**Q10.  What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?**
```sql
yet to be done
```

</details>

---
<p>&copy; 2022 Mukul Sharma</p>