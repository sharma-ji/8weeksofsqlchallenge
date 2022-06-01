# [8-Week SQL Challenge](https://8weeksqlchallenge.com/)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/sharma-ji/8weeksofsqlchallenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/sharma-ji?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/sharma-ji)


# 🧺 Case Study #5 - Data Mart
<p align="center">
<img src="https://github.com/sharma-ji/8weeksofsqlchallenge/blob/main/IMG/org-5.png" width=40% height=40%>


## 🛠️ Problem Statement

Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specialises in fresh produce - Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.

Danny needs your help to quantify the impact of this change on the sales performance for Data Mart and it’s separate business areas.

## 📂 Dataset
For this case study there is only a single table: data_mart.weekly_sales:

### **```plan```**

<details>
<summary>
View table
</summary>

The columns are pretty self-explanatory based on the column names but here are some further details about the dataset:

Data Mart has international operations using a multi-region strategy
Data Mart has both, a retail and online platform in the form of a Shopify store front to serve their customers
Customer segment and customer_type data relates to personal age and demographics information that is shared with Data Mart
transactions is the count of unique purchases made through Data Mart and sales is the actual dollar amount of purchases
Each record in the dataset is related to a specific aggregated slice of the underlying sales data rolled up into a week_date value which represents the start of the sales week.

| week_date	| region	    | platform	| segment | customer_type | transactions | sales      | 
|-----------|---------------|-----------|---------|---------------|--------------|------------|
| 9/9/20	| OCEANIA	    | Shopify	| C3	  | New	          | 610	         | 110033.89  | 
| 29/7/20	| AFRICA	    | Retail	| C1	  | New	          | 110692	     | 3053771.19 |
| 22/7/20	| EUROPE	    | Shopify	| C4	  | Existing	  | 24	         | 8101.54    |
| 13/5/20	| AFRICA	    | Shopify	| null	  | Guest	      | 5287	     | 1003301.37 |
| 24/7/19	| ASIA	        | Retail	| C1	  | New	          | 127342	     | 3151780.41 |
| 10/7/19	| CANADA	    | Shopify	| F3	  | New	          | 51	         | 8844.93    |
| 26/6/19	| OCEANIA	    | Retail	| C3	  | New	          | 152921	     | 5551385.36 |
| 29/5/19	| SOUTH AMERICA	| Shopify	| null	  | New	          | 53	         | 10056.2    |
| 22/8/18	| AFRICA	    | Retail	| null	  | Existing	  | 31721	     | 1718863.58 |
| 25/7/18	| SOUTH AMERICA	| Retail	| null	  | New	          | 2136	     | 81757.91   |


</details>

---


## 🚀 Solutions

<details>
<summary> 
Data Cleansing Steps
</summary>

### **-- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc**</br>
### **--Add a month_number with the calendar month for each week_date value as the 3rd column**</br>
### **--Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values**</br>
### **--Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value**</br>
### **--Add a new demographic column using the following mapping for the first letter in the segment values**</br>
### **--Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns**</br>
### **--Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record**</br>

```SQL
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
```
</details>

<details>
<summary> 
Data Exploration
</summary>

### **Q1. What day of the week is used for each week_date value?**
```sql
select distinct dayofweek(week_date) as day_of_week from weekly_sales_cleaned;
```
| day_of_week |
|-------------|
| 2           |

### **Q2. What range of week numbers are missing from the dataset?**

```sql
select distinct week(week_date) as week from weekly_sales_cleaned
order by week;
```
| week |
|------|
| 12   |
| 13   |
| 14   |
| 15   |
| 16   |
| 17   |
| 18   |
| 19   |
| 20   |
| 21   |
| 22   |
| 23   |
| 24   |
| 25   |
| 26   |
| 27   |
| 28   |
| 29   |
| 30   |
| 31   |
| 32   |
| 33   |
| 35   |
| 34   |

> 1-11 and 35-52


### **Q3.How many total transactions were there for each year in the dataset?**

```sql
select year(week_date) as year_txn, sum(TRANSACTIONS) as total_txn from weekly_sales_cleaned
group by year_txn
order by year_txn;
```

| year_txn | total_txn |
|----------|-----------|
| 2018     | 346406460 |
| 2019     | 365639285 |
| 2020     | 375813651 |



### **Q4. What is the total sales for each region for each month?**
```SQL
select month(week_Date) as month_txn, region, sum(sales) as total_sales
from weekly_sales_cleaned
group by month_txn,region
order by month_txn, region;
```

