# [8-Week SQL Challenge](https://8weeksqlchallenge.com/)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/sharma-ji/8weeksofsqlchallenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/sharma-ji?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/sharma-ji)


# 💼 Case Study #6 - Clique Bait
<p align="center">
<img src="https://github.com/sharma-ji/8weeksofsqlchallenge/blob/main/IMG/org-6.png" width=40% height=40%>

## 🛠️ Problem Statement

> Clique Bait is not like your regular online seafood store - the founder and CEO Danny, was also a part of a digital data analytics team and wanted to expand his knowledge into the seafood industry!
> 
> In this case study - you are required to support Danny’s vision and analyse his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.
> 


---

## 📂 Dataset
For this case study there is a total of 5 datasets which you will need to combine to solve all of the questions.

### **```Users```**
<details>
<summary>
View table
</summary>

Customers who visit the Clique Bait website are tagged via their **```cookie_id```**.


| user_id	| cookie_id	| start_date          |
|---------|-----------|---------------------|
| 397	    | 3759ff	  | 2020-03-30 00:00:00 |
| 215	    | 863329	  | 2020-01-26 00:00:00 |
| 191	    | eefca9	  | 2020-03-15 00:00:00 |
| 89	    | 764796	  | 2020-01-07 00:00:00 |
| 127	    | 17ccc5	  | 2020-01-22 00:00:00 |
| 81	    | b0b666	  | 2020-03-01 00:00:00 |
| 260	    | a4f236	  | 2020-01-08 00:00:00 |
| 203	    | d1182f	  | 2020-04-18 00:00:00 |
| 23	    | 12dbc8	  | 2020-01-18 00:00:00 |
| 375	    | f61d69	  | 2020-01-03 00:00:00 |

</details>


### **```Events```**

<details>
<summary>
View table
</summary>

Customer visits are logged in this **```events```** table at a **```cookie_id level```** and the **```event_type```** and **```page_id```** values can be used to join onto relevant satellite tables to obtain further information about each event.

The sequence_number is used to order the events within each visit.

| visit_id | cookie_id | page_id | event_type	| sequence_number	| event_time                 |
|----------|-----------|---------|------------|-----------------|----------------------------|
| 719fd3	 | 3d83d3	   | 5	     | 1	        | 4	              | 2020-03-02 00:29:09.975502 |
| fb1eb1	 | c5ff25	   | 5	     | 2	        | 8	              | 2020-01-22 07:59:16.761931 |
| 23fe81	 | 1e8c2d	   | 10	     | 1	        | 9	              | 2020-03-21 13:14:11.745667 |
| ad91aa	 | 648115	   | 6	     | 1	        | 3	              | 2020-04-27 16:28:09.824606 |
| 5576d7	 | ac418c	   | 6	     | 1	        | 4	              | 2020-01-18 04:55:10.149236 |
| 48308b	 | c686c1	   | 8	     | 1	        | 5	              | 2020-01-29 06:10:38.702163 |
| 46b17d	 | 78f9b3	   | 7	     | 1	        | 12	            | 2020-02-16 09:45:31.926407 |
| 9fd196	 | ccf057	   | 4	     | 1	        | 5	              | 2020-02-14 08:29:12.922164 |
| edf853	 | f85454	   | 1	     | 1	        | 1	              | 2020-02-22 12:59:07.652207 |
| 3c6716	 | 02e74f	   | 3	     | 2	        | 5	              | 2020-01-31 17:56:20.777383 |

</details>

### **```Event Identifier```**

<details>
<summary>
View table
</summary>

The **```event_identifier```** table shows the types of events which are captured by Clique Bait’s digital data systems.



| event_type | event_name |
|------------|------------|
| 1	         | Page View |
| 2	         | Add to Cart |
| 3	         | Purchase |
| 4	         | Ad Impression |
| 5	         | Ad Click |

</details>

### **```Campaign Identifier```**

<details>
<summary>
View table
</summary>

This table shows information for the 3 campaigns that Clique Bait has ran on their website so far in 2020.

| campaign_id	| products | campaign_name	| start_date | end_date |
| 1	          | 1-3	     | BOGOF - Fishing For Compliments | 2020-01-01 00:00:00 | 2020-01-14 00:00:00 |
| 2	          | 4-5	     | 25% Off - Living The Lux Life | 2020-01-15 00:00:00	| 2020-01-28 00:00:00 |
| 3	          | 6-8	     | Half Off - Treat Your Shellf(ish) | 2020-02-01 00:00:00 | 2020-03-31 00:00:00 |

