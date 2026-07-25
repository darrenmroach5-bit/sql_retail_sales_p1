-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1

-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,	
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15), 
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

	SELECT
		COUNT(*)
	FROM retail_sales
-- Data Cleaning
	SELECT * FROM retail_sales
	WHERE 
		quantity IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL
-- 
DELETE FROM retail_sales
	WHERE 
		quantity IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;

-- Date Exploration

-- How many sales do we have?
SELECT COUNT(*) total_sale from retail_sales

-- How many unique customers do we have?

SELECT COUNT(DISTINCT customer_id) as total_Sale from retail_sales 

SELECT DISTINCT category from retail_sales 

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calaculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique cudtomer who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

Select * from retail_sales
Where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity is more than 4 in the month of Nov-2022

select transactions_id, sale_date, category, quantity,total_sale
from retail_sales
where 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND  
	quantity >= 4

-- Q.3 Write a SQL query to calaculate the total sales (total_sale) for each category.
select 
	category, 
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
	group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as average_age
from retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	category,
	gender,
	count(*) as total_trans,
	count(retail_sales.transactions_id) as total_trans_2 
from retail_sales
group by
	category,
	gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year
select
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	avg(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
from 
	retail_sales
group by 1, 2 
ORDER BY 1, 3 DESC
	

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id,
		sum(total_sale) as total_sales 
FROM 
	retail_sales
group by 1
order by 2 DESC
LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customer who purchased items from each category.
SELECT 
	category,
	count(distinct customer_id) as unique_customers
FROM retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
( 
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift
From retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

 -- End of Project
	