| month_txn | region        | total_sales |
|-----------|---------------|-------------|
| 3         | AFRICA        | 567767480   |
| 3         | ASIA          | 529770793   |
| 3         | CANADA        | 144634329   |
| 3         | EUROPE        | 35337093    |
| 3         | OCEANIA       | 783282888   |
| 3         | SOUTH AMERICA | 71023109    |
| 3         | USA           | 225353043   |
| 4         | AFRICA        | 1911783504  |
| 4         | ASIA          | 1804628707  |
| 4         | CANADA        | 484552594   |
| 4         | EUROPE        | 127334255   |
| 4         | OCEANIA       | 2599767620  |
| 4         | SOUTH AMERICA | 238451531   |
| 4         | USA           | 759786323   |
| 5         | AFRICA        | 1647244738  |
| 5         | ASIA          | 1526285399  |
| 5         | CANADA        | 412378365   |
| 5         | EUROPE        | 109338389   |
| 5         | OCEANIA       | 2215657304  |
| 5         | SOUTH AMERICA | 201391809   |
| 5         | USA           | 655967121   |
| 6         | AFRICA        | 1767559760  |
| 6         | ASIA          | 1619482889  |
| 6         | CANADA        | 443846698   |
| 6         | EUROPE        | 122813826   |
| 6         | OCEANIA       | 2371884744  |
| 6         | SOUTH AMERICA | 218247455   |
| 6         | USA           | 703878990   |
| 7         | AFRICA        | 1960219710  |
| 7         | ASIA          | 1768844756  |
| 7         | CANADA        | 477134947   |
| 7         | EUROPE        | 136757466   |
| 7         | OCEANIA       | 2563459400  |
| 7         | SOUTH AMERICA | 235582776   |
| 7         | USA           | 760331754   |
| 8         | AFRICA        | 1809596890  |
| 8         | ASIA          | 1663320609  |
| 8         | CANADA        | 447073019   |
| 8         | EUROPE        | 122102995   |
| 8         | OCEANIA       | 2432313652  |
| 8         | SOUTH AMERICA | 221166052   |
| 8         | USA           | 712002790   |
| 9         | AFRICA        | 276320987   |
| 9         | ASIA          | 252836807   |
| 9         | CANADA        | 69067959    |
| 9         | EUROPE        | 18877433    |
| 9         | OCEANIA       | 372465518   |
| 9         | SOUTH AMERICA | 34175583    |
| 9         | USA           | 110532368   |


### **Q5. What is the total count of transactions for each platform**
```SQL
select platform, count(TRANSACTIONs) from weekly_Sales_Cleaned
group by platform;

```

| platform | count(TRANSACTIONs) |
|----------|---------------------|
| Retail   | 8568                |
| Shopify  | 8549                |

### **Q6. What is the percentage of sales for Retail vs Shopify for each month?**

```SQL
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
 ``` 

| txn_month | platform | txn_perc |
|-----------|----------|----------|
| 8         | Retail   | 97.0824  |
| 8         | Shopify  | 2.9176   |
| 7         | Shopify  | 2.7111   |
| 7         | Retail   | 97.2889  |
| 6         | Shopify  | 2.7287   |
| 6         | Retail   | 97.2713  |
| 5         | Retail   | 97.3047  |
| 5         | Shopify  | 2.6953   |
| 4         | Retail   | 97.5939  |
| 4         | Shopify  | 2.4061   |
| 3         | Shopify  | 2.4597   |
| 3         | Retail   | 97.5403  |
| 9         | Retail   | 97.3754  |
| 9         | Shopify  | 2.6246   |


### **Q7. What is the percentage of sales by demographic for each year in the dataset?**
```SQL
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
```

| txn_year | demographic | txn_perc |
|----------|-------------|----------|
| 2018     | unknown     | 41.6320  |
| 2018     | Couples     | 26.3805  |
| 2018     | Families    | 31.9876  |
| 2019     | unknown     | 40.2506  |
| 2019     | Couples     | 27.2752  |
| 2019     | Families    | 32.4742  |
| 2020     | Couples     | 28.7199  |
| 2020     | Families    | 32.7253  |
| 2020     | unknown     | 38.5548  |



### **Q8. Which age_band and demographic values contribute the most to Retail sales?**
```SQL
select age_band, demographic, platform,sum(sales) as total_sales 
from weekly_sales_cleaned 
group by age_band, demographic, platform
order by total_sales desc;

```  

| age_band     | demographic | platform | total_sales |
|--------------|-------------|----------|-------------|
| unknown      | unknown     | Retail   | 16067285533 |
| 	Retirees    | Families    | Retail   | 6634686916  |
| 	Retirees    | Couples     | Retail   | 6370580014  |
| Middle Aged  | Families    | Retail   | 4354091554  |
| Young Adults | Couples     | Retail   | 2602922797  |
| Middle Aged  | Couples     | Retail   | 1854160330  |
| Young Adults | Families    | Retail   | 1770889293  |
| unknown      | unknown     | Shopify  | 271326701   |
| Middle Aged  | Families    | Shopify  | 202050064   |
| 	Retirees    | Couples     | Shopify  | 160535056   |
| Middle Aged  | Couples     | Shopify  | 136339021   |
| Young Adults | Families    | Shopify  | 126326399   |
| 	Retirees    | Families    | Shopify  | 115770216   |
| Young Adults | Couples     | Shopify  | 76670333    |