</details>

### **```Page Hierarchy```**

<details>
<summary>
View table
</summary>

This table lists all of the pages on the Clique Bait website which are tagged and have data passing through from user interaction events


| page_id | page_name	| product_category | product_id |
|---------|-----------|------------------|------------|
| 1	      | Home Page	| null | null |
| 2	      | All Products | null | null |
| 3	      | Salmon	| Fish | 1 |
| 4	      | Kingfish	| Fish | 2 |
| 5	      | Tuna	| Fish | 3 |
| 6	      | Russian Caviar | Luxury | 4 |
| 7	      | Black Truffle | Luxury | 5 |
| 8	      | Abalone	| Shellfish | 6 |
| 9	      | Lobster	| Shellfish | 7 |
| 10	    | Crab | Shellfish | 8 |
| 11      | Oyster | Shellfish | 9 |
| 12	    | Checkout | null | null |
| 13	    | Confirmation | null | null |

</details>


---


## 🚀 Solutions

<details>
<summary> 
Digital Analysis
</summary>

### **Q1. How many users are there?**
```sql
select count(distinct user_id) from clique_bait.users;
```
|count(distinct user_id)|
|-------------------|
|500                |

### **Q2. How many cookies does each user have on average?**
```sql
select avg(a.cnt) from
(select user_id, count(cookie_id) as cnt
from clique_bait.users
group by user_id) a;
```
|avg(a.cnt)|
|-----------|
|3.5640     |


### **Q3. What is the unique number of visits by all users per month?**
```sql
```



### **Q4. What is the number of events for each event type?**
```SQL
select b.event_name, count(a.visit_id) as cnt
from clique_bait.events a
left join clique_bait.event_identifier b
on a.event_type = b.event_type
group by b.event_name;
```

| event_name    | cnt   |
|---------------|-------|
| Page View     | 20928 |
| Add to Cart   | 8451  |
| Purchase      | 1777  |
| Ad Impression | 876   |
| Ad Click      | 702   |


### **Q5. What is the percentage of visits which have a purchase event?**
```SQL
select distinct perc from 
(select event_type,count(visit_id) over(partition by event_type)/count(visit_id) over() *100 as perc
from clique_bait.events) a
where event_type=3;
```

| perc |
|------|
| 5.4286 | 


### **Q6. What is the percentage of visits which view the checkout page but do not have a purchase event?**
```SQL
select sum(cnt1)/cnt2*100 as perc
from (select distinct event_type, page_id, count(visit_id) over(partition by page_id, event_type) cnt1,
count(visit_id) over() cnt2
from clique_bait.events) a
where event_type<>3 and page_id =12;
 ``` 

| perc |
|------|
| 6.4245 |


### **Q7.What are the top 3 pages by number of views?**
```SQL
select b.page_name, count(a.visit_id) as cnt
from clique_bait.events a
left join clique_bait.page_hierarchy b
on a.page_id = b.page_id
where a.event_type = 1
group by b.page_name
order by cnt desc
limit 3;
```

| page_name    | cnt  |
|--------------|------|
| All Products | 3174 |
| Checkout     | 2103 |
| Home Page    | 1782 |



### **Q8. What is the number of views and cart adds for each product category?**
```SQL
select b.product_category,c.event_type, count(a.visit_id) as cnt
from clique_bait.events a
left join clique_bait.page_hierarchy b
on a.page_id = b.page_id
left join clique_bait.event_identifier c
on a.event_type = c.event_type
where a.event_type in (1,2) and b.product_category is not Null
group by b.product_category,c.event_type
order by b.product_category;

```  

| product_category | event_type | cnt  |
|------------------|------------|------|
| Fish             | 1          | 4633 |
| Fish             | 2          | 2789 |
| Luxury           | 1          | 3032 |
| Luxury           | 2          | 1870 |
| Shellfish        | 1          | 6204 |
| Shellfish        | 2          | 3792 |


### **Q9. What are the top 3 products by purchases?**
```SQL
yet to be done
```

---
<p>&copy; 2022 Mukul Sharma</p>