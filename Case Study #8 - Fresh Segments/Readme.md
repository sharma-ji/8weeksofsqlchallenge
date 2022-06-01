# [8-Week SQL Challenge](https://8weeksqlchallenge.com/)
![Star Badge](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=style=flat&color=BC4E99)
[![View Main Folder](https://img.shields.io/badge/View-Main_Folder-971901?)](https://github.com/sharma-ji/8weeksofsqlchallenge)
[![View Repositories](https://img.shields.io/badge/View-My_Repositories-blue?logo=GitHub)](https://github.com/sharma-ji?tab=repositories)
[![View My Profile](https://img.shields.io/badge/View-My_Profile-green?logo=GitHub)](https://github.com/sharma-ji)


# 🍊 Case Study #8 - Fresh Segments
<p align="center">
<img src="/IMG/org-8.png" width=40% height=40%>


## 🛠️ Problem Statement

> Danny created Fresh Segments, a digital marketing agency that helps other businesses analyse trends in online ad click behaviour for their unique customer base.

> Clients share their customer lists with the Fresh Segments team who then aggregate interest metrics and generate a single dataset worth of metrics for further analysis.

> In particular - the composition and rankings for different interests are provided for each client showing the proportion of their customer list who interacted with online assets related to each interest for each month.

> Danny has asked for your assistance to analyse aggregated metrics for an example client and provide some high level insights about the customer list and their interests.

## 📂 Dataset
For this case study there is a total of 2 datasets which you will need to use to solve the questions.

### **```Interest Metrics```**

<details>
<summary>
View table
</summary>

This table contains information about aggregated interest metrics for a specific major client of Fresh Segments which makes up a large proportion of their customer base.

Each record in this table represents the performance of a specific ```interest_id``` based on the client’s customer base interest measured through clicks and interactions with specific targeted advertising content.

| _month | _year | month_year |	interest_id	| composition |	index_value	| ranking | percentile_ranking |
|--------|-------|------------|-------------|-------------|-------------|---------|--------------------|
| 7	     | 2018	 | 07-2018	  | 32486	    | 11.89	      | 6.19	    | 1	      | 99.86 |
| 7	     | 2018	 | 07-2018	  | 6106	    | 9.93	      | 5.31	    | 2	      | 99.73 |
| 7	     | 2018	 | 07-2018	  | 18923	    | 10.85	      | 5.29	    | 3	      | 99.59 |
| 7	     | 2018	 | 07-2018	  | 6344	    | 10.32	      | 5.1	        | 4 	  | 99.45 |
| 7	     | 2018	 | 07-2018	  | 100	        | 10.77	      | 5.04	    | 5	      | 99.31 |
| 7	     | 2018	 | 07-2018	  | 69	        | 10.82	      | 5.03	    | 6	      | 99.18 |
| 7	     | 2018	 | 07-2018	  | 79	        | 11.21	      | 4.97	    | 7	      | 99.04 |
| 7	     | 2018	 | 07-2018	  | 6111	    | 10.71	      | 4.83	    | 8	      | 98.9 |
| 7	     | 2018	 | 07-2018	  | 6214	    | 9.71	      | 4.83	    | 8	      | 98.9 |
| 7	     | 2018	 | 07-2018	  | 19422	    | 10.11	      | 4.81	    | 10	  | 98.63 |

For example - let’s interpret the first row of the ```interest_metrics``` table together:

| _month | _year | month_year | interest_id	| composition | index_value	| ranking | percentile_ranking | 
|--------|-------|------------|-------------|-------------|-------------|---------|--------------------|
| 7	2018 | 07-2018 | 32486 | 11.89 | 6.19 | 1 | 99.86 |


> In July 2018, the ```composition``` metric is 11.89, meaning that 11.89% of the client’s customer list interacted with the interest ```interest_id = 32486``` - we can link ```interest_id``` to a separate mapping table to find the segment name called “Vacation Rental Accommodation Researchers”

The ```index_value``` is 6.19, means that the ```composition``` value is 6.19x the average composition value for all Fresh Segments clients’ customer for this particular interest in the month of July 2018.

The ```ranking``` and ```percentage_ranking``` relates to the order of ```index_value``` records in each month year.

</details>

### **```Interest Map```**

<details>
<summary>
View table
</summary>

This mapping table links the ```interest_id``` with their relevant interest information. You will need to join this table onto the previous ```interest_details``` table to obtain the ```interest_name``` as well as any details about the summary information.


| id | interest_name | interest_summary	| created_at | last_modified |
|----|---------------|------------------|------------|---------------|
| 1	 | Fitness Enthusiasts | Consumers using fitness tracking apps and websites.	| 2016-05-26 14:57:59 | 2018-05-23 11:30:12
| 2	 | Gamers | Consumers researching game reviews and cheat codes.	| 2016-05-26 14:57:59 | 2018-05-23 11:30:12
| 3	 | Car Enthusiasts | Readers of automotive news and car reviews.	| 2016-05-26 14:57:59 | 2018-05-23 11:30:12
| 4	 | Luxury Retail Researchers | Consumers researching luxury product reviews and gift ideas. | 2016-05-26 14:57:59 | 2018-05-23 11:30:12
| 5	 | Brides & Wedding Planners | People researching wedding ideas and vendors. | 2016-05-26 14:57:59 | 2018-05-23 11:30:12
| 6	 | Vacation Planners | Consumers reading reviews of vacation destinations and accommodations. | 2016-05-26 14:57:59 | 2018-05-23 11:30:13
| 7	 | Motorcycle Enthusiasts | Readers of motorcycle news and reviews. | 2016-05-26 14:57:59 | 2018-05-23 11:30:13
| 8	 | Business News Readers | Readers of online business news content. | 2016-05-26 14:57:59 | 2018-05-23 11:30:12
| 12 | Thrift Store Shoppers | Consumers shopping online for clothing at thrift stores and researching locations. | 2016-05-26 14:57:59 | 2018-03-16 13:14:00
| 13 | Advertising Professionals | People who read advertising industry news. | 2016-05-26 14:57:59 | 2018-05-23 11:30:12
</details>

## 🚀 Solutions
### **A. Data Exploration and Cleansing**

<details>
<summary>
View solutions
</summary>

**Q1. Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month**
```sql
ALTER TABLE fresh_segments.interest_metrics
ADD month_year2 DATE;

update fresh_segments.interest_metrics
set month_year2 = date_format(str_to_date(month_year, '%m-%Y'),'%Y-%m-01');
```


**Q2. What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?**
```sql
select month_year2, count(*) from fresh_segments.interest_metrics
group by month_year2
order by month_year2;
```

**Result:**
| month_year2 | count(*) |
|-------------|----------|
| null        | 1        |
| 2018-07-01  | 709      |
| 2018-08-01  | 752      |
| 2018-09-01  | 774      |
| 2018-10-01  | 853      |
| 2018-11-01  | 925      |
| 2018-12-01  | 986      |
| 2019-01-01  | 966      |
| 2019-02-01  | 1072     |
| 2019-03-01  | 1078     |
| 2019-04-01  | 1035     |
| 2019-05-01  | 827      |
| 2019-06-01  | 804      |
| 2019-07-01  | 836      |
| 2019-08-01  | 1062     |

**Q3.  What do you think we should do with these null values in the fresh_segments.interest_metrics**
```sql
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
```

**Q4. How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?**
```SQL
with temp_cte as(
select a.*,b.* 
from fresh_segments.interest_metrics a
FULL OUTER JOIN fresh_segments.interest_map b
on a.interest_id = b.id)

select count(*) from temp_cte where id is NULL;
```

**Q5. Summarise the id values in the fresh_segments.interest_map by its total record count in this table**
```sql
SELECT COUNT(*)
FROM fresh_segments.interest_map
```

**Result:**

| count(*) |
|----------|
| 1209     |


**Q6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns from fresh_segments.interest_map except from the id column.**
```sql
select a.*,b.*
from fresh_segments.interest_metrics a
inner join fresh_segments.interest_map b
on a.interest_id = b.id
where a.interest_id = 21246
and a.month_year2 is not NULL;
```

**Result:**

| _month | _year | month_year | interest_id | composition | index_value | ranking | percentile_ranking | month_year2 | id    | interest_name                    | interest_summary                                      | created_at          | last_modified       |
|--------|-------|------------|-------------|-------------|-------------|---------|--------------------|-------------|-------|----------------------------------|-------------------------------------------------------|---------------------|---------------------|
| 4      | 2019  | 04-2019    | 21246       | 1.58        | 0.63        | 1092    | 0.64               | 2019-04-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 3      | 2019  | 03-2019    | 21246       | 1.75        | 0.67        | 1123    | 1.14               | 2019-03-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 2      | 2019  | 02-2019    | 21246       | 1.84        | 0.68        | 1109    | 1.07               | 2019-02-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 1      | 2019  | 01-2019    | 21246       | 2.05        | 0.76        | 954     | 1.95               | 2019-01-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 12     | 2018  | 12-2018    | 21246       | 1.97        | 0.7         | 983     | 1.21               | 2018-12-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 11     | 2018  | 11-2018    | 21246       | 2.25        | 0.78        | 908     | 2.16               | 2018-11-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 10     | 2018  | 10-2018    | 21246       | 1.74        | 0.58        | 855     | 0.23               | 2018-10-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 9      | 2018  | 09-2018    | 21246       | 2.06        | 0.61        | 774     | 0.77               | 2018-09-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 8      | 2018  | 08-2018    | 21246       | 2.13        | 0.59        | 765     | 0.26               | 2018-08-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |
| 7      | 2018  | 07-2018    | 21246       | 2.26        | 0.65        | 722     | 0.96               | 2018-07-01  | 21246 | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11 17:50:04 | 2018-06-11 17:50:04 |


**Q6. Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table? Do you think these values are valid and why?**
```sql
select a.*,b.*
from fresh_segments.interest_metrics a
inner join fresh_segments.interest_map b
on a.interest_id = b.id
where a.month_year2 < b.created_at
and a.month_year2 is not NULL;
```

**Result:**

> Yes since we started our date with 01 of every MONTH


| _month | _year | month_year | interest_id | composition | index_value | ranking | percentile_ranking | month_year2 | id    | interest_name                                      | interest_summary                                                                                                                                                      | created_at          | last_modified       |
|--------|-------|------------|-------------|-------------|-------------|---------|--------------------|-------------|-------|----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|---------------------|
| 7      | 2018  | 07-2018    | 32704       | 8.04        | 2.27        | 225     | 69.14              | 2018-07-01  | 32704 | Major Airline Customers                            | People visiting sites for major airline brands to plan and view travel itinerary.                                                                                     | 2018-07-06 14:35:04 | 2018-07-06 14:35:04 |
| 7      | 2018  | 07-2018    | 33191       | 3.99        | 2.11        | 283     | 61.18              | 2018-07-01  | 33191 | Online Shoppers                                    | People who spend money online                                                                                                                                         | 2018-07-17 10:40:03 | 2018-07-17 10:46:58 |
| 7      | 2018  | 07-2018    | 32703       | 5.53        | 1.8         | 375     | 48.56              | 2018-07-01  | 32703 | School Supply Shoppers                             | Consumers shopping for classroom supplies for K-12 students.                                                                                                          | 2018-07-06 14:35:04 | 2018-07-06 14:35:04 |
| 7      | 2018  | 07-2018    | 32701       | 4.23        | 1.41        | 483     | 33.74              | 2018-07-01  | 32701 | Womens Equality Advocates                          | People visiting sites advocating for womens equal rights.                                                                                                             | 2018-07-06 14:35:03 | 2018-07-06 14:35:03 |
| 7      | 2018  | 07-2018    | 32705       | 4.38        | 1.34        | 505     | 30.73              | 2018-07-01  | 32705 | Certified Events Professionals                     | Professionals reading industry news and researching products and services for event management.                                                                       | 2018-07-06 14:35:04 | 2018-07-06 14:35:04 |
| 7      | 2018  | 07-2018    | 32702       | 3.56        | 1.18        | 580     | 20.44              | 2018-07-01  | 32702 | Romantics                                          | People reading about romance and researching ideas for planning romantic moments.                                                                                     | 2018-07-06 14:35:04 | 2018-07-06 14:35:04 |
| 8      | 2018  | 08-2018    | 34465       | 3.34        | 2.34        | 12      | 98.44              | 2018-08-01  | 34465 | Toronto Blue Jays Fans                             | People reading news about the Toronto Blue Jays and watching games. These consumers are more likely to spend money on team gear.                                      | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 34463       | 3.06        | 2.1         | 36      | 95.31              | 2018-08-01  | 34463 | Boston Red Sox Fans                                | People reading news about the Boston Red Sox and watching games. These consumers are more likely to spend money on team gear.                                         | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 34464       | 3           | 1.91        | 57      | 92.57              | 2018-08-01  | 34464 | New York Yankees Fans                              | People reading news about the New York Yankees and watching games. These consumers are more likely to spend money on team gear.                                       | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 33959       | 2.54        | 1.86        | 67      | 91.26              | 2018-08-01  | 33959 | Boston Bruins Fans                                 | People reading news about the Boston Bruins and watching games. These consumers are more likely to spend money on team gear.                                          | 2018-08-02 16:05:03 | 2018-08-02 16:05:03 |
| 8      | 2018  | 08-2018    | 34469       | 4.54        | 1.84        | 68      | 91.13              | 2018-08-01  | 34469 | Jazz Festival Enthusiasts                          | People researching and planning to attend jazz music festivals.                                                                                                       | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 33971       | 4.92        | 1.81        | 74      | 90.35              | 2018-08-01  | 33971 | Sun Protection Shoppers                            | Consumers comparing brands and shopping for sun protection products.                                                                                                  | 2018-08-02 16:05:05 | 2018-08-02 16:05:05 |
| 8      | 2018  | 08-2018    | 34462       | 2.73        | 1.73        | 97      | 87.35              | 2018-08-01  | 34462 | Baltimore Orioles Fans                             | People reading news about the Baltimore Orioles and watching games. These consumers are more likely to spend money on team gear.                                      | 2018-08-15 18:00:03 | 2018-08-15 18:00:03 |
| 8      | 2018  | 08-2018    | 34082       | 3.45        | 1.7         | 107     | 86.05              | 2018-08-01  | 34082 | New England Patriots Fans                          | People reading news about the New England Patriots and watching games. These consumers are more likely to spend money on team gear.                                   | 2018-08-07 17:10:04 | 2018-08-07 17:10:04 |
| 8      | 2018  | 08-2018    | 34574       | 2.99        | 1.69        | 111     | 85.53              | 2018-08-01  | 34574 | F1 Racing Enthusiasts                              | People visiting websites and reading articles about F1 racing.                                                                                                        | 2018-08-17 10:50:03 | 2018-08-17 10:50:03 |
| 8      | 2018  | 08-2018    | 33960       | 2.68        | 1.67        | 118     | 84.62              | 2018-08-01  | 33960 | Chicago Blackhawks Fans                            | People reading news about the Chicago Blackhawks and watching games. These consumers are more likely to spend money on team gear.                                     | 2018-08-02 16:05:03 | 2018-08-02 16:05:03 |
| 8      | 2018  | 08-2018    | 33967       | 2.85        | 1.63        | 131     | 82.92              | 2018-08-01  | 33967 | New York Rangers Fans                              | People reading news about the New York Rangers and watching games. These consumers are more likely to spend money on team gear.                                       | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34461       | 3.31        | 1.53        | 176     | 77.05              | 2018-08-01  | 34461 | Jazz Music Fans                                    | People reading about jazz music and musicians.                                                                                                                        | 2018-08-15 18:00:03 | 2018-08-15 18:00:03 |
| 8      | 2018  | 08-2018    | 34466       | 2.41        | 1.52        | 182     | 76.27              | 2018-08-01  | 34466 | Detroit Tigers Fans                                | People reading news about the Detroit Tigers and watching games. These consumers are more likely to spend money on team gear.                                         | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 33963       | 2.38        | 1.52        | 182     | 76.27              | 2018-08-01  | 33963 | Denver Broncos Fans                                | People reading news about the Denver Broncos and watching games. These consumers are more likely to spend money on team gear.                                         | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 33969       | 2.59        | 1.52        | 182     | 76.27              | 2018-08-01  | 33969 | Pittsburgh Penguins Fans                           | People reading news about the Pittsburgh Penguins and watching games. These consumers are more likely to spend money on team gear.                                    | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34077       | 4.52        | 1.5         | 199     | 74.05              | 2018-08-01  | 34077 | Candy Shoppers                                     | Consumers researching candy companies and purchasing candy online.                                                                                                    | 2018-08-07 17:10:03 | 2018-08-07 17:10:03 |
| 8      | 2018  | 08-2018    | 33961       | 2.3         | 1.49        | 205     | 73.27              | 2018-08-01  | 33961 | Detroit Red Wings Fans                             | People reading news about the Detroit Red Wings and watching games. These consumers are more likely to spend money on team gear.                                      | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34459       | 3.32        | 1.48        | 216     | 71.84              | 2018-08-01  | 34459 | Coffee Bean Shoppers                               | Consumers researching coffee brands and purchasing coffee beans.                                                                                                      | 2018-08-15 18:00:03 | 2018-08-15 18:00:03 |
| 8      | 2018  | 08-2018    | 34084       | 2.3         | 1.46        | 228     | 70.27              | 2018-08-01  | 34084 | New York Jets Fans                                 | People reading news about the New York Jets and watching games. These consumers are more likely to spend money on team gear.                                          | 2018-08-07 17:10:04 | 2018-08-07 17:10:04 |
| 8      | 2018  | 08-2018    | 34088       | 3.5         | 1.41        | 260     | 66.1               | 2018-08-01  | 34088 | Soda Drinkers                                      | Consumers researching soda companies and purchasing soda online.                                                                                                      | 2018-08-07 17:10:04 | 2018-08-07 17:10:04 |
| 8      | 2018  | 08-2018    | 34086       | 2.71        | 1.41        | 260     | 66.1               | 2018-08-01  | 34086 | Pittsburgh Steelers Fans                           | People reading news about the Pittsburgh Steelers and watching games. These consumers are more likely to spend money on team gear.                                    | 2018-08-07 17:10:04 | 2018-08-07 17:10:04 |
| 8      | 2018  | 08-2018    | 34468       | 3.49        | 1.36        | 294     | 61.67              | 2018-08-01  | 34468 | Hard Rock Hotel & Casino Trip Planners             | Consumers comparing and booking accommodations at Hard Rock Hotels and Casinos.                                                                                       | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 33970       | 2.38        | 1.34        | 313     | 59.19              | 2018-08-01  | 33970 | San Antonio Spurs Fans                             | People reading news about the San Antonio Spurs and watching games. These consumers are more likely to spend money on team gear.                                      | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34467       | 3.39        | 1.32        | 336     | 56.19              | 2018-08-01  | 34467 | Little Rock Trip Planners                          | People researching attractions and accommodations in Little Rock, Arkansas. These consumers are more likely to spend money on flights, hotels, and local attractions. | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 33966       | 2.39        | 1.3         | 360     | 53.06              | 2018-08-01  | 33966 | New York Knicks Fans                               | People reading news about the New York Knicks and watching games. These consumers are more likely to spend money on team gear.                                        | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 33964       | 2.35        | 1.3         | 360     | 53.06              | 2018-08-01  | 33964 | Milwaukee Bucks Fans                               | People reading news about the Milwaukee Bucks and watching games. These consumers are more likely to spend money on team gear.                                        | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34083       | 2.12        | 1.29        | 371     | 51.63              | 2018-08-01  | 34083 | New York Giants Fans                               | People reading news about the New York Giants and watching games. These consumers are more likely to spend money on team gear.                                        | 2018-08-07 17:10:04 | 2018-08-07 17:10:04 |
| 8      | 2018  | 08-2018    | 34079       | 2.2         | 1.28        | 378     | 50.72              | 2018-08-01  | 34079 | Detroit Lions Fans                                 | People reading news about the Detroit Lions and watching games. These consumers are more likely to spend money on team gear.                                          | 2018-08-07 17:10:03 | 2018-08-07 17:10:03 |
| 8      | 2018  | 08-2018    | 34078       | 3.67        | 1.24        | 413     | 46.15              | 2018-08-01  | 34078 | Cookie Eaters                                      | Consumers researching cookie companies and purchasing cookies online.                                                                                                 | 2018-08-07 17:10:03 | 2018-08-07 17:10:03 |
| 8      | 2018  | 08-2018    | 34087       | 2.01        | 1.24        | 413     | 46.15              | 2018-08-01  | 34087 | San Francisco 49ers Fans                           | People reading news about the San Francisco 49ers and watching games. These consumers are more likely to spend money on team gear.                                    | 2018-08-07 17:10:04 | 2018-08-07 17:10:04 |
| 8      | 2018  | 08-2018    | 33972       | 2.1         | 1.21        | 438     | 42.89              | 2018-08-01  | 33972 | Toronto Raptors Fans                               | People reading news about the Toronto Raptors and watching games. These consumers are more likely to spend money on team gear.                                        | 2018-08-02 16:05:05 | 2018-08-02 16:05:05 |
| 8      | 2018  | 08-2018    | 33965       | 2.23        | 1.15        | 489     | 36.25              | 2018-08-01  | 33965 | Minnesota Timberwolves Fans                        | People reading news about the Minnesota Timberwolves and watching games. These consumers are more likely to spend money on team gear.                                 | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34085       | 1.96        | 1.14        | 500     | 34.81              | 2018-08-01  | 34085 | Oakland Raiders Fans                               | People reading news about the Oakland Raiders and watching games. These consumers are more likely to spend money on team gear.                                        | 2018-08-07 17:10:04 | 2018-08-07 17:10:04 |
| 8      | 2018  | 08-2018    | 34460       | 2.55        | 1.13        | 509     | 33.64              | 2018-08-01  | 34460 | Ice Cream Shoppers                                 | Consumers researching ice cream brands and purchasing ice cream products.                                                                                             | 2018-08-15 18:00:03 | 2018-08-15 18:00:03 |
| 8      | 2018  | 08-2018    | 33968       | 2.15        | 1.12        | 517     | 32.59              | 2018-08-01  | 33968 | Oklahoma City Thunder Fans                         | People reading news about the Oklahoma City Thunder and watching games. These consumers are more likely to spend money on team gear.                                  | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34276       | 2.86        | 1.1         | 541     | 29.47              | 2018-08-01  | 34276 | Romance Movie and TV enthusiasts                   | Consumers researching popular romance movies and TV shows.                                                                                                            | 2018-08-13 13:35:02 | 2018-08-13 13:35:02 |
| 8      | 2018  | 08-2018    | 34081       | 1.73        | 1.07        | 565     | 26.34              | 2018-08-01  | 34081 | Miami Dolphins Fans                                | People reading news about the Miami Dolphins and watching games. These consumers are more likely to spend money on team gear.                                         | 2018-08-07 17:10:03 | 2018-08-07 17:10:03 |
| 8      | 2018  | 08-2018    | 33962       | 1.7         | 1.06        | 578     | 24.64              | 2018-08-01  | 33962 | Chicago Bears Fans                                 | People reading news about the Chicago Bears and watching games. These consumers are more likely to spend money on team gear.                                          | 2018-08-02 16:05:04 | 2018-08-02 16:05:04 |
| 8      | 2018  | 08-2018    | 34471       | 2.59        | 0.95        | 657     | 14.34              | 2018-08-01  | 34471 | Cabin Rental Researchers                           | People researching and booking cabin rentals accommodations.                                                                                                          | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 34470       | 2.4         | 0.92        | 675     | 11.99              | 2018-08-01  | 34470 | Drive-In Theater Enthusiasts                       | People researching the history of drive-in theaters and buying movie tickets.                                                                                         | 2018-08-15 18:00:04 | 2018-08-15 18:00:04 |
| 8      | 2018  | 08-2018    | 33958       | 1.88        | 0.73        | 740     | 3.52               | 2018-08-01  | 33958 | Astrology Enthusiasts                              | People reading daily horoscopes and astrology content.                                                                                                                | 2018-08-02 16:05:03 | 2018-08-02 16:05:03 |
| 9      | 2018  | 09-2018    | 35904       | 5.19        | 2.34        | 11      | 98.59              | 2018-09-01  | 35904 | Utility Workwear Shoppers                          | Customers shopping for clothes and shoes from utility workwear brands.                                                                                                | 2018-09-05 18:10:04 | 2018-09-05 18:10:04 |
| 9      | 2018  | 09-2018    | 35903       | 5.23        | 2.14        | 26      | 96.67              | 2018-09-01  | 35903 | Trendy Denim Shoppers                              | Customers shopping for denim from trendsetting brands.                                                                                                                | 2018-09-05 18:10:03 | 2018-09-05 18:10:03 |
| 9      | 2018  | 09-2018    | 35953       | 4.17        | 1.75        | 80      | 89.74              | 2018-09-01  | 35953 | Kitchen and Bath Professionals                     | Professionals reading industry news and researching products and services for kitchen and bathroom construction and design.                                           | 2018-09-06 16:55:03 | 2018-09-06 16:55:03 |
| 9      | 2018  | 09-2018    | 36020       | 4.21        | 1.54        | 151     | 80.64              | 2018-09-01  | 36020 | Architects                                         | Professionals reading industry news and researching architecture products and services.                                                                               | 2018-09-07 15:00:03 | 2018-09-07 15:00:03 |
| 9      | 2018  | 09-2018    | 35905       | 3.49        | 1.4         | 235     | 69.87              | 2018-09-01  | 35905 | Athleisure Shoppers                                | Customers shopping for clothes and accessories from athleisure and fitness brands.                                                                                    | 2018-09-05 18:10:04 | 2018-09-05 18:10:04 |
| 9      | 2018  | 09-2018    | 35906       | 2.74        | 1.26        | 362     | 53.59              | 2018-09-01  | 35906 | MS Information Researchers                         | People researching multiple sclerosis treatments and charities.                                                                                                       | 2018-09-05 18:15:03 | 2018-09-05 18:15:03 |
| 9      | 2018  | 09-2018    | 35932       | 2.03        | 0.84        | 714     | 8.46               | 2018-09-01  | 35932 | Easter Decorations and Candy Shoppers              | Consumers shopping for Easter decorations and candy.                                                                                                                  | 2018-09-06 11:40:04 | 2018-09-14 16:47:29 |
| 9      | 2018  | 09-2018    | 36343       | 1.89        | 0.8         | 736     | 5.64               | 2018-09-01  | 36343 | Computer Processor and Data Center Decision Makers | Professionals reading industry news and researching products and services for computer processing and data center storage.                                            | 2018-09-14 14:35:03 | 2018-09-14 14:35:03 |
| 10     | 2018  | 10-2018    | 37875       | 5.6         | 2.6         | 11      | 98.72              | 2018-10-01  | 37875 | Vermont Trip Planners                              | People researching attractions and accommodations in Vermont. These consumers are more likely to spend money on flights, hotels, and local attractions.               | 2018-10-03 14:15:03 | 2018-10-03 14:15:03 |
| 10     | 2018  | 10-2018    | 38356       | 4.08        | 1.96        | 79      | 90.78              | 2018-10-01  | 38356 | Grateful Dead Fans                                 | People reading about the Grateful Dead, their music, and similar musicians.                                                                                           | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 10     | 2018  | 10-2018    | 37874       | 4.1         | 1.86        | 111     | 87.05              | 2018-10-01  | 37874 | Spain Trip Planners                                | People researching attractions and accommodations in Spain. These consumers are more likely to spend money on flights, hotels, and local attractions.                 | 2018-10-03 14:15:03 | 2018-10-03 14:15:03 |
| 10     | 2018  | 10-2018    | 37880       | 4.46        | 1.71        | 171     | 80.05              | 2018-10-01  | 37880 | Solitaire Players                                  | People playing solitaire and card games online.                                                                                                                       | 2018-10-03 14:15:04 | 2018-10-03 14:15:04 |
| 10     | 2018  | 10-2018    | 38357       | 3.41        | 1.64        | 215     | 74.91              | 2018-10-01  | 38357 | Jam Band Festival Fans                             | People researching and planning to attend jam band music festivals.                                                                                                   | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 10     | 2018  | 10-2018    | 38360       | 3.25        | 1.62        | 223     | 73.98              | 2018-10-01  | 38360 | Northeastern Voters                                | People researching voter registration options and political issues for voters in Northeastern states.                                                                 | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 38355       | 3.16        | 1.61        | 228     | 73.4               | 2018-10-01  | 38355 | Private Jet Traveler                               | People researching and booking private jet travel accommodations.                                                                                                     | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 10     | 2018  | 10-2018    | 37883       | 3.63        | 1.58        | 254     | 70.36              | 2018-10-01  | 37883 | Shapewear & Leggings Shoppers                      | Consumers shopping for leggings and shapewear apparel.                                                                                                                | 2018-10-03 14:15:04 | 2018-10-03 14:15:04 |
| 10     | 2018  | 10-2018    | 38353       | 3.53        | 1.55        | 281     | 67.21              | 2018-10-01  | 38353 | Netherlands Trip Planners                          | People researching attractions and accommodations in the Netherlands. These consumers are more likely to spend money on flights, hotels, and local attractions.       | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 10     | 2018  | 10-2018    | 38368       | 6.76        | 1.55        | 281     | 67.21              | 2018-10-01  | 38368 | Volvo Vehicle Shoppers                             | People researching and comparing Volvo vehicles. These consumers are more likely to spend money on a new or used car.                                                 | 2018-10-11 12:30:03 | 2018-10-11 12:30:03 |
| 10     | 2018  | 10-2018    | 37879       | 4.25        | 1.54        | 291     | 66.04              | 2018-10-01  | 37879 | Chess Enthusiasts                                  | People researching chess techniques and playing chess online.                                                                                                         | 2018-10-03 14:15:04 | 2018-10-03 14:15:04 |
| 10     | 2018  | 10-2018    | 38362       | 3.16        | 1.48        | 338     | 60.56              | 2018-10-01  | 38362 | South Atlantic Voters                              | People researching voter registration options and political issues for voters in South Atlantic states.                                                               | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 38364       | 2.73        | 1.46        | 362     | 57.76              | 2018-10-01  | 38364 | Southern Central Voters                            | People researching voter registration options and political issues for voters in Southern Central states.                                                             | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 38351       | 3.02        | 1.43        | 393     | 54.14              | 2018-10-01  | 38351 | Xtreme Sports Fans                                 | People reading news about professional xtreme sports and purchasing gear.                                                                                             | 2018-10-11 12:20:04 | 2019-01-16 09:11:30 |
| 10     | 2018  | 10-2018    | 38283       | 3.16        | 1.39        | 425     | 50.41              | 2018-10-01  | 38283 | Womens Subscription Box Shoppers                   | Consumers researching and purchasing subscription boxes for womens products and accessories.                                                                          | 2018-10-10 15:20:04 | 2018-10-10 15:20:04 |
| 10     | 2018  | 10-2018    | 37887       | 3.08        | 1.38        | 430     | 49.82              | 2018-10-01  | 37887 | Gift Givers                                        | Consumers shopping for gift cards and other gifts.                                                                                                                    | 2018-10-03 14:45:03 | 2018-10-03 14:45:03 |
| 10     | 2018  | 10-2018    | 38365       | 2.64        | 1.35        | 470     | 45.16              | 2018-10-01  | 38365 | Midwestern Voters                                  | People researching voter registration options and political issues for voters in Midwestern states.                                                                   | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 38354       | 2.71        | 1.34        | 492     | 42.59              | 2018-10-01  | 38354 | Train Travelers                                    | People researching and booking train travel accommodations.                                                                                                           | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 10     | 2018  | 10-2018    | 38359       | 3.12        | 1.33        | 500     | 41.66              | 2018-10-01  | 38359 | Christian Voters                                   | People researching political issues for Christian voters.                                                                                                             | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 37876       | 2.25        | 1.32        | 511     | 40.37              | 2018-10-01  | 37876 | Jamband Fans                                       | People reading about jamband music and culture.                                                                                                                       | 2018-10-03 14:15:03 | 2018-10-03 14:15:03 |
| 10     | 2018  | 10-2018    | 38367       | 2.28        | 1.3         | 537     | 37.34              | 2018-10-01  | 38367 | Tea Party Policy Supporters                        | People researching political issues for Tea Party supporters.                                                                                                         | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 38366       | 2.89        | 1.28        | 548     | 36.06              | 2018-10-01  | 38366 | Green Party Policy Supporters                      | People researching political issues for Green Party supporters.                                                                                                       | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 37877       | 2.19        | 1.28        | 548     | 36.06              | 2018-10-01  | 37877 | Dallas Mavericks Fans                              | People reading news about the Dallas Mavericks and watching games. These consumers are more likely to spend money on team gear.                                       | 2018-10-03 14:15:03 | 2018-10-03 14:15:03 |
| 10     | 2018  | 10-2018    | 38363       | 2.52        | 1.27        | 562     | 34.42              | 2018-10-01  | 38363 | Southeastern Voters                                | People researching voter registration options and political issues for voters in Southeastern states.                                                                 | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 38284       | 2.42        | 1.26        | 570     | 33.49              | 2018-10-01  | 38284 | Portuguese Food Enthusiasts                        | People reading about Portuguese food and researching recipes.                                                                                                         | 2018-10-10 15:20:04 | 2018-10-10 15:20:04 |
| 10     | 2018  | 10-2018    | 37878       | 2.09        | 1.23        | 593     | 30.81              | 2018-10-01  | 37878 | New Orleans Pelicans Fans                          | People reading news about the New Orleans Pelicans and watching games. These consumers are more likely to spend money on team gear.                                   | 2018-10-03 14:15:03 | 2018-10-03 14:15:03 |
| 10     | 2018  | 10-2018    | 37882       | 2.57        | 1.23        | 593     | 30.81              | 2018-10-01  | 37882 | Home Aquarium Enthusiasts                          | Consumers researching or purchasing home aquarium products and services.                                                                                              | 2018-10-03 14:15:04 | 2018-10-03 14:15:04 |
| 10     | 2018  | 10-2018    | 38352       | 2.28        | 1.23        | 593     | 30.81              | 2018-10-01  | 38352 | Lawn and Home Pest Control Researchers             | Consumers researching lawn and home pest control products and techniques.                                                                                             | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 10     | 2018  | 10-2018    | 37881       | 2.28        | 1.21        | 618     | 27.89              | 2018-10-01  | 37881 | Trivia Enthusiasts                                 | People researching trivia facts and playing trivia games online.                                                                                                      | 2018-10-03 14:15:04 | 2018-10-03 14:15:04 |
| 10     | 2018  | 10-2018    | 38350       | 2.2         | 1.2         | 630     | 26.49              | 2018-10-01  | 38350 | Indian Food Enthusiasts                            | People reading about Indian food and researching recipes.                                                                                                             | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 10     | 2018  | 10-2018    | 38361       | 2.36        | 1.15        | 676     | 21.12              | 2018-10-01  | 38361 | Mid-Atlantic Voters                                | People researching voter registration options and political issues for voters in Mid-Atlantic states.                                                                 | 2018-10-11 12:20:05 | 2018-10-11 12:20:05 |
| 10     | 2018  | 10-2018    | 38358       | 2.21        | 1.07        | 731     | 14.7               | 2018-10-01  | 38358 | Off the Grid Living Enthusiasts                    | People researching living off the grid and shopping for products and equipment.                                                                                       | 2018-10-11 12:20:04 | 2018-10-11 12:20:04 |
| 11     | 2018  | 11-2018    | 40439       | 5.39        | 2.67        | 9       | 99.03              | 2018-11-01  | 40439 | Ski and Snowboard Apparel Shoppers                 | Consumers shopping for winter clothing from ski and snowboarding apparel brands.                                                                                      | 2018-11-09 15:45:04 | 2018-11-09 15:45:04 |
| 11     | 2018  | 11-2018    | 40183       | 4.88        | 2.37        | 28      | 96.98              | 2018-11-01  | 40183 | Canoeing and Kayaking Enthusiasts                  | People reading about canoeing and kayaking news and destinations.                                                                                                     | 2018-11-02 17:10:04 | 2019-01-16 09:11:30 |
| 11     | 2018  | 11-2018    | 40184       | 3.34        | 1.88        | 109     | 88.25              | 2018-11-01  | 40184 | Scuba Diving Enthusiasts                           | People reading about scuba diving news and destinations.                                                                                                              | 2018-11-02 17:10:04 | 2019-01-16 09:11:30 |
| 11     | 2018  | 11-2018    | 40682       | 2.97        | 1.83        | 130     | 85.99              | 2018-11-01  | 40682 | Ergonomic Office Supplies Shoppers                 | Consumers shopping for ergonomic desk and office supply products.                                                                                                     | 2018-11-14 12:30:04 | 2018-11-14 12:30:04 |
| 11     | 2018  | 11-2018    | 40685       | 2.62        | 1.74        | 173     | 81.36              | 2018-11-01  | 40685 | Rodeo Enthusiasts                                  | People researching and planning to attend local rodeos.                                                                                                               | 2018-11-14 12:30:04 | 2019-01-16 09:11:30 |
| 11     | 2018  | 11-2018    | 40683       | 2.4         | 1.74        | 173     | 81.36              | 2018-11-01  | 40683 | Aviation Enthusiasts                               | People reading about aircrafts and flying and joining aviation communities.                                                                                           | 2018-11-14 12:30:04 | 2018-11-14 12:30:04 |
| 11     | 2018  | 11-2018    | 40190       | 3.02        | 1.62        | 241     | 74.03              | 2018-11-01  | 40190 | Luxury Watch Shoppers                              | Consumers shopping for watches from luxury brands.                                                                                                                    | 2018-11-02 17:10:05 | 2018-11-02 17:10:05 |
| 11     | 2018  | 11-2018    | 40697       | 2.78        | 1.58        | 270     | 70.91              | 2018-11-01  | 40697 | Santa Cruz Trip Planners                           | People researching attractions and accommodations in Santa Cruz. These consumers are more likely to spend money on travel and local attractions.                      | 2018-11-14 12:30:05 | 2018-11-14 12:30:05 |
| 11     | 2018  | 11-2018    | 40437       | 2.74        | 1.56        | 283     | 69.5               | 2018-11-01  | 40437 | Podcast Listeners                                  | People visiting sites about podcasts and reading or listening to content from popular podcasts.                                                                       | 2018-11-09 15:40:05 | 2018-11-09 15:40:05 |
| 11     | 2018  | 11-2018    | 40192       | 3.04        | 1.54        | 308     | 66.81              | 2018-11-01  | 40192 | Rome Trip Planners                                 | People researching attractions and accommodations in Rome. These consumers are more likely to spend money on travel and local attractions.                            | 2018-11-02 17:10:05 | 2018-11-02 17:10:05 |
| 11     | 2018  | 11-2018    | 40525       | 3.33        | 1.5         | 345     | 62.82              | 2018-11-01  | 40525 | Hospital Executives                                | Professionals reading industry news and researching products and services for hospital executives.                                                                    | 2018-11-12 17:30:04 | 2018-11-12 17:30:04 |
| 11     | 2018  | 11-2018    | 40691       | 2.58        | 1.48        | 362     | 60.99              | 2018-11-01  | 40691 | Poetry Readers                                     | People searching online for poetry.                                                                                                                                   | 2018-11-14 12:30:05 | 2018-11-14 12:30:05 |
| 11     | 2018  | 11-2018    | 40191       | 3.21        | 1.48        | 362     | 60.99              | 2018-11-01  | 40191 | Revolutionary War History Buffs                    | People reading about the history of the American Revolutionary War.                                                                                                   | 2018-11-02 17:10:05 | 2018-11-02 17:10:05 |
| 11     | 2018  | 11-2018    | 40690       | 2.17        | 1.48        | 362     | 60.99              | 2018-11-01  | 40690 | Business Book Readers                              | People searching online for books and content about business.                                                                                                         | 2018-11-14 12:30:04 | 2018-11-14 12:30:04 |
| 11     | 2018  | 11-2018    | 40698       | 2.1         | 1.48        | 362     | 60.99              | 2018-11-01  | 40698 | GMC Vehicle Shopper                                | People researching and comparing GMC vehicles. These consumers are more likely to spend money on a new or used car.                                                   | 2018-11-14 12:30:05 | 2018-11-14 12:30:05 |
| 11     | 2018  | 11-2018    | 40688       | 2.2         | 1.47        | 381     | 58.94              | 2018-11-01  | 40688 | Legal News Readers                                 | People reading news about law and the latest legal cases.                                                                                                             | 2018-11-14 12:30:04 | 2018-11-14 12:30:04 |
| 11     | 2018  | 11-2018    | 40436       | 3.02        | 1.47        | 381     | 58.94              | 2018-11-01  | 40436 | Egypt Trip Planners                                | People researching attractions and accommodations in Egypt. These consumers are more likely to spend money on travel and local attractions.                           | 2018-11-09 15:40:05 | 2018-11-09 15:40:05 |
| 11     | 2018  | 11-2018    | 40438       | 2.58        | 1.44        | 409     | 55.93              | 2018-11-01  | 40438 | iPhone Users                                       | Consumers shopping for products and services for their iPhones.                                                                                                       | 2018-11-09 15:40:05 | 2018-11-09 15:40:05 |
| 11     | 2018  | 11-2018    | 40434       | 2.94        | 1.43        | 423     | 54.42              | 2018-11-01  | 40434 | History Buffs                                      | People reading general history facts.                                                                                                                                 | 2018-11-09 15:40:04 | 2018-11-09 15:40:04 |
| 11     | 2018  | 11-2018    | 40700       | 1.94        | 1.42        | 439     | 52.69              | 2018-11-01  | 40700 | Speedway Event Enthusiasts                         | People researching and planning to attend speedway events.                                                                                                            | 2018-11-14 12:30:06 | 2019-01-16 09:11:30 |
| 11     | 2018  | 11-2018    | 40435       | 3.19        | 1.39        | 468     | 49.57              | 2018-11-01  | 40435 | World War One History Buffs                        | People reading about the history of World War I.                                                                                                                      | 2018-11-09 15:40:05 | 2018-11-09 15:40:05 |
| 11     | 2018  | 11-2018    | 40187       | 2.45        | 1.34        | 519     | 44.07              | 2018-11-01  | 40187 | Organic Food Eaters                                | Consumer reading about organic foods and researching organic food recipes.                                                                                            | 2018-11-02 17:10:04 | 2018-11-02 17:10:04 |
| 11     | 2018  | 11-2018    | 40193       | 2.43        | 1.34        | 519     | 44.07              | 2018-11-01  | 40193 | Myrtle Beach Trip Planners                         | People researching attractions and accommodations in Myrtle Beach. These consumers are more likely to spend money on travel and local attractions.                    | 2018-11-02 17:10:05 | 2018-11-02 17:10:05 |
| 11     | 2018  | 11-2018    | 40195       | 3.06        | 1.33        | 531     | 42.78              | 2018-11-01  | 40195 | U.S. History Buffs                                 | People reading about the history of the United States of America.                                                                                                     | 2018-11-02 17:10:05 | 2018-11-02 17:10:05 |
| 11     | 2018  | 11-2018    | 40189       | 2.77        | 1.32        | 545     | 41.27              | 2018-11-01  | 40189 | Native American Culture Enthusiasts                | People reading about Native American culture and traditions.                                                                                                          | 2018-11-02 17:10:04 | 2018-11-02 17:10:04 |
| 11     | 2018  | 11-2018    | 40188       | 2.3         | 1.29        | 580     | 37.5               | 2018-11-01  | 40188 | Civil War History Buff                             | People reading about the history of the American Civil War.                                                                                                           | 2018-11-02 17:10:04 | 2018-11-02 17:10:04 |
| 11     | 2018  | 11-2018    | 40194       | 1.57        | 0.99        | 834     | 10.13              | 2018-11-01  | 40194 | Detroit Pistons Fans                               | People reading news about the Detroit Pistons and watching games. These consumers are more likely to spend money on team gear.                                        | 2018-11-02 17:10:05 | 2018-11-02 17:10:05 |
| 12     | 2018  | 12-2018    | 41548       | 10.46       | 4.42        | 1       | 99.9               | 2018-12-01  | 41548 | Winter Apparel Shoppers                            | Consumers shopping for winter clothing from popular apparel brands.                                                                                                   | 2018-12-03 11:10:04 | 2018-12-03 11:10:04 |
| 12     | 2018  | 12-2018    | 42203       | 6.09        | 3.41        | 2       | 99.8               | 2018-12-01  | 42203 | Fitness Activity Tracker Users                     | People using health and fitness activity trackers.                                                                                                                    | 2018-12-13 20:00:00 | 2019-01-31 12:40:53 |
| 12     | 2018  | 12-2018    | 41854       | 4.54        | 2.92        | 7       | 99.3               | 2018-12-01  | 41854 | Swimming Enthusiasts                               | People reading about swim lessons and swimming competitions.                                                                                                          | 2018-12-07 11:50:04 | 2019-01-16 09:11:30 |
| 12     | 2018  | 12-2018    | 41856       | 3.8         | 2.02        | 84      | 91.56              | 2018-12-01  | 41856 | Chocolate Lovers                                   | Consumers researching chocolate companies and purchasing chocolates and desserts.                                                                                     | 2018-12-07 11:50:04 | 2018-12-07 11:50:04 |
| 12     | 2018  | 12-2018    | 41551       | 3.03        | 1.66        | 237     | 76.18              | 2018-12-01  | 41551 | Cookie Recipe Researchers                          | People researching cookie and dessert recipes and baking techniques.                                                                                                  | 2018-12-03 11:10:05 | 2018-12-03 11:10:05 |
| 12     | 2018  | 12-2018    | 41552       | 3.7         | 1.65        | 243     | 75.58              | 2018-12-01  | 41552 | Restaurant Menu Researchers                        | Consumers researching menus for local and chain restaurants.                                                                                                          | 2018-12-03 11:10:05 | 2018-12-03 11:10:05 |
| 12     | 2018  | 12-2018    | 42238       | 3.16        | 1.59        | 302     | 69.65              | 2018-12-01  | 42238 | Online Calculator Users                            | Consumers using online calculators.                                                                                                                                   | 2018-12-14 21:00:00 | 2019-01-31 13:49:10 |
| 12     | 2018  | 12-2018    | 41855       | 2.42        | 1.53        | 354     | 64.42              | 2018-12-01  | 41855 | Snow Removal Researchers                           | Consumers researching and comparing snow removal equipment brands.                                                                                                    | 2018-12-07 11:50:04 | 2018-12-07 11:50:04 |
| 12     | 2018  | 12-2018    | 41550       | 2.98        | 1.52        | 366     | 63.22              | 2018-12-01  | 41550 | Africa Trip Planners                               | People researching attractions and accommodations in Africa. These consumers are more likely to spend money on flights, hotels, and local attractions.                | 2018-12-03 11:10:05 | 2018-12-03 11:10:05 |
| 12     | 2018  | 12-2018    | 42000       | 2.28        | 1.44        | 453     | 54.47              | 2018-12-01  | 42000 | Chicken Recipe Researchers                         | People researching recipes that feature chicken.                                                                                                                      | 2018-12-11 10:35:05 | 2018-12-11 10:35:05 |
| 12     | 2018  | 12-2018    | 42237       | 2.17        | 1.43        | 472     | 52.56              | 2018-12-01  | 42237 | Ebay Shoppers                                      | Consumers shoping online at Ebay.                                                                                                                                     | 2018-12-14 21:00:00 | 2019-01-31 13:46:00 |
| 12     | 2018  | 12-2018    | 41547       | 3.07        | 1.43        | 472     | 52.56              | 2018-12-01  | 41547 | Electronics Shoppers                               | Consumers shopping for electronics products online.                                                                                                                   | 2018-12-03 11:10:04 | 2018-12-03 11:10:04 |
| 12     | 2018  | 12-2018    | 42239       | 1.74        | 1.39        | 523     | 47.44              | 2018-12-01  | 42239 | ESPN Enthusiasts                                   | Consumers watching and reading content from ESPN networks.                                                                                                            | 2018-12-14 21:00:00 | 2019-01-31 13:47:39 |
| 12     | 2018  | 12-2018    | 41554       | 2.26        | 1.37        | 545     | 45.23              | 2018-12-01  | 41554 | Northwestern Wildcats Fans                         | People reading news about the Northwestern Wildcats and watching games. These consumers are more likely to spend money on team gear.                                  | 2018-12-03 11:10:05 | 2018-12-03 11:10:05 |
| 12     | 2018  | 12-2018    | 41853       | 2.3         | 1.28        | 643     | 35.38              | 2018-12-01  | 41853 | Atlanta United Fans                                | People reading news about the Atlanta United soccer team and watching games. These consumers are more likely to spend money on team gear.                             | 2018-12-07 11:50:03 | 2018-12-07 11:50:03 |
| 12     | 2018  | 12-2018    | 41857       | 2.36        | 1.25        | 681     | 31.56              | 2018-12-01  | 41857 | Aquarium Trip Planners                             | People researching aquariums and planning a visit.                                                                                                                    | 2018-12-07 11:50:04 | 2018-12-07 11:50:04 |
| 12     | 2018  | 12-2018    | 41553       | 2.21        | 1.17        | 751     | 24.52              | 2018-12-01  | 41553 | Classical Music Enthusiasts                        | People reading about classical music and musicians.                                                                                                                   | 2018-12-03 11:10:05 | 2018-12-03 11:10:05 |
| 12     | 2018  | 12-2018    | 41549       | 1.74        | 0.9         | 938     | 5.73               | 2018-12-01  | 41549 | Bitcoin Enthusiasts                                | People reading industry news and following trends on bitcoin.                                                                                                         | 2018-12-03 11:10:05 | 2018-12-03 11:10:05 |
| 12     | 2018  | 12-2018    | 42011       | 1.83        | 0.62        | 991     | 0.4                | 2018-12-01  | 42011 | League of Legends Video Game Fans                  | People reading League of Legends news and following gaming trends.                                                                                                    | 2018-12-11 14:15:05 | 2018-12-11 14:15:05 |
| 1      | 2019  | 01-2019    | 43542       | 2.97        | 1.72        | 114     | 88.28              | 2019-01-01  | 43542 | Waterfront Vacationers                             | People researching and booking vacations at beach, river or lake destinations.                                                                                        | 2019-01-10 11:10:04 | 2019-01-10 11:10:04 |
| 1      | 2019  | 01-2019    | 43550       | 3.28        | 1.7         | 124     | 87.26              | 2019-01-01  | 43550 | Meal Kit Delivery Researchers                      | Consumers researching and subscribing to meal kit delivery services.                                                                                                  | 2019-01-10 11:10:05 | 2019-01-10 11:10:05 |
| 1      | 2019  | 01-2019    | 42964       | 2.91        | 1.39        | 331     | 65.98              | 2019-01-01  | 42964 | Biohackers                                         | People researching health and fitness methods and products to bio-hack their bodies.                                                                                  | 2019-01-07 12:00:03 | 2019-01-07 12:00:03 |
| 1      | 2019  | 01-2019    | 43546       | 2.73        | 1.37        | 357     | 63.31              | 2019-01-01  | 43546 | Personalized Gift Shoppers                         | Consumers shopping for gifts that can be personalized.                                                                                                                | 2019-01-10 11:10:04 | 2019-01-10 11:10:04 |
| 1      | 2019  | 01-2019    | 43539       | 2.4         | 1.32        | 427     | 56.12              | 2019-01-01  | 43539 | Discount Flight Searchers                          | Consumers searching for flight discounts and deals using online airfare comparison tools.                                                                             | 2019-01-10 11:10:03 | 2019-01-10 11:10:03 |
| 1      | 2019  | 01-2019    | 43545       | 2.59        | 1.25        | 517     | 46.87              | 2019-01-01  | 43545 | Homemade Gifts Crafters                            | Consumers researching breweries and purchasing craft beer.                                                                                                            | 2019-01-10 11:10:04 | 2019-01-10 11:10:04 |
| 1      | 2019  | 01-2019    | 43544       | 2.62        | 1.25        | 517     | 46.87              | 2019-01-01  | 43544 | Craft Beer Enthusiasts                             | People researching craft breweries and beers.                                                                                                                         | 2019-01-10 11:10:04 | 2019-01-10 11:10:04 |
| 1      | 2019  | 01-2019    | 43549       | 1.86        | 1           | 825     | 15.21              | 2019-01-01  | 43549 | Dog Breed Researchers                              | People researching dog breeds and breeders.                                                                                                                           | 2019-01-10 11:10:05 | 2019-01-10 11:10:05 |
| 1      | 2019  | 01-2019    | 43540       | 2.33        | 0.98        | 841     | 13.57              | 2019-01-01  | 43540 | Voice Over Internet Protocol (VoIP) Users          | Consumers researching and using VoIP technologies.                                                                                                                    | 2019-01-10 11:10:04 | 2019-01-10 11:10:04 |
| 1      | 2019  | 01-2019    | 43547       | 1.86        | 0.87        | 906     | 6.89               | 2019-01-01  | 43547 | Animal Humane Society Helpers                      | People supporting Animal Humane Society through volunteer service and donations.                                                                                      | 2019-01-10 11:10:04 | 2019-01-10 11:10:04 |
| 2      | 2019  | 02-2019    | 45518       | 5.79        | 2.52        | 8       | 99.29              | 2019-02-01  | 45518 | Volleyball Enthusiasts                             | People researching volleyball and purchasing equipment and apparel.                                                                                                   | 2019-02-04 22:00:00 | 2019-02-06 16:21:47 |
| 2      | 2019  | 02-2019    | 45670       | 5.04        | 1.91        | 79      | 92.95              | 2019-02-01  | 45670 | Womens Swimsuit Shoppers                           | Consumers shopping for womens swimsuits and beach apparel.                                                                                                            | 2019-02-06 21:00:01 | 2019-02-07 15:17:12 |
| 2      | 2019  | 02-2019    | 45725       | 4.05        | 1.82        | 96      | 91.44              | 2019-02-01  | 45725 | Trampoline Shoppers                                | Consumers researching trampoline activities and shopping for trampolines.                                                                                             | 2019-02-07 21:00:00 | 2019-02-12 10:52:31 |
| 2      | 2019  | 02-2019    | 45671       | 4.85        | 1.76        | 111     | 90.1               | 2019-02-01  | 45671 | Mens Suit Shoppers                                 | Consumers shopping for mens suits and formal attire.                                                                                                                  | 2019-02-06 21:00:01 | 2019-02-07 15:17:13 |
| 2      | 2019  | 02-2019    | 45521       | 3.91        | 1.71        | 138     | 87.69              | 2019-02-01  | 45521 | Rock Climbing Enthusiasts                          | People researching rock climbing and purchasing equipment and apparel.                                                                                                | 2019-02-04 22:00:00 | 2019-02-06 16:21:48 |
| 2      | 2019  | 02-2019    | 45676       | 4.72        | 1.7         | 147     | 86.89              | 2019-02-01  | 45676 | Scrubs Uniforms Shoppers                           | Consumers shopping for scrubs and other medical uniforms.                                                                                                             | 2019-02-06 21:00:01 | 2019-02-07 15:17:14 |
| 2      | 2019  | 02-2019    | 45677       | 4.52        | 1.69        | 152     | 86.44              | 2019-02-01  | 45677 | Sleepwear Shoppers                                 | Consumers shopping for sleepwear.                                                                                                                                     | 2019-02-06 21:00:02 | 2019-02-07 15:17:14 |
| 2      | 2019  | 02-2019    | 45516       | 3.4         | 1.55        | 243     | 78.32              | 2019-02-01  | 45516 | Basketball Enthusiasts                             | People researching basketball and purchasing equipment and apparel.                                                                                                   | 2019-02-04 22:00:00 | 2019-02-06 16:21:46 |
| 2      | 2019  | 02-2019    | 45667       | 3.77        | 1.5         | 280     | 75.02              | 2019-02-01  | 45667 | Blades and Hunting Knife Shoppers                  | Consumers shopping for blades and knives for hunting and outdoor activities.                                                                                          | 2019-02-06 21:00:01 | 2019-02-07 15:17:11 |
| 2      | 2019  | 02-2019    | 45664       | 3.4         | 1.46        | 327     | 70.83              | 2019-02-01  | 45664 | Headphone Shoppers                                 | Consumers comparing and shopping for headphones and audio products.                                                                                                   | 2019-02-06 21:00:01 | 2019-02-07 15:17:10 |
| 2      | 2019  | 02-2019    | 45519       | 3.69        | 1.46        | 327     | 70.83              | 2019-02-01  | 45519 | Competitive Wrestling Enthusiasts                  | People researching competitive wrestling and purchasing equipment and apparel.                                                                                        | 2019-02-04 22:00:00 | 2019-02-06 16:21:47 |
| 2      | 2019  | 02-2019    | 45678       | 3.27        | 1.37        | 427     | 61.91              | 2019-02-01  | 45678 | Mens Underwear Shoppers                            | Consumers shopping for mens underwear.                                                                                                                                | 2019-02-06 21:00:02 | 2019-03-12 13:05:06 |
| 2      | 2019  | 02-2019    | 45675       | 2.92        | 1.36        | 447     | 60.12              | 2019-02-01  | 45675 | Home Medical Supplies Shoppers                     | Consumers shopping for medical supplies for home healthcare.                                                                                                          | 2019-02-06 21:00:01 | 2019-03-11 12:36:24 |
| 2      | 2019  | 02-2019    | 45679       | 3.67        | 1.34        | 476     | 57.54              | 2019-02-01  | 45679 | Government Student Loan Researchers                | People researching and comparing student loan offerings from government institutions.                                                                                 | 2019-02-06 21:00:02 | 2019-02-07 15:17:14 |
| 2      | 2019  | 02-2019    | 45662       | 3.66        | 1.32        | 495     | 55.84              | 2019-02-01  | 45662 | Psychiatrists                                      | Professionals reading industry news and medical information on psychiatry.                                                                                            | 2019-02-06 21:00:01 | 2019-02-07 15:17:10 |
| 2      | 2019  | 02-2019    | 45673       | 3.04        | 1.31        | 508     | 54.68              | 2019-02-01  | 45673 | Fundraising Advocates                              | People researching fundraising organizations to offer support or donations.                                                                                           | 2019-02-06 21:00:01 | 2019-03-11 12:36:24 |
| 2      | 2019  | 02-2019    | 45524       | 2.47        | 1.18        | 691     | 38.36              | 2019-02-01  | 45524 | Mowing Equipment Shoppers                          | Consumers researching lawn and gardening equipment.                                                                                                                   | 2019-02-04 22:00:00 | 2019-02-06 16:21:49 |
| 2      | 2019  | 02-2019    | 45674       | 2.7         | 1.15        | 732     | 34.7               | 2019-02-01  | 45674 | Medical Technology News Readers                    | People reading industry news and following business trends for medical technology companies.                                                                          | 2019-02-06 21:00:01 | 2019-02-07 15:17:13 |
| 2      | 2019  | 02-2019    | 45526       | 2.58        | 1.09        | 813     | 27.48              | 2019-02-01  | 45526 | Dairy Industry New Readers                         | People reading industry news and following business trends in the dairy industry.                                                                                     | 2019-02-04 22:00:00 | 2019-02-06 16:21:49 |
| 2      | 2019  | 02-2019    | 45669       | 2.45        | 0.94        | 992     | 11.51              | 2019-02-01  | 45669 | Cocktail Recipe Researchers                        | People researching recipes for cocktails and mixed drinks.                                                                                                            | 2019-02-06 21:00:01 | 2019-02-07 15:17:12 |
| 3      | 2019  | 03-2019    | 47850       | 2.58        | 1.59        | 205     | 81.95              | 2019-03-01  | 47850 | Asheville Trip Planners                            | People researching attractions and accommodations in Asheville. These consumers are more likely to spend money on flights, hotels, lodging and local attractions.     | 2019-03-15 22:00:02 | 2019-03-21 15:33:09 |

</details>

---

### **B. Interest Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. Which interests have been present in all month_year dates in our dataset?**

```sql
with temp_Cte as(
    select interest_id, count(distinct month_year) as total_months
    from fresh_segments.interest_metrics
    where month_year2 is not Null
    group by interest_id
)

select interest_id, total_months
from temp_cte 
where total_months = 14;
```


**Result:**
| interest_id | total_months |
|-------------|--------------|
| 100         | 14           |
| 10008       | 14           |
| 10009       | 14           |
| 10010       | 14           |
| 101         | 14           |
| 102         | 14           |
| 10249       | 14           |
| 10250       | 14           |
| 10251       | 14           |
| 10284       | 14           |
| 10326       | 14           |
| 10351       | 14           |
| 107         | 14           |
| 108         | 14           |
| 10832       | 14           |
| 10833       | 14           |
| 10834       | 14           |
| 10835       | 14           |
| 10836       | 14           |
| 10837       | 14           |
| 10838       | 14           |
| 109         | 14           |
| 10953       | 14           |
| 10970       | 14           |
| 10972       | 14           |
| 10973       | 14           |
| 10974       | 14           |
| 10975       | 14           |
| 10976       | 14           |
| 10977       | 14           |
| 10978       | 14           |
| 10979       | 14           |
| 10980       | 14           |
| 10981       | 14           |
| 10988       | 14           |
| 110         | 14           |
| 11065       | 14           |
| 11066       | 14           |
| 11067       | 14           |
| 111         | 14           |
| 113         | 14           |
| 115         | 14           |
| 117         | 14           |
| 118         | 14           |
| 119         | 14           |
| 11974       | 14           |
| 11975       | 14           |
| 11977       | 14           |
| 12          | 14           |
| 12025       | 14           |
| 12026       | 14           |
| 12027       | 14           |
| 12031       | 14           |
| 12032       | 14           |
| 12132       | 14           |
| 12133       | 14           |
| 124         | 14           |
| 12490       | 14           |
| 126         | 14           |
| 12602       | 14           |
| 12820       | 14           |
| 12821       | 14           |
| 129         | 14           |
| 130         | 14           |
| 132         | 14           |
| 134         | 14           |
| 13421       | 14           |
| 13496       | 14           |
| 13497       | 14           |
| 13498       | 14           |
| 135         | 14           |
| 137         | 14           |
| 139         | 14           |
| 141         | 14           |
| 143         | 14           |
| 145         | 14           |
| 147         | 14           |
| 14895       | 14           |
| 14901       | 14           |
| 15          | 14           |
| 151         | 14           |
| 153         | 14           |
| 155         | 14           |
| 157         | 14           |
| 158         | 14           |
| 15879       | 14           |
| 16          | 14           |
| 160         | 14           |
| 161         | 14           |
| 16119       | 14           |
| 16137       | 14           |
| 16138       | 14           |
| 16196       | 14           |
| 162         | 14           |
| 163         | 14           |
| 17          | 14           |
| 171         | 14           |
| 17269       | 14           |
| 17271       | 14           |
| 17314       | 14           |
| 17318       | 14           |
| 17320       | 14           |
| 17452       | 14           |
| 17540       | 14           |
| 17669       | 14           |
| 17672       | 14           |
| 17673       | 14           |
| 17674       | 14           |
| 17729       | 14           |
| 17730       | 14           |
| 17785       | 14           |
| 17786       | 14           |
| 18          | 14           |
| 18202       | 14           |
| 18204       | 14           |
| 18347       | 14           |
| 18350       | 14           |
| 18352       | 14           |
| 18490       | 14           |
| 18619       | 14           |
| 18621       | 14           |
| 18622       | 14           |
| 18781       | 14           |
| 18782       | 14           |
| 18783       | 14           |
| 18784       | 14           |
| 18807       | 14           |
| 18923       | 14           |
| 18924       | 14           |
| 18995       | 14           |
| 18996       | 14           |
| 18997       | 14           |
| 18998       | 14           |
| 19250       | 14           |
| 19251       | 14           |
| 19294       | 14           |
| 19295       | 14           |
| 19297       | 14           |
| 19298       | 14           |
| 19338       | 14           |
| 19423       | 14           |
| 19519       | 14           |
| 19520       | 14           |
| 19578       | 14           |
| 19579       | 14           |
| 19588       | 14           |
| 19590       | 14           |
| 19592       | 14           |
| 19593       | 14           |
| 19596       | 14           |
| 19600       | 14           |
| 19602       | 14           |
| 19603       | 14           |
| 19604       | 14           |
| 19605       | 14           |
| 19610       | 14           |
| 19611       | 14           |
| 19613       | 14           |
| 19615       | 14           |
| 19617       | 14           |
| 19618       | 14           |
| 19619       | 14           |
| 19621       | 14           |
| 19622       | 14           |
| 19623       | 14           |
| 19624       | 14           |
| 19625       | 14           |
| 19628       | 14           |
| 19630       | 14           |
| 19631       | 14           |
| 19757       | 14           |
| 20          | 14           |
| 20730       | 14           |
| 20751       | 14           |
| 20754       | 14           |
| 20755       | 14           |
| 20766       | 14           |
| 20767       | 14           |
| 20768       | 14           |
| 20814       | 14           |
| 21236       | 14           |
| 21237       | 14           |
| 21238       | 14           |
| 21239       | 14           |
| 21240       | 14           |
| 21241       | 14           |
| 21242       | 14           |
| 21243       | 14           |
| 21292       | 14           |
| 21293       | 14           |
| 21326       | 14           |
| 22091       | 14           |
| 22092       | 14           |
| 22093       | 14           |
| 22094       | 14           |
| 22095       | 14           |
| 22096       | 14           |
| 22398       | 14           |
| 22400       | 14           |
| 22403       | 14           |
| 22411       | 14           |
| 22417       | 14           |
| 22419       | 14           |
| 22420       | 14           |
| 22421       | 14           |
| 22423       | 14           |
| 22427       | 14           |
| 22428       | 14           |
| 22502       | 14           |
| 23778       | 14           |
| 25          | 14           |
| 27          | 14           |
| 28          | 14           |
| 29          | 14           |
| 30          | 14           |
| 31          | 14           |
| 32486       | 14           |
| 32701       | 14           |
| 32703       | 14           |
| 32704       | 14           |
| 32705       | 14           |
| 33          | 14           |
| 33191       | 14           |
| 34          | 14           |
| 35          | 14           |
| 37          | 14           |
| 38          | 14           |
| 39          | 14           |
| 4           | 14           |
| 40          | 14           |
| 41          | 14           |
| 42          | 14           |
| 43          | 14           |
| 44          | 14           |
| 45          | 14           |
| 46          | 14           |
| 48          | 14           |
| 4857        | 14           |
| 4858        | 14           |
| 4859        | 14           |
| 4866        | 14           |
| 4870        | 14           |
| 4896        | 14           |
| 4897        | 14           |
| 4898        | 14           |
| 49          | 14           |
| 4902        | 14           |
| 4903        | 14           |
| 4908        | 14           |
| 4909        | 14           |
| 4910        | 14           |
| 4911        | 14           |
| 4912        | 14           |
| 4914        | 14           |
| 4916        | 14           |
| 4919        | 14           |
| 4921        | 14           |
| 4924        | 14           |
| 4925        | 14           |
| 4926        | 14           |
| 4927        | 14           |
| 4928        | 14           |
| 4929        | 14           |
| 4931        | 14           |
| 4932        | 14           |
| 4935        | 14           |
| 4936        | 14           |
| 4937        | 14           |
| 4940        | 14           |
| 4943        | 14           |
| 4944        | 14           |
| 5           | 14           |
| 50          | 14           |
| 54          | 14           |
| 55          | 14           |
| 56          | 14           |
| 5895        | 14           |
| 5896        | 14           |
| 5897        | 14           |
| 5898        | 14           |
| 5901        | 14           |
| 5906        | 14           |
| 5907        | 14           |
| 5909        | 14           |
| 5910        | 14           |
| 5911        | 14           |
| 5913        | 14           |
| 5914        | 14           |
| 5916        | 14           |
| 5917        | 14           |
| 5918        | 14           |
| 5921        | 14           |
| 5922        | 14           |
| 5925        | 14           |
| 5926        | 14           |
| 5929        | 14           |
| 5933        | 14           |
| 5934        | 14           |
| 5936        | 14           |
| 5938        | 14           |
| 5944        | 14           |
| 5945        | 14           |
| 5951        | 14           |
| 5952        | 14           |
| 5956        | 14           |
| 5957        | 14           |
| 5958        | 14           |
| 5960        | 14           |
| 5961        | 14           |
| 5963        | 14           |
| 5967        | 14           |
| 5968        | 14           |
| 5969        | 14           |
| 5970        | 14           |
| 5972        | 14           |
| 5991        | 14           |
| 6           | 14           |
| 60          | 14           |
| 6013        | 14           |
| 6023        | 14           |
| 6024        | 14           |
| 6029        | 14           |
| 6030        | 14           |
| 6045        | 14           |
| 6050        | 14           |
| 6051        | 14           |
| 6062        | 14           |
| 6064        | 14           |
| 6067        | 14           |
| 6077        | 14           |
| 6081        | 14           |
| 6085        | 14           |
| 6088        | 14           |
| 6095        | 14           |
| 6098        | 14           |
| 61          | 14           |
| 6107        | 14           |
| 6108        | 14           |
| 6110        | 14           |
| 6112        | 14           |
| 6115        | 14           |
| 6124        | 14           |
| 6128        | 14           |
| 6133        | 14           |
| 6134        | 14           |
| 6142        | 14           |
| 6143        | 14           |
| 6144        | 14           |
| 6148        | 14           |
| 6149        | 14           |
| 6159        | 14           |
| 6168        | 14           |
| 6169        | 14           |
| 6171        | 14           |
| 6173        | 14           |
| 6174        | 14           |
| 6177        | 14           |
| 6182        | 14           |
| 6183        | 14           |
| 6184        | 14           |
| 6189        | 14           |
| 6206        | 14           |
| 6207        | 14           |
| 6208        | 14           |
| 6209        | 14           |
| 6210        | 14           |
| 6211        | 14           |
| 6215        | 14           |
| 6216        | 14           |
| 6217        | 14           |
| 6218        | 14           |
| 6219        | 14           |
| 6220        | 14           |
| 6223        | 14           |
| 6226        | 14           |
| 6229        | 14           |
| 6230        | 14           |
| 6232        | 14           |
| 6234        | 14           |
| 6235        | 14           |
| 6237        | 14           |
| 6250        | 14           |
| 6253        | 14           |
| 6255        | 14           |
| 6257        | 14           |
| 6263        | 14           |
| 6264        | 14           |
| 6265        | 14           |
| 6266        | 14           |
| 6267        | 14           |
| 6277        | 14           |
| 6284        | 14           |
| 6285        | 14           |
| 6286        | 14           |
| 6300        | 14           |
| 6301        | 14           |
| 6302        | 14           |
| 6303        | 14           |
| 6304        | 14           |
| 6305        | 14           |
| 6308        | 14           |
| 6314        | 14           |
| 6315        | 14           |
| 6316        | 14           |
| 6317        | 14           |
| 6318        | 14           |
| 6319        | 14           |
| 6320        | 14           |
| 6321        | 14           |
| 6322        | 14           |
| 6323        | 14           |
| 6324        | 14           |
| 6325        | 14           |
| 6328        | 14           |
| 6329        | 14           |
| 6332        | 14           |
| 6333        | 14           |
| 6334        | 14           |
| 6335        | 14           |
| 6336        | 14           |
| 6337        | 14           |
| 6339        | 14           |
| 6340        | 14           |
| 6343        | 14           |
| 6345        | 14           |
| 6364        | 14           |
| 6366        | 14           |
| 6367        | 14           |
| 6378        | 14           |
| 6385        | 14           |
| 6386        | 14           |
| 6387        | 14           |
| 6389        | 14           |
| 6390        | 14           |
| 6391        | 14           |
| 6393        | 14           |
| 64          | 14           |
| 65          | 14           |
| 67          | 14           |
| 70          | 14           |
| 72          | 14           |
| 73          | 14           |
| 74          | 14           |
| 7425        | 14           |
| 7454        | 14           |
| 7461        | 14           |
| 7483        | 14           |
| 75          | 14           |
| 7527        | 14           |
| 7529        | 14           |
| 7534        | 14           |
| 7535        | 14           |
| 7536        | 14           |
| 7537        | 14           |
| 7540        | 14           |
| 7541        | 14           |
| 7542        | 14           |
| 7544        | 14           |
| 7545        | 14           |
| 7546        | 14           |
| 7557        | 14           |
| 7605        | 14           |
| 7685        | 14           |
| 77          | 14           |
| 78          | 14           |
| 79          | 14           |
| 80          | 14           |
| 82          | 14           |
| 83          | 14           |
| 84          | 14           |
| 85          | 14           |
| 86          | 14           |
| 87          | 14           |
| 88          | 14           |
| 89          | 14           |
| 94          | 14           |
| 95          | 14           |
| 96          | 14           |
| 98          | 14           |
| 99          | 14           |



**Q2. Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?**
```sql
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
```

**Result:**

| total_months | total_interests | cum_perc |
|--------------|-----------------|----------|
| 14           | 480             | 43.9560  |
| 13           | 82              | 51.4652  |
| 12           | 65              | 57.4176  |
| 11           | 94              | 66.0256  |
| 10           | 86              | 73.9011  |
| 9            | 95              | 82.6007  |
| 8            | 67              | 88.7363  |
| 7            | 90              | 96.9780  |
| 6            | 33              | 100.0000 |



**Q3. If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?**
```sql
with temp_Cte as(
    select interest_id, count(distinct month_year) as total_months
    from fresh_segments.interest_metrics
    where month_year2 is not Null
    group by interest_id
)
select count(distinct interest_id) as total_interests
    from temp_cte 
    where total_months < 6;
```



**Q4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed interest example for your arguments - think about what it means to have less months present from a segment perspective.**
```sql
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
```



**Q5. After removing these interests - how many unique interests are there for each month?**
```sql
select month_year, count(distinct interest_id) as interest_id
from fresh_segments.interest_metrics
group by month_year;
```

**Result:**
| month_year | interest_id |
|------------|-------------|
| null       | 1           |
| 01-2019    | 966         |
| 02-2019    | 1072        |
| 03-2019    | 1078        |
| 04-2019    | 1035        |
| 05-2019    | 827         |
| 06-2019    | 804         |
| 07-2018    | 709         |
| 07-2019    | 836         |
| 08-2018    | 752         |
| 08-2019    | 1062        |
| 09-2018    | 774         |
| 10-2018    | 853         |
| 11-2018    | 925         |
| 12-2018    | 986         |



</details>

---

### **C. Segment Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. Using our filtered dataset by removing the interests with less than 6 months worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any month_year? Only use the maximum composition value for each interest but you must keep the corresponding month_year**

```sql
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
```

**Result:**

| interest_id | month_year | composition |
|-------------|------------|-------------|
| 21057       | 12-2018    | 21.2        |
| 21057       | 10-2018    | 20.28       |
| 21057       | 11-2018    | 19.45       |
| 21057       | 01-2019    | 18.99       |
| 6284        | 07-2018    | 18.82       |
| 21057       | 02-2019    | 18.39       |
| 21057       | 09-2018    | 18.18       |
| 39          | 07-2018    | 17.44       |
| 77          | 07-2018    | 17.19       |
| 12133       | 10-2018    | 15.15       |
| 45524       | 05-2019    | 1.51        |
| 44449       | 04-2019    | 1.52        |
| 39336       | 05-2019    | 1.52        |
| 20768       | 05-2019    | 1.52        |
| 4918        | 05-2019    | 1.52        |
| 34083       | 06-2019    | 1.52        |
| 35742       | 06-2019    | 1.52        |
| 6127        | 05-2019    | 1.53        |
| 36877       | 05-2019    | 1.53        |
| 6314        | 06-2019    | 1.53        |





**Q2. Which 5 interests had the lowest average ranking value?**
```sql
select interest_id, avg(ranking) as ranking from 
fresh_segments.interest_metrics
group by interest_id
order by ranking 
limit 5;

```

**Result:**

| interest_id | ranking |
|-------------|---------|
| 41548       | 1.0000  |
| 42203       | 4.1111  |
| 115         | 5.9286  |
| 171         | 9.3571  |
| 4           | 11.8571 |




**Q3. Which 5 interests had the largest standard deviation in their percentile_ranking value?**

```sql
select interest_id, std(percentile_ranking) as std_ranking from 
fresh_segments.interest_metrics
group by interest_id
order by std_ranking desc
limit 5;
```

**Result:**

| interest_id | std_ranking        |
|-------------|--------------------|
| 23          | 27.54592407353566  |
| 38992       | 26.86524636363968  |
| 20764       | 26.45036264317502  |
| 43546       | 24.547785170886183 |
| 103         | 23.451445298693514 |



**Q4. For the 5 interests found in the previous question - what was minimum and maximum percentile_ranking values for each interest and its corresponding year_month value? Can you describe what is happening for these 5 interests?**
```sql
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
```

**Result:**
| interest_id | max_rank | min_rank | max_month_year | min_month_year |
|-------------|----------|----------|----------------|----------------|
| 43546       | 73.15    | 5.7      | 03-2019        | 06-2019        |
| 103         | 95.61    | 18.75    | 07-2018        | 07-2019        |
| 23          | 86.69    | 7.92     | 07-2018        | 08-2019        |
| 20764       | 86.15    | 11.23    | 07-2018        | 08-2019        |
| 38992       | 82.44    | 2.2      | 11-2018        | 07-2019        |

> These 5 interest are hitting their lowest percentile ranking after 1 year


</details>


### **D. Index Analysis**

<details>
<summary>
View solutions
</summary>

**Q1. What is the top 10 interests by the average composition for each month?**
```sql
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

```

**Result:**

| month_year | interest_id | avg_comp | ranking |
|------------|-------------|----------|---------|
| 01-2019    | 21057       | 7.66     | 1       |
| 01-2019    | 6065        | 7.05     | 2       |
| 01-2019    | 21245       | 6.67     | 3       |
| 01-2019    | 18783       | 6.46     | 4       |
| 01-2019    | 5969        | 6.46     | 5       |
| 01-2019    | 7541        | 6.44     | 6       |
| 01-2019    | 10981       | 6.16     | 7       |
| 01-2019    | 34          | 5.96     | 8       |
| 01-2019    | 10977       | 5.65     | 9       |
| 01-2019    | 21237       | 5.48     | 10      |
| 02-2019    | 21057       | 7.66     | 1       |
| 02-2019    | 18783       | 6.84     | 2       |
| 02-2019    | 5969        | 6.76     | 3       |
| 02-2019    | 7541        | 6.65     | 4       |
| 02-2019    | 6065        | 6.58     | 5       |
| 02-2019    | 10981       | 6.56     | 6       |
| 02-2019    | 34          | 6.29     | 7       |
| 02-2019    | 21245       | 6.24     | 8       |
| 02-2019    | 19620       | 6.23     | 9       |
| 02-2019    | 10977       | 5.98     | 10      |
| 03-2019    | 7541        | 6.54     | 1       |
| 03-2019    | 18783       | 6.52     | 2       |
| 03-2019    | 5969        | 6.47     | 3       |
| 03-2019    | 6065        | 6.4      | 4       |
| 03-2019    | 21245       | 6.21     | 5       |
| 03-2019    | 10981       | 6.21     | 6       |
| 03-2019    | 19620       | 6.06     | 7       |
| 03-2019    | 34          | 6.01     | 8       |
| 03-2019    | 15878       | 5.65     | 9       |
| 03-2019    | 10977       | 5.61     | 10      |
| 04-2019    | 6065        | 6.28     | 1       |
| 04-2019    | 7541        | 6.21     | 2       |
| 04-2019    | 5969        | 6.05     | 3       |
| 04-2019    | 21245       | 6.02     | 4       |
| 04-2019    | 18783       | 6.01     | 5       |
| 04-2019    | 10981       | 5.65     | 6       |
| 04-2019    | 19620       | 5.52     | 7       |
| 04-2019    | 34          | 5.39     | 8       |
| 04-2019    | 15878       | 5.3      | 9       |
| 04-2019    | 13497       | 5.07     | 10      |
| 05-2019    | 21245       | 4.41     | 1       |
| 05-2019    | 15878       | 4.08     | 2       |
| 05-2019    | 6065        | 3.92     | 3       |
| 05-2019    | 19620       | 3.55     | 4       |
| 05-2019    | 7541        | 3.34     | 5       |
| 05-2019    | 2           | 3.29     | 6       |
| 05-2019    | 5969        | 3.25     | 7       |
| 05-2019    | 15884       | 3.19     | 8       |
| 05-2019    | 10981       | 3.19     | 9       |
| 05-2019    | 18783       | 3.15     | 10      |
| 06-2019    | 6324        | 2.77     | 1       |
| 06-2019    | 4898        | 2.55     | 2       |
| 06-2019    | 6284        | 2.55     | 3       |
| 06-2019    | 18619       | 2.52     | 4       |
| 06-2019    | 77          | 2.46     | 5       |
| 06-2019    | 39          | 2.39     | 6       |
| 06-2019    | 6253        | 2.35     | 7       |
| 06-2019    | 6208        | 2.27     | 8       |
| 06-2019    | 7535        | 2.21     | 9       |
| 06-2019    | 107         | 2.2      | 10      |
| 07-2018    | 6324        | 7.36     | 1       |
| 07-2018    | 6284        | 6.94     | 2       |
| 07-2018    | 4898        | 6.78     | 3       |
| 07-2018    | 77          | 6.61     | 4       |
| 07-2018    | 39          | 6.51     | 5       |
| 07-2018    | 18619       | 6.1      | 6       |
| 07-2018    | 6208        | 5.72     | 7       |
| 07-2018    | 21060       | 4.85     | 8       |
| 07-2018    | 21057       | 4.8      | 9       |
| 07-2018    | 82          | 4.71     | 10      |
| 07-2019    | 6324        | 2.82     | 1       |
| 07-2019    | 77          | 2.81     | 2       |
| 07-2019    | 39          | 2.79     | 3       |
| 07-2019    | 6284        | 2.79     | 4       |
| 07-2019    | 4898        | 2.78     | 5       |
| 07-2019    | 18619       | 2.78     | 6       |
| 07-2019    | 6253        | 2.77     | 7       |
| 07-2019    | 7535        | 2.73     | 8       |
| 07-2019    | 6208        | 2.72     | 9       |
| 07-2019    | 7536        | 2.66     | 10      |
| 08-2018    | 6324        | 7.21     | 1       |
| 08-2018    | 6284        | 6.62     | 2       |
| 08-2018    | 77          | 6.53     | 3       |
| 08-2018    | 39          | 6.3      | 4       |
| 08-2018    | 4898        | 6.28     | 5       |
| 08-2018    | 21057       | 5.7      | 6       |
| 08-2018    | 18619       | 5.68     | 7       |
| 08-2018    | 6208        | 5.58     | 8       |
| 08-2018    | 7541        | 4.83     | 9       |
| 08-2018    | 5969        | 4.72     | 10      |
| 08-2019    | 4898        | 2.73     | 1       |
| 08-2019    | 6284        | 2.72     | 2       |
| 08-2019    | 6324        | 2.7      | 3       |
| 08-2019    | 18619       | 2.68     | 4       |
| 08-2019    | 6065        | 2.66     | 5       |
| 08-2019    | 39          | 2.59     | 6       |
| 08-2019    | 77          | 2.59     | 7       |
| 08-2019    | 4931        | 2.56     | 8       |
| 08-2019    | 6253        | 2.55     | 9       |
| 08-2019    | 6208        | 2.53     | 10      |
| 09-2018    | 21057       | 8.26     | 1       |
| 09-2018    | 21245       | 7.6      | 2       |
| 09-2018    | 7541        | 7.27     | 3       |
| 09-2018    | 5969        | 7.04     | 4       |
| 09-2018    | 18783       | 6.7      | 5       |
| 09-2018    | 10981       | 6.59     | 6       |
| 09-2018    | 34          | 6.53     | 7       |
| 09-2018    | 10977       | 6.47     | 8       |
| 09-2018    | 13497       | 6.25     | 9       |
| 09-2018    | 6065        | 6.24     | 10      |
| 10-2018    | 21057       | 9.14     | 1       |
| 10-2018    | 7541        | 7.1      | 2       |
| 10-2018    | 21245       | 7.02     | 3       |
| 10-2018    | 18783       | 7.02     | 4       |
| 10-2018    | 5969        | 6.94     | 5       |
| 10-2018    | 10981       | 6.91     | 6       |
| 10-2018    | 34          | 6.78     | 7       |
| 10-2018    | 10977       | 6.72     | 8       |
| 10-2018    | 12133       | 6.53     | 9       |
| 10-2018    | 6065        | 6.5      | 10      |
| 11-2018    | 21057       | 8.28     | 1       |
| 11-2018    | 21245       | 7.09     | 2       |
| 11-2018    | 6065        | 7.05     | 3       |
| 11-2018    | 7541        | 6.69     | 4       |
| 11-2018    | 18783       | 6.65     | 5       |
| 11-2018    | 5969        | 6.54     | 6       |
| 11-2018    | 10981       | 6.31     | 7       |
| 11-2018    | 10977       | 6.08     | 8       |
| 11-2018    | 34          | 5.95     | 9       |
| 11-2018    | 13497       | 5.59     | 10      |
| 12-2018    | 21057       | 8.31     | 1       |
| 12-2018    | 18783       | 6.96     | 2       |
| 12-2018    | 7541        | 6.68     | 3       |
| 12-2018    | 5969        | 6.63     | 4       |
| 12-2018    | 21245       | 6.58     | 5       |
| 12-2018    | 6065        | 6.55     | 6       |
| 12-2018    | 10981       | 6.48     | 7       |
| 12-2018    | 34          | 6.38     | 8       |
| 12-2018    | 10977       | 6.09     | 9       |
| 12-2018    | 21237       | 5.86     | 10      |


**Q2. For all of these top 10 interests which interest appears the most often?**

```SQL
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
```

**Result:**

| interest_id | total_interest |
|-------------|----------------|
| 6065        | 10             |


**Q3. What is the average of the average composition for the top 10 interests for each month?**

```SQL
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
```

**Result:**

| month_year | avg_comp |
|------------|----------|
| 01-2019    | 6.4      |
| 02-2019    | 6.58     |
| 03-2019    | 6.17     |
| 04-2019    | 5.75     |
| 05-2019    | 3.54     |
| 06-2019    | 2.43     |
| 07-2018    | 6.04     |
| 07-2019    | 2.76     |
| 08-2018    | 5.94     |
| 08-2019    | 2.63     |
| 09-2018    | 6.89     |
| 10-2018    | 7.07     |
| 11-2018    | 6.62     |
| 12-2018    | 6.65     |


</details>

---
<p>&copy; 2022 Mukul Sharma</p>