> unknown age_band and UNKNOWN demographic contributes max retial business



### **Q9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?**
```SQL
select year(week_Date) as txn_year, platform, sum(sales)/sum(TRANSACTIONS) as avg_txn
from weekly_sales_cleaned 
group by txn_year, platform
order by txn_year;
```

| txn_year | platform | avg_txn  |
|----------|----------|----------|
| 2018     | Retail   | 36.5626  |
| 2018     | Shopify  | 192.4813 |
| 2019     | Retail   | 36.8335  |
| 2019     | Shopify  | 183.3611 |
| 2020     | Retail   | 36.5566  |
| 2020     | Shopify  | 179.0332 |

</details>

<details>
<summary>
Before & After Analysis
</summary>

### **Q1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?**

```SQL
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
```

| time_period | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|-------------|--------------|------------|-----------|
| before      | 2345878357  | 2904930571   | 559052214  | 23.8313   |

### **Q2. What about the entire 12 weeks before and after?**

``` SQL

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
```

| time_period | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|-------------|--------------|------------|-----------|
| before      | 7126273147  | 6973947753   | -152325394 | -2.1375   |

### **Q3.How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?**

> For year 2018

```SQL

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
```
| time_period | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|-------------|--------------|------------|-----------|
| before      | 2125140809  | 2129242914   | 4102105    | 0.1930    |


```SQL
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
```

| time_period | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|-------------|--------------|------------|-----------|
| before      | 6396562317  | 6500818510   | 104256193  | 1.6299    |


> For year 2019

```SQL
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
```

| time_period | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|-------------|--------------|------------|-----------|
| before      | 2249989796  | 2252326390   | 2336594    | 0.1038    |


```SQL
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
```

| time_period | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|-------------|--------------|------------|-----------|
| before      | 6883386397  | 6862646103   | -20740294  | -0.3013   |

</details>

<details>
<summary>
Bonus Question
</summary>

### **Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?**

```region```

```SQL
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
```

| time_period | region        | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|---------------|-------------|--------------|------------|-----------|
| before      | AFRICA        | 1709537105  | 1700390294   | -9146811   | -0.5350   |
| before      | ASIA          | 1637244466  | 1583807621   | -53436845  | -3.2638   |
| before      | CANADA        | 426438454   | 418264441    | -8174013   | -1.9168   |
| before      | EUROPE        | 108886567   | 114038959    | 5152392    | 4.7319    |
| before      | OCEANIA       | 2354116790  | 2282795690   | -71321100  | -3.0296   |
| before      | SOUTH AMERICA | 213036207   | 208452033    | -4584174   | -2.1518   |
| before      | USA           | 677013558   | 666198715    | -10814843  | -1.5974   |

```Platform```

```SQL
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
```

| time_period | platform | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|----------|-------------|--------------|------------|-----------|
| before      | Retail   | 6906861113  | 6738777279   | -168083834 | -2.4336   |
| before      | Shopify  | 219412034   | 235170474    | 15758440   | 7.1821    |

```Age_band```

```SQL
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
```
| time_period | age_band     | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|--------------|-------------|--------------|------------|-----------|
| before      | 	Retirees    | 2395264515  | 2365714994   | -29549521  | -1.2337   |
| before      | Middle Aged  | 1164847640  | 1141853348   | -22994292  | -1.9740   |
| before      | unknown      | 2764354464  | 2671961443   | -92393021  | -3.3423   |
| before      | Young Adults | 801806528   | 794417968    | -7388560   | -0.9215   |

```Demographic```

```SQL
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
```

| time_period | Demographic | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|-------------|-------------|--------------|------------|-----------|
| before      | Couples     | 2033589643  | 2015977285   | -17612358  | -0.8661   |
| before      | Families    | 2328329040  | 2286009025   | -42320015  | -1.8176   |
| before      | unknown     | 2764354464  | 2671961443   | -92393021  | -3.3423   |


```Customer_type```

```SQL
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
```

| time_period | Customer_type | total_sales | lagged_sales | sales_diff | diff_perc |
|-------------|---------------|-------------|--------------|------------|-----------|
| before      | Existing      | 3690116427  | 3606243454   | -83872973  | -2.2729   |
| before      | Guest         | 2573436301  | 2496233635   | -77202666  | -3.0000   |
| before      | New           | 862720419   | 871470664    | 8750245    | 1.0143    |

> Customer Graphic has the highest negative impact.

---
<p>&copy; 2022 Mukul Sharma</p>